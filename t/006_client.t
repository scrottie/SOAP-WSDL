#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
use Test::More tests => 17; # qw/no_plan/; # TODO: change to tests => N;
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
    outputxml => 1, # required, if not set ::SOM serializer will be loaded on 
                    # call
)->wsdlinit();

$soap->servicename('MessageGateway');

ok( $soap->no_dispatch( 1 ) , "Set no_dispatch" );
ok $soap->get_client();
ok ! $soap->get_client()->get_proxy();

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

# test whether call sets proxy
$soap->call( 'EnqueueMessage' , EnqueueMessage => {
            'MMessage' => {
                     'MRecipientURI' => 'mailto:test@example.com' ,
                     'MMessageContent' => 'TestContent for Message' ,
            }
        }
    );
ok $soap->get_client()->get_proxy();
ok $soap->get_client()->get_transport();

# serializer & deserializer must be set after call()
ok $soap->get_client()->get_serializer();
# ok $soap->get_client()->get_deserializer(); # no deserializer with outputxml

# set_soap_version invalidates serializer and deserializer
ok $soap->get_client()->set_soap_version('1.1');
ok ! $soap->get_client()->get_serializer();

$soap->call( 'EnqueueMessage' , EnqueueMessage => {
            'MMessage' => {
                     'MRecipientURI' => 'mailto:test@example.com' ,
                     'MMessageContent' => 'TestContent for Message' ,
            }
        }
    );

# serializer & deserializer come back after call()
ok $soap->get_client()->get_serializer();
# ok $soap->get_client()->get_deserializer(); # no deserializer with outputxml


SKIP: {
    eval "require SOAP::Lite"
        or skip 'cannot test SOAP::Deserializer::SOM without SOAP::Lite', 4;
    require SOAP::WSDL::Transport::Loopback;
    $soap->outputxml(0);
    $soap->no_dispatch(0);
    ok my $result = $soap->call( 'EnqueueMessage' , EnqueueMessage => {
            'MMessage' => {
                     'MRecipientURI' => 'mailto:test@example.com' ,
                     'MMessageContent' => 'TestContent for Message' ,
            }
        }
    );    
    ok $result->isa('SOAP::SOM');
    is $result->result()->{MMessageContent}, 'TestContent for Message';
    is $result->result()->{MRecipientURI}, 'mailto:test@example.com';
};

use_ok 'SOAP::WSDL::Client';
my $client = SOAP::WSDL::Client->new();
eval {
    $client->set_proxy([ 'http://example.org', keep_alive => 1  ]);
    $client->set_proxy('http://example.org', keep_alive => 1 );
};
ok ! $@;