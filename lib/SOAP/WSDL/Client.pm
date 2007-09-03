package SOAP::WSDL::Client;
use strict;
use warnings;
use Carp;

use Class::Std::Storable;
use LWP::UserAgent;
use HTTP::Request;
use Scalar::Util qw(blessed);

use SOAP::WSDL::Factory::Serializer;
use SOAP::WSDL::Factory::Transport;
use SOAP::WSDL::Expat::MessageParser;
use SOAP::WSDL::SOAP::Typelib::Fault11;

our $VERSION='2.00_12';

# Package global for speed and memory savings.
# But should be factored out into serializer/deserializer...
my $PARSER;

my %class_resolver_of   :ATTR(:name<class_resolver> :default<()>);
my %no_dispatch_of      :ATTR(:name<no_dispatch>    :default<()>);
my %outputxml_of        :ATTR(:name<outputxml>      :default<()>);
my %transport_of        :ATTR(:name<transport>      :default<()>);
my %endpoint_of         :ATTR(:name<endpoint>       :default<()>);

my %soap_version_of     :ATTR(:get<soap_version>    :init_attr<soap_version> :default<'1.1'>);

my %fault_class_of      :ATTR(:name<fault_class>    :default<SOAP::WSDL::SOAP::Typelib::Fault11>);
my %trace_of            :ATTR(:set<trace>           :init_arg<trace>    :default<()> );
my %on_action_of        :ATTR(:name<on_action>      :default<()>);
my %content_type_of     :ATTR(:name<content_type>   :default<text/xml; charset=utf8>);  #/#trick editors
my %serializer_of       :ATTR(:name<serializer>     :default<()>);

# TODO remove when preparing 2.01
sub outputtree { warn 'outputtree is deprecated and'
    . 'will be removed before reaching v2.01 !' }

sub BUILD {
    my ($self, $ident, $attrs_of_ref) = @_;

    if (exists $attrs_of_ref->{ proxy }) {
        $self->set_proxy( $attrs_of_ref->{ proxy } );
        delete $attrs_of_ref->{ proxy };
    }
       
}

sub get_trace {
    my $ident = ident $_[0];
    return $trace_of{ $ident } 
      ? ref $trace_of{ $ident } eq 'CODE' 
        ? $trace_of{ $ident }
        : sub { warn @_ }
    : ()
}

sub get_proxy {
    return $_[0]->get_transport();
}

sub set_proxy {
    my ($self, @args_from) = @_; 
    my $ident = ident $self;

    # remember old value to return it later - Class::Std does so, too
    my $old_value = $transport_of{ $ident };

    # accept both list and list ref args
    @args_from =  @{ $args_from[0] } if ref $args_from[0];
    
    # remember endpoint
    $endpoint_of{ $ident } = $args_from[0];

    # set transport - SOAP::Lite works similar...
    $transport_of{ $ident } =  SOAP::WSDL::Factory::Transport
      ->get_transport( @args_from );

    return $old_value;
}

sub set_soap_version {
    my $ident = ident shift;

    # remember old value to return it later - Class::Std does so, too
    my $soap_version = $soap_version_of{ $ident };

    # re-setting the soap version invalidates the 
    # serializer object
    delete $serializer_of{ $ident };
    $soap_version_of{ $ident } = shift;   
    
    return $soap_version;
}

# Mimic SOAP::Lite's behaviour for getter/setter routines
SUBFACTORY: {
    no strict qw(refs);
    for (qw(class_resolver no_dispatch outputxml proxy)) {
        my $setter = "set_$_";
        my $getter = "get_$_";
        *{ $_ } = sub { my $self = shift;
            if (@_) {
                $self->$setter(@_);
                return $self;
            }
            return $self->$getter()
        };
    }
}

BEGIN {
    $PARSER = SOAP::WSDL::Expat::MessageParser->new();
}

