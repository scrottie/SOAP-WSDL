use Test::More tests => 8;
use strict;
use warnings;
use SOAP::WSDL::XSD::Typelib::Builtin::normalizedString;
my $obj = SOAP::WSDL::XSD::Typelib::Builtin::normalizedString->new();
is $obj->get_value(), undef;
$obj = SOAP::WSDL::XSD::Typelib::Builtin::normalizedString->new({});
is $obj->get_value(), undef;
ok $obj = SOAP::WSDL::XSD::Typelib::Builtin::normalizedString->new({ value => 'Test' });
is "$obj", 'Test', 'stringification';

ok $obj->isa('SOAP::WSDL::XSD::Typelib::Builtin::string'), 'inheritance';

$obj->set_value( "&\t\"Aber\"\n\r<test>");
is $obj->get_value() , '& "Aber"  <test>';
    
is $obj, '&amp; &qout;Aber&qout;  &lt;test&gt;'
    , 'escape text on serialization';
    
is $obj->serialize({ name => 'test'})
    , '<test >&amp; &qout;Aber&qout;  &lt;test&gt;</test >'
    , 'Serialization with name';