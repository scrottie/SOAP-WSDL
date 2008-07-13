use strict;
use warnings;

package MyElement;
use base qw(SOAP::WSDL::XSD::Typelib::Element
    SOAP::WSDL::XSD::Typelib::Builtin::string
);

__PACKAGE__->__set_name('MyElement');
__PACKAGE__->__set_nillable(1);

package main;
use Test::More tests => 13;

my $obj;

# All constructor variants
$obj = MyElement->new();
$obj = MyElement->new({});
$obj = MyElement->new({ value => 'Test' });

is( MyElement->__get_nillable(), 1);
is $obj->__get_nillable, 1;
isa_ok $obj, 'MyElement';
is $obj->get_value(), 'Test';

$obj->set_value(undef);
is $obj->serialize_qualified, '<MyElement xsi:nil="true" xmlns="http://www.w3.org/2001/XMLSchema"/>';
is $obj->serialize, '<MyElement xsi:nil="true"/>';

$obj->__set_nillable(1);
is $obj->__get_nillable(), 1;

$obj->__set_nillable(0);
is $obj->__get_nillable(), 0;

eval { SOAP::WSDL::XSD::Typelib::Element::__get_nillable() };
like $@, qr{Cannot \s call}xms;
eval { SOAP::WSDL::XSD::Typelib::Element::__set_nillable() };
like $@, qr{Cannot \s call}xms;

is $obj->start_tag({empty => 1}), '<MyElement/>';
is $obj->start_tag({nil => 1}), '', 'empty string with nil option and NILLABLE false';
$obj->set_value('Test');


eval { is @{ $obj }, 1, 'ARRAYIFY' };
fail 'ARRAYIFY' if ($@);