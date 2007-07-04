package SOAP::WSDL::Client;
use strict;
use warnings;
use Scalar::Util qw(blessed);
use SOAP::WSDL::Envelope;
use SOAP::Lite;
use Class::Std::Storable;
use SOAP::WSDL::SAX::MessageHandler;
use SOAP::WSDL::SOAP::Typelib::Fault11;

# Package globals for speed...
my $PARSER;
my $MESSAGE_HANDLER;

my %class_resolver_of   :ATTR(:name<class_resolver> :default<()>);
my %no_dispatch_of  :ATTR(:name<no_dispatch>    :default<()>);
my %outputxml_of    :ATTR(:name<outputxml>      :default<()>);
my %proxy_of        :ATTR(:name<proxy>          :default<()>);

# TODO remove when preparing 2.01
sub outputtree { warn 'outputtree is deprecated and'
    . 'will be removed before reaching v2.01 !' }

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
    eval {
        require XML::LibXML;
        $PARSER = XML::LibXML->new();
        $MESSAGE_HANDLER = SOAP::WSDL::SAX::MessageHandler->new();
        $PARSER->set_handler( $MESSAGE_HANDLER );
    };
    if ($@) {
        require XML::SAX::ParserFactory;
        $MESSAGE_HANDLER = SOAP::WSDL::SAX::MessageHandler->new({
            base => 'XML::SAX::Base' });
        $PARSER = XML::SAX::ParserFactory->parser(
            handler => $MESSAGE_HANDLER );
    }
}

sub call {
	my $self = shift;
	my $method = shift;
	my $data = ref $_[0] ? $_[0] : { @_ };
    my $content = q{};
    my ($envelope, $soap_action);

	if (blessed $data
        && $data->isa('SOAP::WSDL::XSD::Typelib::Builtin::anyType'))
    {
        $envelope = SOAP::WSDL::Envelope->serialize( $method, $data );

        # TODO replace by something derived from binding - this is just a
        # workaround...
        $soap_action = join '/', $data->get_xmlns(), $method;

    }

	return $envelope if $self->no_dispatch();

    # warn $envelope;

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
    my $soap = SOAP::Lite->new()->proxy( $self->get_proxy() );
	my $response = $soap->transport->send_receive(
		context  => $self,              # this is provided for context
		endpoint => $soap->endpoint(),
		action   => $soap_action,       # SOAPAction, should be from binding
		envelope => $envelope,          # use custom content
	);

    # warn 'Received ' . length($response) . ' bytes of content';

	return $response if ($self->outputxml() );

    $MESSAGE_HANDLER->set_class_resolver( $self->get_class_resolver() );

    # if we had no success (Transport layer error status code)
    # or if transport layer failed
    if (! $soap->transport->is_success() ) {
        # Try deserializing response - there may be some
        if ($response) {
            eval { $PARSER->parse_string( $response ) };
            return $MESSAGE_HANDLER->get_data if not $@;
        };

        require SOAP::WSDL::SOAP::Typelib::Fault11;
        # generate & return fault if we cannot serialize response
        # or have none...
        return SOAP::WSDL::SOAP::Typelib::Fault11->new({
            faultcode => 'soap:Server',
            faultactor => 'urn:localhost',
            faultstring => 'Error sending / receiving message: '
                . $soap->transport->message()
        });
    }
    eval { $PARSER->parse_string( $response ) };

    # return fault if we cannot deserialize response
    if ($@) {
        return SOAP::WSDL::SOAP::Typelib::Fault11->new({
            faultcode => 'soap:Server',
            faultactor => 'urn:localhost',
            faultstring => "Error deserializing message: $@. \n"
                . "Message was: \n$response"
        });
    }

    return $MESSAGE_HANDLER->get_data();
} ## end sub call

1;

=pod

=head2 Features different from SOAP::Lite

SOAP::WSDL does not aim to be a complete replacement for SOAP::Lite - the
SOAP::Lite module has it's strengths and weaknesses and SOAP::WSDL is
designed as a cure for the weakness of little WSDL support - nothing more,
nothing less.

Nonetheless SOAP::WSDL mimics part of SOAP::Lite's API and behaviour,
so SOAP::Lite users can switch without looking up every method call in the
documentation.

A few things are quite differentl from SOAP::Lite, though:

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

You may even do this in a class factory - SOAP::WSDL provides the methods
for generating such interfaces.

=cut


