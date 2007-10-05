use Test::More tests => 6;
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
	wsdl => 'file:///' . $path . '/../../acceptance/wsdl/02_port.wsdl',
	keep_alive => 1,
), 'Instantiated object' );

ok( ($soap->servicename('testService')  ), 'set service' );
ok( ($soap->portname('testPort2')  ) ,'set portname');
ok( $soap->wsdlinit(), 'parsed WSDL' );

eval {
    $soap = SOAP::WSDL->new(
    	wsdl => 'file:///' . $path . '/../../acceptance/wsdl/FOOBAR',
    	keep_alive => 1,
    );
};
like $@, qr{ does \s not \s exist }x, 'error on non-existant WSDL';