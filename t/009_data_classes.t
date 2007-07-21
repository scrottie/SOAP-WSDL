#!/usr/bin/perl -w
use strict;
use Test::More tests => 5;
use lib 't/lib';
use lib '../lib';
use lib 'lib';
use XML::Simple;
use SOAP::WSDL::SAX::WSDLHandler;
use Cwd;
use XML::LibXML::SAX;
use_ok(qw/SOAP::WSDL::SAX::MessageHandler/);

use SOAP::WSDL;
use SOAP::WSDL::XSD::Typelib::Builtin;
my $path = cwd;
$path =~s|\/t\/?$||;      # allow running from t/ and above (Build test)

$XML::Simple::PREFERRED_PARSER = 'XML::Parser';

my $filter;
ok($filter = SOAP::WSDL::SAX::MessageHandler->new( {
    class_resolver => FakeResolver->new(),
} ), "Object creation");

my $parser = XML::LibXML->new();
$parser->set_handler( $filter );

$parser->parse_string( xml() );

# print $filter->get_data();
# print $filter->get_data()->get_MMessage()->_DUMP();

if($filter->get_data()->get_MMessage()->get_MDeliveryReportRecipientURI()) {
    pass "bool context overloading";
}
else
{
    fail "bool context overloading"
}

my $soap = SOAP::WSDL->new(
    readable => 1,
    wsdl => 'file:///' . $path .'/t/acceptance/wsdl/006_sax_client.wsdl',
)->wsdlinit();

$soap->servicename('MessageGateway');

ok( $soap->no_dispatch( 1 ) , "Set no_dispatch" );
ok( $soap->readable( 0 ) , "Set readable");

sub xml {
q{<SOAP-ENV:Envelope
        xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
        xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
        xmlns:tns="http://www.example.org/MessageGateway2/"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" >
    <SOAP-ENV:Body ><EnqueueMessage><MMessage>
                <MRecipientURI>mailto:test@example.com</MRecipientURI>
                <MMessageContent>TestContent for Message</MMessageContent>
                <MMessageContent>TestContent for Message 2</MMessageContent>
                <MSenderAddress>martin.kutter@example.com</MSenderAddress>
                <MDeliveryReportRecipientURI>mailto:test@example.com</MDeliveryReportRecipientURI>
    </MMessage></EnqueueMessage></SOAP-ENV:Body></SOAP-ENV:Envelope>};
}

# data classes reside in t/lib/Typelib/
BEGIN {
    package FakeResolver;
    {
        my %class_list = (
            'EnqueueMessage' => 'Typelib::TEnqueueMessage',
            'EnqueueMessage/MMessage' => 'Typelib::TMessage',
            'EnqueueMessage/MMessage/MRecipientURI' => 'SOAP::WSDL::XSD::Typelib::Builtin::anyURI',
            'EnqueueMessage/MMessage/MMessageContent' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
            'EnqueueMessage/MMessage/MSenderAddress' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
            'EnqueueMessage/MMessage/MMessageContent' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
            'EnqueueMessage/MMessage/MDeliveryReportRecipientURI' => 'SOAP::WSDL::XSD::Typelib::Builtin::anyURI',
        );

        sub new { return bless {}, 'FakeResolver' };

        sub get_class {
            my $name = join('/', @{ $_[1] });
            return ($class_list{ $name }) ? $class_list{ $name }
                : warn "no class found for $name";
        };
    };


};
