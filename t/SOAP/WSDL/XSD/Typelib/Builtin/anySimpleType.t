use strict;
use warnings;
use Test::More tests => 20;
use Scalar::Util qw(blessed);
use lib '../../../../../../lib';
use_ok qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

my $obj = SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType->new();

ok blessed $obj, 'constructor returned blessed reference';

$obj = SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType->new({ value => 'test1' });

ok blessed $obj, 'constructor returned blessed reference';
is $obj->get_value(), 'test1', 'get_value';

is $obj->get_xmlns(), 'http://www.w3.org/2001/XMLSchema', 'get_xmlns';


is $obj->start_tag({ name => 'test' }), '<test >', 'start_tag';
is $obj->end_tag({ name => 'test' }), '</test >', 'end_tag';

ok $obj->set_value('test'), 'set_value';
is $obj->get_value(), 'test', 'get_value';

is "$obj", q{test}, 'serialize overloading';

ok ($obj)
    ? pass 'boolean overloading'
    : fail 'boolean overloading';

ok ! $obj->set_value(undef), 'set_value with explicit undef';
is $obj->get_value(), undef, 'get_value';

is "$obj", q{}, 'stringification overloading';

ok $obj = SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType->new({
    value => 'test2',
});

is $obj->get_value(), 'test2', 'get_value on attr value';

$obj->set_value(undef);

is $obj->serialize({ name => 'foo' }), '<foo ></foo >'
    , 'serialize undef value with name';
is $obj->serialize(), q{}, 'serialize undef value without name';


ok $obj->isa('SOAP::WSDL::XSD::Typelib::Builtin::anyType'), 'inheritance';