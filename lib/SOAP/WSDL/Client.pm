package SOAP::WSDL::Client;
use strict;
use warnings;
use Carp;

use Class::Std::Storable;
use LWP::UserAgent;
use HTTP::Request;
use Scalar::Util qw(blessed);

use SOAP::WSDL::Envelope;
use SOAP::WSDL::Expat::MessageParser;
use SOAP::WSDL::SOAP::Typelib::Fault11;

# Package globals for speed...
my $PARSER;

my %class_resolver_of   :ATTR(:name<class_resolver> :default<()>);
my %no_dispatch_of      :ATTR(:name<no_dispatch>    :default<()>);
my %outputxml_of        :ATTR(:name<outputxml>      :default<()>);
my %proxy_of            :ATTR(:name<proxy>          :default<()>);

my %fault_class_of      :ATTR(:name<fault_class>    :default<SOAP::WSDL::SOAP::Typelib::Fault11>);
my %trace_of            :ATTR(:set<trace>           :init_arg<trace>    :default<()> );
my %on_action_of        :ATTR(:name<on_action>      :default<()>);
my %content_type_of     :ATTR(:name<content_type>   :default<text/xml; charset=utf8>);  

#/#trick editors

# TODO remove when preparing 2.01
sub outputtree { warn 'outputtree is deprecated and'
    . 'will be removed before reaching v2.01 !' }

sub get_trace {
    my $ident = ident $_[0];
    return $trace_of{ $ident } 
      ? ref $trace_of{ $ident } eq 'CODE' 
        ? $trace_of{ $ident }
        : sub { warn @_ }
    : ()
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

    my $soap_action;
    my $trace_sub = $self->get_trace();
    my $envelope = SOAP::WSDL::Envelope->serialize( $method, $data );

    if (blessed $data
        && $data->isa('SOAP::WSDL::XSD::Typelib::Builtin::anyType'))
    {
        # TODO replace by something derived from binding - this is just a
        # workaround...
        $soap_action = join '/', $data->get_xmlns(), $method;
    }
    else {
        $envelope = SOAP::WSDL::Envelope->serialize( $method, $data );
        # TODO add something like SOAP::Lite's on_action mechanism
        $soap_action = $on_action_of{$ident}->( $self, $method ) if ($on_action_of{$ident});
    }   

    return $envelope if $self->no_dispatch();

    # get response via transport layer
    # maybe we should return a result with the following methods:
    # - result: returns the result of the call (like SOAP::Lite, but as
    #           object tree)
    # - header: returns the content of the SOAP header
    # - fault:  returns the result of the call if a SOAP fault is sent back
    #           by the server. Retuns undef (nothing) if the call has been
    #           processed without errors.
    my $ua = LWP::UserAgent->new();
    my $request = HTTP::Request->new( 'POST',
        $self->get_proxy(),
        [   'Content-Type', $content_type_of{ $ident },
            'Content-Length', length($envelope),
            'SOAPAction', $soap_action,
        ],
        $envelope );
  

    $trace_sub->( $request->as_string() ) if $trace_of{ $ident };       # if for speed
    my $response = $ua->request( $request );
    $trace_sub->( $response->as_string() ) if $trace_of{ $ident };      # if for speed

    return $response->content() if ($self->outputxml() );

    $PARSER->class_resolver( $self->get_class_resolver() );

    # if we had no success (Transport layer error status code)
    # or if transport layer failed
    if ($response->code() != 200) {
        # Try deserializing response - there may be some
        if ($response->content) {
            eval { $PARSER->parse( $response->content() ); };           
            return $PARSER->get_data() if (not $@);       
            warn "could not deserialize response: $@";                    
        };
        
        # generate & return fault if we cannot serialize response
        # or have none...
        return $fault_class_of{$ident}->new({
            faultcode => 'soap:Server',
            faultactor => 'urn:localhost',
            faultstring => 'Error sending / receiving message: '
                . $response->message()
                #$soap->transport->message()
        });
    }
    eval { $PARSER->parse( $response->content() ) };

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

=cut



