#!/usr/bin/perl
use Test::More qw(no_plan);
use strict;
use lib 'lib/';
use lib '../lib/';
use lib 't/lib';

use_ok qw(SOAP::WSDL::XSD::Typelib::Element);
use_ok qw( MyElement );
use_ok qw( SOAP::WSDL::Client );
# simple type derived from builtin via restriction

my $obj = MyAtomicComplexTypeElement->new({ test=> 'Test', test2 => 'Test2'});
ok $obj->isa('SOAP::WSDL::XSD::Typelib::Builtin::anyType')
    , 'inherited class';

ok $obj->get_test->isa('SOAP::WSDL::XSD::Typelib::Builtin::string')
    , 'element isa'; 

is $obj, '<MyAtomicComplexTypeElement xmlns="urn:Test" ><MyTestElement >Test</MyTestElement>'
    . '<MyTestElement2 >Test2</MyTestElement2></MyAtomicComplexTypeElement>'
    , 'stringification';

my $soap = SOAP::WSDL::Client->new();
$soap->proxy('http://bla');
$soap->no_dispatch(1);

is $soap->call('Test', $obj), q{<SOAP-ENV:Envelope }
    . q{xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" }
    . q{xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" >}
    . q{<SOAP-ENV:Body><MyAtomicComplexTypeElement xmlns="urn:Test" >}
    . q{<MyTestElement >Test</MyTestElement>}
    . q{<MyTestElement2 >Test2</MyTestElement2>}
    . q{</MyAtomicComplexTypeElement></SOAP-ENV:Body></SOAP-ENV:Envelope>}
    , 'SOAP Envelope generation with objects';