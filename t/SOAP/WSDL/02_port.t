use Test::More tests => 10;
use strict;
use warnings;
use diagnostics;
use Cwd;
use File::Basename;
use Data::Dumper;
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

$path =~s{/SOAP/WSDL}{}xms;

#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file:///' . $path . '/acceptance/wsdl/' . $name . '.wsdl'
), 'Instantiated object' );

ok( $soap->wsdlinit(), 'parsed WSDL' );

ok( ($soap->servicename('testService')  ), 'set service' );
ok( ($soap->portname('testPort')  ) ,'set portname');

ok( ($soap->portname() eq 'testPort' ), 
"Found first port definition" );

ok( ($soap->portname('testPort2') ), 
"Found second port definition (based on URL)" );

ok( ($soap->portname('testPort3') ), 
"Found third port definition (based on Name)" );

ok( $soap->wsdlinit( servicename => 'testService', portname => 'testPort'), 'parsed WSDL' );

$soap->_wsdl_init_methods();

ok( ($soap->portname() eq 'testPort' ), 'found port passed to wsdlinit');