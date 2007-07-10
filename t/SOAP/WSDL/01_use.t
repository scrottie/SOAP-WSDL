use Test::More tests => 2;
use lib '../lib';
use_ok(qw/SOAP::WSDL/);
ok( SOAP::WSDL->new(), 'Instantiated object' );