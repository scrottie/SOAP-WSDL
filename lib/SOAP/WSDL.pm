package SOAP::WSDL;
use strict;
use warnings;
use vars qw/$AUTOLOAD/;
use Scalar::Util qw(blessed);
use SOAP::WSDL::Envelope;
use SOAP::WSDL::SAX::WSDLHandler;
use base qw(SOAP::Lite);
use Data::Dumper;

our $VERSION='2.00_03';

BEGIN {
    eval {
        use XML::LibXML;
    };
    if ($@) {
        use XML::SAX::ParserFactory;
    }
}

sub AUTOLOAD {
    my $method = substr($AUTOLOAD, rindex($AUTOLOAD, '::') + 2);
    die "$method not found";
}

sub outputtree {
    my $self = shift;
    return $self->{ _WSDL }->{ outputtree } if not @_;
    return $self->{ _WSDL }->{ outputtree } = shift;
}

sub class_resolver {
    my $self = shift;
    return $self->{ _WSDL }->{ class_resolver } if not @_;
    return $self->{ _WSDL }->{ class_resolver } = shift;
}

sub wsdlinit {
    my $self = shift;
    my %opt = @_;

    my $wsdl_xml = SOAP::Schema->new( schema_url => $self->wsdl() )->access(
        $self->wsdl()
    );

    my $filter;
    my $parser = eval { XML::LibXML->new() };
    if ($parser) {
            $filter   = SOAP::WSDL::SAX::WSDLHandler->new();
        $parser->set_handler( $filter );
    }
    else {
        $filter =  SOAP::WSDL::SAX::WSDLHandler->new( base => 'XML::SAX::Base' );
        $parser = XML::SAX::ParserFactory->parser( Handler => $filter );
    }

    $parser->parse_string( $wsdl_xml );

    my $wsdl_definitions = $filter->get_data()
        or die "unable to parse WSDL";

    my $types = $wsdl_definitions->first_types()
        or die "unable to extract schema from WSDL";

    my $ns = $wsdl_definitions->get_xmlns()
        or die "unable to extract XML Namespaces" . $wsdl_definitions->to_string;
    ( %{ $ns } ) or die "unable to extract XML Namespaces";

    # setup lookup variables
    $self->{ _WSDL }->{ wsdl_definitions }  = $wsdl_definitions;
    $self->{ _WSDL }->{ serialize_options } = {
        autotype  => 0,
        readable  => $self->readable(),
        typelib   => $types,
        namespace => $ns,
    };
    $self->{ _WSDL }->{ explain_options } = {
        readable  => $self->readable(),
        wsdl      => $wsdl_definitions,
        namespace => $ns,
        typelib   => $types,
    };

    $self->servicename($opt{servicename}) if $opt{servicename};
    $self->portname($opt{portname}) if $opt{portname};
    return $self;
} ## end sub wsdlinit

sub _wsdl_get_service {
        my $self = shift;
        my $service;
        my $wsdl = $self->{ _WSDL }->{ wsdl_definitions };
        my $ns   = $wsdl->get_targetNamespace();
        if ( $self->{ _WSDL }->{ servicename } )
        {
                $service =
                  $wsdl->find_service( $ns, $self->{ _WSDL }->{ servicename } );
        }
        else
        {
                $service = $wsdl->get_service()->[ 0 ];
                warn "no servicename specified - using " . $service->get_name();
        }
        return $self->{ _WSDL }->{ service } = $service;
} ## end sub _wsdl_get_service

sub _wsdl_get_port {
        my $self    = shift;
        my $service = $self->{ _WSDL }->{ service }
          || $self->_wsdl_get_service();
        my $wsdl = $self->{ _WSDL }->{ wsdl_definitions };
        my $ns   = $wsdl->get_targetNamespace();
        my $port;
        if ( $self->{ _WSDL }->{ portname } )
        {
                $port = $service->get_port( $ns, $self->{ _WSDL }->{ portname } );
        }
        else
        {
                $port = $service->get_port()->[ 0 ];
        }
        $self->{ _WSDL }->{ port } = $port;

        # preload portType
        $self->_wsdl_get_portType();

        # Auto-set proxy - required before issuing call()
        $self->proxy( $port->get_location() );

        return $port;
} ## end sub _wsdl_get_port

