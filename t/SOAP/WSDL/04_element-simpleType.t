use Test::More tests => 6; 
use strict;
use warnings;
use lib '../lib';
use lib 't/lib';

use File::Basename;
use File::Spec;
use_ok(qw/SOAP::WSDL/);

my $xml;

my $soap = undef;

my $path = File::Spec->rel2abs( dirname __FILE__ );

ok( $soap = SOAP::WSDL->new(
	wsdl => 'file:///' . $path . '/../../acceptance/wsdl/04_element-simpleType.wsdl'
), 'Instantiated object' );

# won't work without - would require SOAP::WSDL::Deserializer::SOM,
# which requires SOAP::Lite
$soap->outputxml(1);

ok( $soap->wsdlinit(
    servicename => 'testService',
), 'parsed WSDL' );
$soap->no_dispatch(1);

ok ( $xml = $soap->call('test', testElement1 => 1 ) ,
	'Serialized (simpler) element' );

	
TODO: {
    local $TODO="implement min/maxOccurs checks";
    
    eval { $soap->call('test', testAll => [ 2, 3 ] ); };
	
    like $@, qr{illegal\snumber\sof\selements}, "Died on illegal number of elements (too many)";
    
    eval { $soap->call('test', testAll => undef ) };
    ok $@, 'Died on illegal number of elements (not enough)';
}

