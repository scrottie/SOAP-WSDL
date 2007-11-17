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
my ($volume, $dir) = File::Spec->splitpath($path, 1);
my @dir_from = File::Spec->splitdir($dir);
unshift @dir_from, $volume if $volume;
my $url = join '/', @dir_from;

my $xml;
my $soap;

#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file://' . $url . '/../../acceptance/wsdl/03_complexType-element-ref.wsdl',
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

like $xml, qr{<SOAP-ENV:Body><testAll><TestRef>TestRef</TestRef><Test2>Test2</Test2></testAll></SOAP-ENV:Body>}
    , 'element ref="" serialization';
