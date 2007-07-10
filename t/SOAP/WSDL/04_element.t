use Test::More tests => 6;
use strict;
use warnings;
use lib '../lib';
use lib 't/lib';
use lib 'lib';
use Cwd;
use File::Basename;

our $SKIP;
eval "use Test::SOAPMessage";
if ($@) {
    $SKIP = "Test::Differences required for testing.";
}

use_ok(qw/SOAP::WSDL/);

my $soap;
my $xml;
my $path = cwd();
my $name = basename $0;
$name =~s/\.t$//;

$path =~s{(/t)?/SOAP/WSDL}{}xsm;

#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file://' . $path . '/t/acceptance/wsdl/' . $name . '.wsdl'
), 'Instantiated object' );

#3
$soap->readable(1);
ok( $soap->wsdlinit(
    servicename => 'testService',
), 'parsed WSDL' );
$soap->no_dispatch(1);

ok ($xml = $soap->call('test', 
	testElement1 => 'Test'
), 'Serialized (simple) element' );

TODO: {
    local $TODO="implement min/maxOccurs checks";

    eval { 
	$xml = 	$soap->call('test', 
			testAll => [ 'Test 2', 'Test 3' ]
		); 
    };

    ok( ($@ =~m/illegal\snumber\sof\selements/),
	"Died on illegal number of elements (too many)"
    );

    eval {
	$xml = $soap->call('test', testAll => undef ); 
    };
    ok($@, 'Died on illegal number of elements (not enough)');
}

