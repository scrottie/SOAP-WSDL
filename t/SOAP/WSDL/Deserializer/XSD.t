use strict;
use warnings;
package TestResolver;
sub get_typemap { {} };

package main;
use Test::More tests => 8;

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

isa_ok $obj->deserialize('rubbeldiekatz'), 'SOAP::WSDL::SOAP::Typelib::Fault11';
isa_ok $obj->deserialize('<zumsel></zumsel>'), 'SOAP::WSDL::SOAP::Typelib::Fault11';
isa_ok $obj->deserialize('<Envelope xmlns="huchmampf"></Envelope>'), 'SOAP::WSDL::SOAP::Typelib::Fault11';