sub call {
    my $self = shift;
    my $method = shift;
    my $ident = ident $self;
    my $data = ref $_[0] 
      ? $_[0] 
      : (@_>1) 
          ? { @_ }
          : $_[0];
    my $header = {};

    my ($soap_action, $operation);
    my $trace_sub = $self->get_trace();
    
    if (ref $method eq 'HASH') {
        $soap_action = $method->{ soap_action };
        $operation = $method->{ operation }
    }
    else {
        $operation = $method;
    }
    
    
    $serializer_of{ $ident } ||= SOAP::WSDL::Factory::Serializer->get_serializer({
        soap_version => $self->get_soap_version(),
    });

    my $envelope = $serializer_of{ $ident }->serialize({
        method => $operation, 
        body => $data,
        header => $header,
    });

    return $envelope if $self->no_dispatch();

    # try to guess soap_action if not given
    if (not defined $soap_action) {
        $soap_action = (blessed $data 
            && $data->isa('SOAP::WSDL::XSD::Typelib::Builtin::anyType')) 
            ? $soap_action = join '/', $data->get_xmlns(), $operation
            : ($on_action_of{$ident}) 
                ? $soap_action = $on_action_of{$ident}->( $self, $operation )
                : "";
    }

    # always quote SOAPAction header.
    # WS-I BP 1.0 R1109
    $soap_action =~s{\A(:?"|')?}{"}xms;
    $soap_action =~s{(:?"|')?\Z}{"}xms;

    # get response via transport layer.
    # Normally, SOAP::Lite's transport layer is used, though users 
    # may provide their own.
    my $transport = $self->get_transport(); 
    my $response = $transport->send_receive(
       endpoint => $self->get_endpoint(),
       content_type => $content_type_of{ $ident },
       envelope => $envelope,
       action => $soap_action,
       on_receive_chunk => sub {}     # optional, may be used for parsing large responses as they arrive.
                                      # might not be supported by all transport layers...
                                      # and, of course, only is of interest for chunk parsers - 
                                      # namely ExpatNB and XML::LibXML's Push parser interface...
    );

    return $response if ($self->outputxml() );

    $PARSER->class_resolver( $self->get_class_resolver() );

    # if we had no success (Transport layer error status code)
    # or if transport layer failed
    if ( ! $transport->is_success() ) {
        # Try deserializing response - there may be some
        if ( $response ) {
            eval { $PARSER->parse( $response ); };           
            return $PARSER->get_data() if (not $@);       
            return $fault_class_of{$ident}->new({
                faultcode => 'soap:Server',
                faultactor => 'urn:localhost',
                faultstring => "Error deserializing message: $@. \n"
                    . "Message was: \n$response"
            });
        };
        
        # generate & return fault if we cannot serialize response
        # or have none...
        return $fault_class_of{$ident}->new({
            faultcode => 'soap:Server',
            faultactor => 'urn:localhost',
            faultstring => 'Error sending / receiving message: '
                . $transport->message()
        });
    }
    eval { $PARSER->parse( $response ) };

    # return fault if we cannot deserialize response
    if ($@) {
        return $fault_class_of{$ident}->new({
            faultcode => 'soap:Server',
            faultactor => 'urn:localhost',
            faultstring => "Error deserializing message: $@. \n"
                . "Message was: \n$response"
        });
    }

    return $PARSER->get_data();
} ## end sub call

1;

=pod

=head1 NAME

SOAP::WSDL::Client - SOAP::WSDL's SOAP Client

=head1 METHODS

=head2 call

 $soap->call( \%method, \@parts );
 
%method is a hash with the following keys:

 Name           Description
 ----------------------------------------------------
 operation      operation name
 soap_action    SOAPAction HTTP header to use
 style          Operation style. One of (document|rpc)
 use            SOAP body encoding. One of (literal|encoded) 

The style and use keys have no influence yet.

@parts is a list containing the elements of the message parts.

For backward compatibility, call may also be called as below:

 $soap->call( $method, \@parts );

In this case, $method is the SOAP operation name, and the SOAPAction header 
is guessed from the first part's namespace and the operation name (which is 
mostly correct, but may fail). Operation style and body encoding are assumed to 
be document/literal


=head2 Configuration methods

=head3 outputxml

 $soap->outputxml(1);

When set, call() returns the raw XML of the SOAP Envelope.

=head3 set_content_type 

 $soap->set_content_type('application/xml; charset: utf8');

Sets the content type and character encoding. 

You probably should not use a character encoding different from utf8: 
SOAP::WSDL::Client will not convert the request into a different encoding 
(yet).

To leave out the encoding, just set the content type without appendet charset 
like in

 text/xml

Default:

 text/xml; charset: utf8

=head3 set_trace

 $soap->set_trace(1);
 $soap->set_trace( sub { Log::Log4perl::get_logger()->debug( @_ ) } );

When set to a true value, tracing (via warn) is enabled.

When set to a code reference, this function will be called on every 
trace call, making it really easy for you to set up log4perl logging 
or whatever you need.

=head2 Features different from SOAP::Lite

SOAP::WSDL does not aim to be a complete replacement for SOAP::Lite - the
SOAP::Lite module has it's strengths and weaknesses and SOAP::WSDL is
designed as a cure for the weakness of little WSDL support - nothing more,
nothing less.

Nonetheless SOAP::WSDL mimics part of SOAP::Lite's API and behaviour,
so SOAP::Lite users can switch without looking up every method call in the
documentation.

A few things are quite different from SOAP::Lite, though:

=head3 SOAP request data

SOAP request data may either be given as message object, or as hash ref (in
which case it will automatically be encoded into a message object).

=head3 Return values

The result from call() is not a SOAP::SOM object, but a message object.

Message objects' classes may be generated from WSDL definitions automatically
- see SOAP::WSDL::Generator::Typelib on how to generate your own WSDL based
message class library.

=head3 Fault handling

SOAP::WSDL::Client returns a fault object on errors, even on transport layer
errors.

The fault object is a SOAP1.1 fault object of the following
C<SOAP::WSDL::SOAP::Typelib::Fault11>.

SOAP::WSDL::SOAP::Typelib::Fault11 objects are false in boolean context, so
you can just do something like

 my $result = $soap->call($method, $data);

 if ($result) {
    # handle result
 }
 else {
    die $result->faultstring();
 }

=head3 outputxml

SOAP::Lite returns only the content of the SOAP body when outputxml is set
to true. SOAP::WSDL::Client returns the complete XML response.

=head3 Auto-Dispatching

SOAP::WSDL::Client does B<does not> support auto-dispatching.

This is on purpose: You may easily create interface classes by using
SOAP::WSDL::Client and implementing something like

 sub mySoapMethod {
     my $self = shift;
     $soap_wsdl_client->call( mySoapMethod, @_);
 }

You may even do this in a class factory - see L<wsdl2perl.pl> for creating 
such interfaces.

=head3 Debugging / Tracing

While SOAP::Lite features a global tracing facility, SOAP::WSDL::Client 
allows to switch tracing on/of on a per-object base.

See L<set_trace|set_trace> on how to enable tracing.

=head1 LICENSE

Copyright 2004-2007 Martin Kutter.

This file is part of SOAP-WSDL. You may distribute/modify it under 
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=head1 REPOSITORY INFORMATION

 $Rev: 188 $
 $LastChangedBy: kutterma $
 $Id: Client.pm 188 2007-09-03 15:15:19Z kutterma $
 $HeadURL: https://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL/Client.pm $
 
=cut

