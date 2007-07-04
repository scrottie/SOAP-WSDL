BEGIN 
{
	chdir 't/' if (-d 't/');
	use Test::More tests => 7;;
	use lib '../lib';
	use lib 't/lib';
	use lib 'lib';
	use Cwd;
	use File::Basename;

	our $SKIP;
	eval "use Test::SOAPMessage";
	if ($@)
	{
		$SKIP = "Test::Differences required for testing. $@";
	}
}

use_ok(qw/SOAP::WSDL/);

my $xml;

my $path = cwd();
my $name = $0;
$name =~s/\.t$//;

$path=~s{/attic}{}xms;

#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file://' . $path . '/acceptance/wsdl/' . $name . '.wsdl'
), 'Instantiated object' );

#3
ok( $soap->wsdlinit(
	checkoccurs => 1,
), 'parsed WSDL' );
$soap->no_dispatch(1);
$soap->serializer()->envprefix('SOAP-ENV');
$soap->serializer()->encprefix('SOAP-ENC');

#4
ok $xml = $soap->call('test', 
	testSequence => {
		Test1 => 'Test 1',
		Test2 => 'Test 2',
	}
), 'Serialized complexType';

#5
open (my $fh, $path . '/acceptance/results/' . $name . '.xml')
	|| die "Cannot open acceptance results file";
my $testXML = <$fh>;
close $fh;

SKIP:
{
	skip( $SKIP, 1 ) if ($SKIP);
	soap_eq_or_diff( $xml, $testXML, 'Got expected result');
}
#6
eval 
{ 
	$xml = $soap->serializer->method( 
		$soap->call('test', 
			testSequence => {
				Test1 => 'Test 1',
			}
		) 
	);
};
ok( ($@),
	"Died on illegal number of elements"
);

#7
eval 
{ 
	$xml = $soap->serializer->method( 
		$soap->call('test', 
			testSequence => {
				Test1 => 'Test 1',
				Test2 => [ 1, 2, 3, ]
			}
		) 
	);
};
ok( ($@),
	"Died on illegal number of elements"
);