sub _wsdl_get_binding {
    my $self = shift;
    my $wsdl = $self->{ _WSDL }->{ wsdl_definitions };
    my $ns   = $wsdl->get_targetNamespace();
    my $port = $self->{ _WSDL }->{ port }
        || $self->_wsdl_get_port();

    my ( $prefix, $localname ) = split /:/, $port->get_binding();

    # TODO lookup $ns instead of just using
    # the top element's targetns...
    my $binding = $wsdl->find_binding( $ns, $localname )
        or die "no binding found for ", $port->get_binding();
    return $self->{ _WSDL }->{ binding } = $binding;
} ## end sub _wsdl_get_binding

sub _wsdl_get_portType {
    my $self    = shift;
    my $wsdl    = $self->{ _WSDL }->{ wsdl_definitions };
    my $binding = $self->{ _WSDL }->{ binding }
        || $self->_wsdl_get_binding();
    my $ns = $wsdl->get_targetNamespace();
    my ( $prefix, $localname ) = split /:/, $binding->get_type(); 
    my $portType = $wsdl->find_portType( $ns, $localname );
    $self->{ _WSDL }->{ portType } = $portType;
    return $portType;
} ## end sub _wsdl_get_portType


sub _wsdl_init_methods {
    my $self = shift;
    my $wsdl = $self->{ _WSDL }->{ wsdl_definitions };
    my $ns   = $wsdl->get_targetNamespace();

    # get bindings, portType, message, part(s)
    # - use cached values where possible for speed,
    # private methods if not for clear separation...
    my $binding = $self->{ _WSDL }->{ binding }
       || $self->_wsdl_get_binding()
           || die "Can't find binding";
    my $portType = $self->{ _WSDL }->{ portType }
       || $self->_wsdl_get_portType()
           || die "Can't find portType";

    my $methodHashRef = {};

    foreach my $binding_operation (@{ $binding->get_operation() })
    {
        my $method = {};

        # get SOAP Action
        # SOAP-Action is a required HTTP Header, so we need to look it up...
        my $soap_binding_operation = $binding_operation->get_operation()->[0];
        $method->{ soap_action } = $soap_binding_operation ?
            $soap_binding_operation->get_soapAction() : $method;

        # get parts
        # 1. get operation from port
        my $operation = $portType->find_operation( $ns,
            $binding_operation->get_name() );

        # 2. get input message name
        my ( $prefix, $localname ) = split /:/,
          $operation->first_input()->get_message();

        # 3. get input message
        my $message = $wsdl->find_message( $ns, $localname )
          or die "Message {$ns}$localname not found in WSDL definition";
        
        $method->{ parts } = $message->get_part();

        # rpc / encoded methods may have a namespace specified.
        # look it up and set it...
        $method->{ namespace } = $binding_operation 
            ? do { 
                my $input = $binding_operation->first_input(); 
                $input ? $input->get_namespace() : undef;  
            }
            : undef;

        $methodHashRef->{ $binding_operation->get_name() } = $method;
    }

    $self->{ _WSDL }->{ methodInfo } = $methodHashRef;

    return $methodHashRef;
}

