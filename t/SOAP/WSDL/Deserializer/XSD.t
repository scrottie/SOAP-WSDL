use strict;
use warnings;
use Test::More tests => 5;

use SOAP::WSDL::Deserializer::XSD;

my $obj;

ok $obj = SOAP::WSDL::Deserializer::XSD->new();
ok $obj = SOAP::WSDL::Deserializer::XSD->new({
    class_resolver => 'TestResolver',
    some_other_option => 'ignored',
});

my $fault = $obj->generate_fault();

is $fault->get_faultstring(), 'Unknown error';
is $fault->get_faultactor(), 'urn:localhost';
is $fault->get_faultcode(), 'soap:Client';