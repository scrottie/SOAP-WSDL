use Test::More tests => 7;
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

ok( ($soap->servicename('testService')  ), 'set service' );
ok( ($soap->portname('testPort2')  ) ,'set portname');
ok( $soap->wsdlinit(), 'parsed WSDL' );

ok( $soap->wsdlinit( servicename => 'testService', portname => 'testPort'), 'parsed WSDL' );

ok( ($soap->portname() eq 'testPort' ), 'found port passed to wsdlinit');