sub call {
    my $self = shift;
    my $method = shift;
    my $data = ref $_[0] ? $_[0] : { @_ };

    my $content = q{};
    my $envelope;
    my $methodInfo;

    if (blessed $data
        && $data->isa('SOAP::WSDL::XSD::Typelib::Builtin::anyType'))
    {
        $envelope = SOAP::WSDL::Envelope->serialize( $method, $data , { readable => 1 });

        # TODO replace by something derived from binding - this is just a
        # workaround...
        $methodInfo->{ soap_action }
            = join '/', $data->get_xmlns(), $method;
    }
    else {
        my $methodLookup = $self->{ _WSDL }->{ methodInfo }
            || $self->_wsdl_init_methods();

        $methodInfo = $methodLookup->{ $method };
        my $partListRef = $methodInfo->{ parts };

        # set serializer options
        # TODO allow custom options here
        my $opt = $self->{ _WSDL }->{ serialize_options };

        # set response target namespace
        # TODO make rpc-encoded encoding recognise this namespace
        #    $opt->{ targetNamespace } = $soap_binding_operation ?
        #        $operation->input()->namespace() : undef;

        # serialize content
        # TODO create surrounding element for rpc-encoded messages
        foreach my $part ( @{ $partListRef } ) {
            $content .= $part->serialize( $method, $data, $opt );
        }
        $envelope = SOAP::WSDL::Envelope->serialize( $method, $content , $opt );
    };


        if ( $self->no_dispatch() )
        {
                return $envelope;
        } ## end if ( $self->no_dispatch...

        # get response via transport layer
        # TODO remove dependency from SOAP::Lite and use a
    # SAX-based filter using XML::LibXML to get the
    # result.
    # Filter should have the following methods:
    # - result: returns the result of the call (like SOAP::Lite, but as
    #           perl data structure)
    # - header: returns the content of the SOAP header
    # - fault:  returns the result of the call if a SOAP fault is sent back
    #           by the server. Retuns undef (nothing) if the call has been
    #           processed without errors.
        my $response = $self->transport->send_receive(
                context  => $self,              # this is provided for context
                endpoint => $self->endpoint(),
                action   => $methodInfo->{ soap_action },   # SOAPAction from binding
                envelope => $envelope,          # use custom content
        );

        return $response if ($self->outputxml() );

    if ($self->outputtree()) {

        my ($parser, $handler);     # replace by globals - singleton is faster
        if (not $parser) {
            require SOAP::WSDL::SOAP::Typelib::Fault11;
            require SOAP::WSDL::SAX::MessageHandler;
            require XML::LibXML;
            $handler = SOAP::WSDL::SAX::MessageHandler->new(
                { class_resolver => $self->class_resolver() },
            );
            $parser = XML::LibXML->new();
            $parser->set_handler( $handler);
        }

        # if we had no success (Transport layer error status code)
        # or if transport layer failed
        if (! $self->transport->is_success() ) {
            # Try deserializing response - there may be some
            if ($response) {
                eval { $parser->parse_string( $response ) };
                return $handler->get_data if not $@;
            };

            # generate & return fault if we cannot serialize response
            # or have none...
            return SOAP::WSDL::SOAP::Typelib::Fault11->new({
                faultcode => 'soap:Server',
                faultactor => 'urn:localhost',
                faultstring => 'Error sending / receiving message: '
                    . $self->transport->message()
            });
        }

        eval { $parser->parse_string( $response ) };

        # return fault if we cannot deserialize response
        if ($@) {
            return SOAP::WSDL::SOAP::Typelib::Fault11->new({
                faultcode => 'soap:Server',
                faultactor => 'urn:localhost',
                faultstring => "Error deserializing message: $@. \n"
                    . "Message was: \n$response"
            });
        }

        return $handler->get_data();
    }

        # deserialize and store result
        my $result = $self->{ '_call' } =
          eval { $self->deserializer->deserialize( $response ) }
          if $response;

        if (
                !$self->transport->is_success ||  # transport fault
                $@                            ||  # not deserializible
                                                  # fault message even if transport OK
                  # or no transport error (for example, fo TCP, POP3, IO implementations)
                UNIVERSAL::isa( $result => 'SOAP::SOM' ) && $result->fault
          )
        {
                return $self->{ '_call' } = (
                        $self->on_fault->(
                                $self, $@ ? $@ . ( $response || '' ) : $result
                          )
                          || $result
                );
                # ? # trick editors
        } ## end if ( !$self->transport...

        return unless $response;    # nothing to do for one-ways
        return $result;
} ## end sub call

sub explain {
        my $self = shift;
        my $opt  = $self->{ _WSDL }->{ explain_options };

        return $self->{ _WSDL }->{ wsdl_definitions }->explain( $opt );
} ## end sub explain

sub _load_method {
    my $method = shift;
    no strict "refs";
    *$method = sub {
        my $self = shift;
        return ( @_ ) ? $self->{ _WSDL }->{ $method } = shift
            : $self->{ _WSDL }->{ $method }
    };
} ## end sub _load_method

&_load_method( 'no_dispatch' );
&_load_method( 'wsdl' );

