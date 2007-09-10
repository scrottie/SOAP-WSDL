use strict;
use warnings;
use Benchmark;
use lib '../../lib';
use SOAP::WSDL::XSD::Typelib::Builtin::string;

my $obj = SOAP::WSDL::XSD::Typelib::Builtin::string->new();

timethese 10000, {
    'new' => sub { SOAP::WSDL::XSD::Typelib::Builtin::string->new() },
    'new + params' => sub { SOAP::WSDL::XSD::Typelib::Builtin::string->new({
        xmlns => 'urn:Test',
        value => 'Teststring'
    }) },
    'set_FOO' => sub { $obj->set_xmlns('Test') },
};

my $data;
timethese 1000000, {
    'set_FOO' => sub { $obj->set_xmlns('Test') },
    'get_FOO' => sub { $data = $obj->get_xmlns() },
};
