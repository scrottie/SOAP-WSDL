use strict;
use warnings;
use Test::More qw(no_plan);
use Scalar::Util qw(blessed);
use lib '../../../../../../lib';
use_ok qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

my $obj = SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType->new({});

ok $obj->set_xmlns('urn:SOAP-WSDL'), 'set_xmlns';
is $obj->get_xmlns(), 'urn:SOAP-WSDL', 'get_xmlns';

ok blessed $obj, 'constructor returned blessed reference';

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
    xmlns => 'urn:XSD',
    value => 'test2',
});

is $obj->get_xmlns(), 'urn:XSD', 'get_xmlns on attr value';
is $obj->get_value(), 'test2', 'get_value on attr value';

$obj->set_value(undef);

is $obj->serialize({ name => 'foo' }), '<foo ></foo >'
    , 'serialize undef value with name';
is $obj->serialize(), q{}, 'serialize undef value without name'