sub servicename {
        my $self = shift;
        return $self->{ _WSDL }->{ servicename } if ( not @_ );
        $self->{ _WSDL }->{ servicename } = shift;

        my $ns = $self->{ _WSDL }->{ wsdl_definitions }->get_targetNamespace();

        $self->{ _WSDL }->{ service } =
          $self->{ _WSDL }->{ wsdl_definitions }
          ->find_service( $ns, $self->{ _WSDL }->{ servicename } )
          or die "No such service: " . $self->{ _WSDL }->{ servicename };
        return $self;
} ## end sub servicename

sub portname {
        my $self = shift;
        return $self->{ _WSDL }->{ portname } if ( not @_ );
        $self->{ _WSDL }->{ portname } = shift;

        my $ns = $self->{ _WSDL }->{ wsdl_definitions }->get_targetNamespace();

        $self->{ _WSDL }->{ port } =
          $self->{ _WSDL }->{ service }
          ->find_port( $ns, $self->{ _WSDL }->{ portname } )
          or die "No such port: " . $self->{ _WSDL }->{ portname };
        return $self;
} ## end sub portname

1;

__END__

=pod

=head1 NAME

SOAP::WSDL - SOAP with WSDL support

=head1 SYNOPSIS

 my $soap = SOAP::WSDL->new(
    wsdl => 'file://bla.wsdl',
    readable => 1,
 )->wsdlinit();
 
 my $result = $soap->call('MyMethod', %data);
 
=head1 DESCRIPTION

SOAP::WSDL provides easy access to Web Services with WSDL descriptions.

The WSDL is parsed and stored in memory. 

Your data is serialized according to the rules in the WSDL and sent via 
SOAP::Lite's transport mechanism.

=head1 METHODS

=head2 servicename

 $soap->servicname('Name');

Sets the service to operate on. If no service is set via servicename, the 
first service found is used.

Returns the soap object, so you can chain calls like

 $soap->servicename->('Name')->portname('Port');

=head2 _wsdl_init_methods

=over

=item DESCRIPTION

Creates a lookup table containing the information required for all methods
specified for the service/port selected.

The lookup table is used by L<call|call>.

=back


=head1 Differences to previous versions

=over 

=item * WSDL handling

SOAP::WSDL 2 is a complete rewrite. While SOAP::WSDL 1.x attempted to 
process the WSDL file on the fly by using XPath queries, SOAP:WSDL 2 uses a 
SAX filter for parsing the WSDL and building up a object tree representing 
it's content.

The object tree has two main functions: It knows how to serialize data passed 
as hash ref, and how to render the WSDL elements found into perl classes.

Yup your're right, there's a builting code generation facility. 

=item * outputxml

call() with outputtxml set to true now returns the complete SOAP 
envelope, not only the body's content.

=back

=head1 Differences to SOAP::Lite

=head2 Auto-Dispatching

SOAP::WSDL does B<does not> support auto-dispatching.

This is on purpose: You may easily create interface classes by using
SOAP::WSDL and implementing something like

 sub mySoapMethod {
     my $self = shift;
     $soap_wsdl_client->call( mySoapMethod, @_);
 }

You may even do this in a class factory - SOAP::WSDL provides the methods
for generating such interfaces.

SOAP::Lite's autodispatching mechanism is - though convenient - a constant
source of errors: Every typo in a method name gets caught by AUTOLOAD and
may lead to unpredictable results.

=head1 Bugs and Limitations

=over 

=item * readable

readable() must be called before calling wsdlinit. This is a bug.

=item * Unsupported XML Schema definitions

The following XML Schema definitions are not supported:

 choice
 group
 union
 simpleContent
 complexContent

=item * Serialization of hash refs dos not work for ambiguous values

If you have list elements with multiple occurences allowed, SOAP::WSDL 
has no means of finding out which variant you meant.

Passing in item => [1,2,3] could serialize to  

 <item>1 2</item><item>3</item>
 <item>1</item><item>2 3</item>

Ambiguos data can be avoided by passing an object tree as data.

=item * XML Schema facets

Almost all XML schema facets are not yet implemented. The only facets 
currently implemented are:

 fixed
 default

The following facets have no influence yet:

 minLength
 maxLength
 minInclusive
 maxInclusive
 minExclusive
 maxExclusive
 pattern
 enumeration

=back

=head1 LICENSE

Copyright 2004-2007 Martin Kutter.

This file is part of SOAP-WSDL. You may distribute/modify it under 
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=cut

