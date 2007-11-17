use Test::More tests => 19;
use strict;
use warnings;
use SOAP::WSDL::XSD::Typelib::Builtin::boolean;

my $bool;
$bool = SOAP::WSDL::XSD::Typelib::Builtin::boolean->new();
ok defined $bool;

is "$bool", '', 'serialized undef to empty string';

$bool = SOAP::WSDL::XSD::Typelib::Builtin::boolean->new({});
ok defined $bool;

ok $bool = SOAP::WSDL::XSD::Typelib::Builtin::boolean->new({ value => 'true' });

is $bool * 1 , 1,  'numerification';
ok $bool, 'boolification';

is "$bool", 'true', 'stringification';

$bool->set_value('1');
is $bool, 'true';
$bool ? pass 'boolification' : fail 'boolification';

$bool->set_value('0');
is $bool, 'false';
! $bool ? pass 'boolification' : fail 'boolification';

$bool->set_value(undef);
is $bool, 'false';
! $bool ? pass 'boolification' : fail 'boolification';


$bool->set_value('false');

if ($bool) {
    fail 'boolification';
}
else {
    pass 'boolification';
}

is "$bool", 'false', 'stringification';

ok $bool->isa('SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType'), 'inheritance';

is $bool->serialize({ name => 'test'}), '<test >false</test >';
is $bool->serialize(), 'false';

$bool->delete_value();
is "$bool", '', 'serialized undef to empty string';