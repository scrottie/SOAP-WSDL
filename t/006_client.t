#!/usr/bin/perl -w
use strict;
use warnings;
use Pod::Simple::Text;
use Test::More qw/no_plan/; # TODO: change to tests => N;
use Test::Differences;
use Data::Dumper;
use lib '../lib';
use XML::SAX::ParserFactory;

eval {
    require Test::XML;
    import Test::XML
};

use diagnostics;

use Cwd;

my $path = cwd;
$path =~s|\/t\/?$||;      # allow running from t/ and above (Build test)

use_ok(qw/SOAP::WSDL::Client/);

my $soap = SOAP::WSDL::Client->new(
    wsdl => 'file:///' . $path .'/t/acceptance/wsdl/006_sax_client.wsdl',
)->wsdlinit();

$soap->servicename('MessageGateway');

ok( $soap->no_dispatch( 1 ) , "Set no_dispatch" );
ok( $soap->readable( 1 ) , "Set readable");
ok( $soap->explain() );


my $pod = Pod::Simple::Text->new();
my $output;
$pod->output_string( \$output );
$pod->parse_string_document( $soap->explain() );

# print $output;

SKIP: {
    skip_without_test_xml();
    is_xml( $soap->call( 'EnqueueMessage' ,
        'MMessage' => {
                 'MRecipientURI' => 'mailto:test@example.com' ,
                 'MMessageContent' => 'TestContent for Message' ,
        }
    )
    , q{<SOAP-ENV:Envelope
        xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
        xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
        xmlns:tns="http://www.example.org/MessageGateway2/"
        xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" >
    <SOAP-ENV:Body ><EnqueueMessage><MMessage>
                <MRecipientURI>mailto:test@example.com</MRecipientURI>
                <MMessageContent>TestContent for Message</MMessageContent>
    </MMessage></EnqueueMessage></SOAP-ENV:Body></SOAP-ENV:Envelope>}
    , "content comparison with optional elements");
}

sub skip_without_test_xml {
    my $number = shift || 1;
    skip("Test::XML not available", $number) if (not $Test::XML::VERSION);
}

__END__

