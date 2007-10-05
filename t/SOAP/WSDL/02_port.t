use Test::More tests => 7;
use strict;
use warnings;
use diagnostics;
use Cwd;
use File::Basename;
use File::Spec;
use lib '../lib';

use_ok(qw/SOAP::WSDL/);

my $path = File::Spec->rel2abs( dirname __FILE__ );
my $soap;
#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file:///' . $path . '/../../acceptance/wsdl/02_port.wsdl'
), 'Instantiated object' );

ok( ($soap->servicename('testService')  ), 'set service' );
ok( ($soap->portname('testPort2')  ) ,'set portname');
ok( $soap->wsdlinit(), 'parsed WSDL' );

ok( $soap->wsdlinit( servicename => 'testService', portname => 'testPort'), 'parsed WSDL' );

ok( ($soap->portname() eq 'testPort' ), 'found port passed to wsdlinit');