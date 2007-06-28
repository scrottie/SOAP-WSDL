#!/usr/bin/perl
use Test::More qw(no_plan);
use strict;
use lib 'lib/';
use lib '../lib/';
use lib 't/lib';

use_ok qw(SOAP::WSDL::XSD::Typelib::Element);
use_ok qw( MyElement );
# simple type derived from builtin via restriction
my $obj = MyElement->new({ value => 'test'});
ok $obj->isa('SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType')
    , 'inherited class';
is $obj, '<MyElementName xmlns="urn:Test" >test</MyElementName>', 'stringification';

$obj = MyAtomicComplexTypeElement->new({ test=> 'Test', test2 => 'Test2'});
ok $obj->isa('SOAP::WSDL::XSD::Typelib::Builtin::anyType')
    , 'inherited class';

ok $obj->get_test->isa('SOAP::WSDL::XSD::Typelib::Builtin::string')
    , 'element isa';

is $obj, '<MyAtomicComplexTypeElement xmlns="urn:Test" ><MyTestElement >Test</MyTestElement>'
    . '<MyTestElement2 >Test2</MyTestElement2></MyAtomicComplexTypeElement>'
    , 'stringification';

$obj = MyElement->new({ value => undef});
ok $obj->isa('SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType')
    , 'inherited class';

# is $obj, '<MyElementName xmlns="urn:Test" xsi:nil="true" />', 'nillable stringification';

$obj = MyAtomicComplexTypeElement->new({ test=> 'Test', test2 => [ 'Test2', 'Test3' ]});
ok $obj->isa('SOAP::WSDL::XSD::Typelib::Builtin::anyType')
    , 'inherited class';
is $obj, '<MyAtomicComplexTypeElement xmlns="urn:Test" ><MyTestElement >Test</MyTestElement>'
    . '<MyTestElement2 >Test2</MyTestElement2>'
    . '<MyTestElement2 >Test3</MyTestElement2>'
    . '</MyAtomicComplexTypeElement>'
    , 'multi value stringification';


__END__

# simple type derived from builtin via list
$obj = MySimpleListType->new({ value => [ 'test', 'test2' ]});
ok $obj->isa('SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType')
    , 'inherited class';
ok $obj->isa('SOAP::WSDL::XSD::Typelib::Builtin::list')
    , 'inherited class';
is $obj, 'test test2', 'stringification';

# simple type derived from atomic simple type (restriction)
$obj = MyAtomicSimpleType->new({ value => 'test' });
ok $obj->isa('MySimpleType') , 'inherited class';
ok $obj->isa('SOAP::WSDL::XSD::Typelib::SimpleType::restriction')
    , 'inherited class';
is $obj, 'test', 'stringification';

# simple type derived from atomic simple type (list)
$obj = MyAtomicSimpleListType->new({ value => [ 'test', 'test2' ] });
ok $obj->isa('MySimpleListType') , 'inherited class';
ok $obj->isa('SOAP::WSDL::XSD::Typelib::SimpleType::restriction')
    , 'inherited class';
is $obj, 'test test2', 'stringification';
