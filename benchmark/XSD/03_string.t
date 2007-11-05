use strict;
use warnings;
use Benchmark;
use lib '../../lib';
use SOAP::WSDL::XSD::Typelib::Builtin::string;

my $obj = SOAP::WSDL::XSD::Typelib::Builtin::string->new();

timethese 20000, {
    'new' => sub { SOAP::WSDL::XSD::Typelib::Builtin::string->new() },
    'new + params' => sub { SOAP::WSDL::XSD::Typelib::Builtin::string->new({
        value => 'Teststring'
    }) },
};

$obj->set_value('Foobar');
timethese 20000, {
    serialize => sub { $obj->serialize() }
};

my $data;
timethese 1000000, {
    'set_FOO' => sub { $obj->set_value('Test') },
    'get_FOO' => sub { $data = $obj->get_value() },
};
