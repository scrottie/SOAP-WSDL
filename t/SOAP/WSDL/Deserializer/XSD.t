use strict;
use warnings;
use Test::More tests => 5;

use SOAP::WSDL::Deserializer::SOAP11;

my $obj;

ok $obj = SOAP::WSDL::Deserializer::SOAP11->new();
ok $obj = SOAP::WSDL::Deserializer::SOAP11->new({
    class_resolver => 'TestResolver',
    some_other_option => 'ignored',
});

my $fault = $obj->generate_fault();

is $fault->get_faultstring(), 'Unknown error';
is $fault->get_faultactor(), 'urn:localhost';
is $fault->get_faultcode(), 'soap:Client';