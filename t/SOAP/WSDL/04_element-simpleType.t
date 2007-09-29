use Test::More tests => 6; 
use strict;
use warnings;
use lib '../lib';
use lib 't/lib';
use lib 'lib';
use Cwd;
use File::Basename;

use_ok(qw/SOAP::WSDL/);

my $xml;

my $soap = undef;
my $name = basename $0;
$name =~s/\.(t|pl)$//;

my $path = cwd;

$path =~s{(/t)?/SOAP/WSDL}{}xms;

#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file:///' . $path . '/t/acceptance/wsdl/' . $name . '.wsdl'
), 'Instantiated object' );

#3
$soap->readable(1);

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

