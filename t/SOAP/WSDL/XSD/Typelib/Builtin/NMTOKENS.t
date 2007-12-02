use Test::More tests => 9;
use strict;
use warnings;
use SOAP::WSDL::XSD::Typelib::Builtin::NMTOKENS;
my $NMTOKENS = SOAP::WSDL::XSD::Typelib::Builtin::NMTOKENS->new();
is $NMTOKENS->get_value(), undef;
$NMTOKENS = SOAP::WSDL::XSD::Typelib::Builtin::NMTOKENS->new({});
is $NMTOKENS->get_value(), undef;
ok $NMTOKENS = SOAP::WSDL::XSD::Typelib::Builtin::NMTOKENS->new({ value => [ 127 , 'Test' ] });

is $NMTOKENS->serialize, '127 Test', 'stringification';

ok $NMTOKENS = SOAP::WSDL::XSD::Typelib::Builtin::NMTOKENS->new({ value => 'Test' });
is "$NMTOKENS", "Test", 'stringification';

$NMTOKENS = SOAP::WSDL::XSD::Typelib::Builtin::NMTOKENS->new({ value => undef });
is $NMTOKENS, undef, 'stringification';


ok $NMTOKENS->isa('SOAP::WSDL::XSD::Typelib::Builtin::NMTOKEN'), 'inheritance';
ok $NMTOKENS->isa('SOAP::WSDL::XSD::Typelib::Builtin::list'), 'inheritance';