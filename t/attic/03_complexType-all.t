use Test::More tests => 8;
use strict;
use warnings;
use lib '../lib';
use lib 't/lib';
use lib 'lib';
use Cwd;
use File::Basename;

our $SKIP;
eval "use Test::SOAPMessage";
if ($@)
{
    $SKIP = "Test::Differences required for testing. ";
}

my $path = cwd();
my $name = $0;
$name =~s/\.t$//;
$name =~s/^t\///;

$path =~s{/attic}{}xms;

use_ok(qw/SOAP::WSDL/);

print "# SOAP::WSDL Version: $SOAP::WSDL::VERSION\n";

my $xml;
my $soap;

#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file://' . $path . '/acceptance/wsdl/' . $name . '.wsdl',
	readable =>1,
), 'Instantiated object' );


#3
ok $soap->wsdlinit( checkoccurs => 1, ), 'parse WSDL';
ok $soap->no_dispatch(1), 'set no dispatch';

ok ($xml = $soap->call('test', 
          Test1 => 'Test 1',
          Test2 => 'Test 2',
), 'Serialized complexType' );


open (my $fh, $path . '/acceptance/results/' . $name . '.xml')
	|| die "Cannot open acceptance results file";
my $testXML = <$fh>;
close $fh;

SKIP: {
	skip( $SKIP, 1 ) if ($SKIP);
	eval { soap_eq_or_diff( $xml, $testXML, 'Got expected result') };
};

# $soap->wsdl_checkoccurs(1);

TODO: {
  local $TODO = "not implemented yet";

eval 
{ 
	$xml = $soap->serializer->method( 
		$soap->call('test', 
			testAll => {
				Test1 => 'Test 1',
				Test2 => [ 'Test 2', 'Test 3' ]
			}
		) 
	);
};

ok( ($@ =~m/illegal\snumber\sof\selements/),
	"Died on illegal number of elements (too many)"
);

eval {
	$xml = $soap->serializer->method( 
		$soap->call('test', 
			testAll => {
				Test1 => 'Test 1',
			}
		) 
	)
};
ok($@, 'Died on illegal number of elements (not enough)');

}