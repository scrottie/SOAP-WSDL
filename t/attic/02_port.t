use Test::More tests => 9;
use Cwd;
use File::Basename;

use lib '../lib';

use_ok(qw/SOAP::WSDL/);

# chdir to my location
my $cwd = cwd;
my $path = dirname( $0 );
my $soap = undef;
my $name = basename( $0 );
$name =~s/\.(t|pl)$//;
chdir $path;

$path = cwd;

#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file:///' . $path . '/acceptance/wsdl/' . $name . '.wsdl'
), 'Instantiated object' );
ok( ($soap->servicename('testService') eq 'testService' ) );
ok( ($soap->portname('testPort') eq 'testPort' ) );
ok( $soap->wsdlinit(), 'parsed WSDL' );

ok( ($soap->portname() eq 'testPort' ), 
"Found first port definition" );

ok( ($soap->portname('testPort2') eq 'testPort2' ), 
"Found second port definition (based on URL)" );
ok( $soap->wsdlinit(), 'parsed WSDL' );
ok( ($soap->portname('testPort3') eq 'testPort3' ), 
"Found third port definition (based on Name)" );


ok( $soap->wsdlinit( servicename => 'testService', portname => 'testPort'), 'parsed WSDL' );
ok( ($soap->portname() eq 'testPort' ), 'found port passed to wsdlinit');