use Test::More tests => 4;
use strict;
use warnings;
use lib '../lib';
use lib 't/lib';
use lib 'lib';
use File::Basename;
use File::Spec

use_ok(qw/SOAP::WSDL/);

print "# SOAP::WSDL Version: $SOAP::WSDL::VERSION\n";

my $path = File::Spec->rel2abs( dirname __FILE__ );


my $xml;
my $soap;

#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file://' . $path . '/../../acceptance/wsdl/03_complexType-element-ref.wsdl',
	readable => 1,
    no_dispatch => 1,
), 'Instantiated object' );

# won't work without - would require SOAP::WSDL::Deserializer::SOM,
# which requires SOAP::Lite
$soap->outputxml(1);

ok ($xml = $soap->call('test',  
			testAll => {
				Test2 => 'Test2',
				TestRef => 'TestRef'
			}
), 'Serialized complexType' );

is $xml, q{<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" ><SOAP-ENV:Body><testAll><TestRef>TestRef</TestRef><Test2>Test2</Test2></testAll></SOAP-ENV:Body></SOAP-ENV:Envelope>}
    , 'element ref="" serialization';
