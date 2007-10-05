use strict;
use warnings;
use Benchmark;
use lib '../../lib';
use SOAP::WSDL::XSD::Typelib::Builtin::anyType;

my $obj = SOAP::WSDL::XSD::Typelib::Builtin::anyType->new();

timethese 10000, {
    'new' => sub { SOAP::WSDL::XSD::Typelib::Builtin::anyType->new() },
    'new with params' => sub { SOAP::WSDL::XSD::Typelib::Builtin::anyType->new({
        xmlns => 'urn:Test'
    }) },
    'set_FOO' => sub { $obj->set_xmlns('Test') },
};

my $data;
timethese 1000000, {
    'set_FOO' => sub { $obj->set_xmlns('Test') },
    'get_FOO' => sub { $data = $obj->get_xmlns() },
};
