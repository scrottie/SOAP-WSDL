use Test::More tests => 3;
use lib '../lib';
use_ok(qw/SOAP::WSDL/);
ok( SOAP::WSDL->new(), 'Instantiated object' );

eval { SOAP::WSDL->new( grzlmpfh => 'unknown')};
ok $@, 'die on illegal parameter';