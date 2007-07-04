use Test::More tests => 7;;
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
my $name = $0;
$name =~s/\.t$//;

$path =~s{/attic}{}xsm;

#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file://' . $path . '/acceptance/wsdl/' . $name . '.wsdl'
), 'Instantiated object' );

#3
$soap->readable(1);
ok( $soap->wsdlinit(), 'parsed WSDL' );
$soap->no_dispatch(1);

ok ($xml = $soap->call('test', 
	testElement1 => 'Test'
), 'Serialized (simple) element' );

open (my $fh, $path . '/acceptance/results/' . $name . '.xml')
	|| die "Cannot open acceptance results file";
my $testXML = <$fh>;
close $fh;

SKIP: {
    if ($SKIP){
        print $xml;    
	skip( $SKIP, 1 );
    }
    
    soap_eq_or_diff( $xml, $testXML, 'Got expected result');
};

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

