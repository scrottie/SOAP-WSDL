use Test::More tests => 4;
use strict;
use warnings;
use lib '../lib';
use lib 't/lib';
use lib 'lib';
use Cwd;
use File::Basename;

my $path = cwd();
my $name = basename $0;
$name =~s/\.t$//;
$name =~s/^t\///;

$path =~s{(/t)?/SOAP/WSDL}{}xms;

use_ok(qw/SOAP::WSDL/);

print "# SOAP::WSDL Version: $SOAP::WSDL::VERSION\n";

my $xml;
my $soap;

#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file://' . $path . '/t/acceptance/wsdl/' . $name . '.wsdl',
	readable => 1,
    no_dispatch => 1,
), 'Instantiated object' );

ok ($xml = $soap->call('test',  
			testAll => {
				Test2 => 'Test2',
				TestRef => 'TestRef'
			}
), 'Serialized complexType' );

is $xml, q{<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" ><SOAP-ENV:Body><testAll>
	<TestRef>TestRef</TestRef>
	<Test2>Test2</Test2>
</testAll>
</SOAP-ENV:Body></SOAP-ENV:Envelope>}
    , 'element ref="" serialization';
