#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
use Test::More tests => 3; # qw/no_plan/; # TODO: change to tests => N;
use lib '../lib';

eval {
    require Test::XML;
    import Test::XML
};

use Cwd;

my $path = cwd;
$path =~s|\/t\/?$||;      # allow running from t/ and above (Build test)

use_ok(qw/SOAP::WSDL/);

my $soap = SOAP::WSDL->new(
    wsdl => 'file:///' . $path .'/t/acceptance/wsdl/006_sax_client.wsdl',
    readable => 1,
    outputxml => 1, # required, if not set ::SOM serializer will be loaded on 
                    # call
)->wsdlinit();

$soap->servicename('MessageGateway');

ok( $soap->no_dispatch( 1 ) , "Set no_dispatch" );

SKIP: {
    skip_without_test_xml();
    is_xml( $soap->call( 'EnqueueMessage' , EnqueueMessage => {
            'MMessage' => {
                     'MRecipientURI' => 'mailto:test@example.com' ,
                     'MMessageContent' => 'TestContent for Message' ,
            }
        }
    )
    , q{<SOAP-ENV:Envelope
        xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" >
    <SOAP-ENV:Body ><EnqueueMessage xmlns="http://www.example.org/MessageGateway2/"><MMessage>
                <MRecipientURI>mailto:test@example.com</MRecipientURI>
                <MMessageContent>TestContent for Message</MMessageContent>
    </MMessage></EnqueueMessage></SOAP-ENV:Body></SOAP-ENV:Envelope>}
    , "content comparison with optional elements");
}

sub skip_without_test_xml {
    my $number = shift || 1;
    skip("Test::XML not available", $number) if (not $Test::XML::VERSION);
}
