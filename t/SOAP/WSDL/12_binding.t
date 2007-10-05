use strict;
use lib '../../../lib';
use Test::More tests => 4;
use SOAP::WSDL;
use File::Spec;
use Data::Dumper;
use File::Basename;

print "# Using SOAP::WSDL Version $SOAP::WSDL::VERSION\n";

# chdir to my location
my $soap = undef;

my $path = File::Spec->rel2abs( dirname __FILE__ );

my $url = 'http://127.0.0.1/testPort';


ok( $soap = SOAP::WSDL->new(
	wsdl => 'file:///' . $path . '/../../acceptance/wsdl/02_port.wsdl'
) );

ok $soap->wsdlinit( url => $url );
ok $soap->servicename('testService');
ok $soap->portname('testPort');
