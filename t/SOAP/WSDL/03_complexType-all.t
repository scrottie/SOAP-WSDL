use Test::More tests => 7;
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
	readable =>1,
), 'Instantiated object' );


#3
ok $soap->wsdlinit( 
    checkoccurs => 1,
    servicename => 'testService', 
), 'parse WSDL';
ok $soap->no_dispatch(1), 'set no dispatch';

ok ($xml = $soap->call('test',  
			testAll => {
				Test1 => 'Test 1',
				Test2 => [ 'Test 2', 'Test 3' ]
			}
), 'Serialized complexType' );


# print $xml;

# $soap->wsdl_checkoccurs(1);

TODO: {
  local $TODO = "not implemented yet";

eval 
{ 
	$xml = $soap->call('test', 
			testAll => {
				Test1 => 'Test 1',
				Test2 => [ 'Test 2', 'Test 3' ]
			}
		);
};

ok( ($@ =~m/illegal\snumber\sof\selements/),
	"Died on illegal number of elements (too many)"
);

eval {
	$xml = $soap->call('test', 
			testAll => {
				Test1 => 'Test 1',
			}
		);
};
ok($@, 'Died on illegal number of elements (not enough)');

}