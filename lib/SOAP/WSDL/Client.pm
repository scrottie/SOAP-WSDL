package SOAP::WSDL::Client;
use strict;
use warnings;
use vars qw/$AUTOLOAD/;
use Scalar::Util qw(blessed);
use SOAP::WSDL::Envelope;
use SOAP::WSDL::SAX::WSDLHandler;

BEGIN {
    eval { 
        use XML::LibXML;   
    };
    if ($@) {
        use XML::SAX::ParserFactory;        
    }
}

use base qw/SOAP::Lite/;

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

sub wsdlinit
{
	my $self = shift;

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
		readable  => 1,
		typelib   => $types,
		namespace => $ns,
	};
	$self->{ _WSDL }->{ explain_options } = {
		readable  => 1,
		wsdl      => $wsdl_definitions,
		namespace => $ns,
		typelib   => $types,
	};

	return $self;
} ## end sub wsdlinit

sub _wsdl_get_service
{
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

sub _wsdl_get_port
{
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

sub _wsdl_get_binding
{
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

sub _wsdl_get_portType
{
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

=pod

=head2 _wsdl_init_methods

=over

=item DESCRIPTION

Creates a lookup table containing the information required for all methods
specified for the service/port selected.

The lookup table is used by L<call|call>.

=back

=cut

sub _wsdl_init_methods {
    my $self = shift;
    my $wsdl = $self->{ _WSDL }->{ wsdl_definitions };
    my $ns   = $wsdl->get_targetNamespace();

    # get bindings, portType, message, part(s)
    # - use cached values where possible for speed,
    # private methods if not for clear separation...
    my $binding = $self->{ _WSDL }->{ binding }
       || $self->_wsdl_get_binding();
    my $portType = $self->{ _WSDL }->{ portType }
       || $self->_wsdl_get_portType();

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
          $operation->get_input()->[0]->get_message();
        # 3. get input message
        my $message = $wsdl->find_message( $ns, $localname );
        $method->{ parts } = $message->get_part();

        # rpc / encoded methods may have a namespace specified.
        # look it up and set it...
        $method->{ namespace } = $binding_operation ?
            $binding_operation->get_input()->[0]->get_namespace() : undef;

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
        $envelope = SOAP::WSDL::Envelope->serialize( $method, $data );
        
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
        foreach my $part ( @{ $partListRef } )
        {
            $content .= $part->serialize( $method, $data, $opt );
        }
        $envelope = SOAP::WSDL::Envelope->serialize(
        $method, $content , $opt );
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

sub explain
{
	my $self = shift;
	my $opt  = $self->{ _WSDL }->{ explain_options };

	return $self->{ _WSDL }->{ wsdl_definitions }->explain( $opt );
} ## end sub explain

sub _load_method
{
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

sub servicename
{
	my $self = shift;
	return $self->{ _WSDL }->{ servicename } if ( not @_ );
	$self->{ _WSDL }->{ servicename } = shift;

	my $ns = $self->{ _WSDL }->{ wsdl_definitions }->get_targetNamespace();

	$self->{ _WSDL }->{ service } =
	  $self->{ _WSDL }->{ wsdl_definitions }
	  ->find_service( $ns, $self->{ _WSDL }->{ servicename } )
	  or die "No such service: " . $self->{ _WSDL }->{ servicename };
} ## end sub servicename

sub portname
{
	my $self = shift;
	return $self->{ _WSDL }->{ portname } if ( not @_ );
	$self->{ _WSDL }->{ portname } = shift;

	my $ns = $self->{ _WSDL }->{ wsdl_definitions }->targetNamespace();

	$self->{ _WSDL }->{ port } =
	  $self->{ _WSDL }->{ service }
	  ->get_port( $ns, $self->{ _WSDL }->{ portname } )
	  or die "No such port: " . $self->{ _WSDL }->{ portname };
} ## end sub portname

=pod

=head1 Auto-Dispatching

SOAP::WSDL::Client does B<does not> support auto-dispatching.

This is on purpose: You may easily create interface classes by using 
SOAP::WSDL::Client and implementing something like

 sub mySoapMethod {
     my $self = shift;
     $soap_wsdl_client->call( mySoapMethod, @_);
 }

You may even do this in a class factory - SOAP::WSDL provides the methods 
for generating such interfaces.

SOAP::Lite's autodispatching mechanism is - though convenient - a constant 
source of errors: Every typo in a method name gets caught by AUTOLOAD and 
may lead to unpredictable results. 

=cut

sub AUTOLOAD
{
    my $method = substr($AUTOLOAD, rindex($AUTOLOAD, '::') + 2);
    die "$method not found";
}
