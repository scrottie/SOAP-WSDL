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
		$SKIP = "Test::Differences required for testing.";
	}
}

use_ok(qw/SOAP::WSDL/);

my $xml;
my $path = cwd();
my $name = $0;
$name =~s/\.t$//;

#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file://' . $path . '/acceptance/wsdl/' . $name . '.wsdl'
), 'Instantiated object' );

#3
ok( $soap->wsdlinit(), 'parsed WSDL' );
$soap->no_dispatch(1);
$soap->serializer()->namespace('SOAP-ENV');
$soap->serializer()->encodingspace('SOAP-ENC');

ok ($xml = $soap->serializer->method( $soap->call('test', 
	testAll => 'Test'
) ), 'Serialized (simpler) element' );

open (my $fh, $path . '/acceptance/results/' . $name . '.xml')
	|| die "Cannot open acceptance results file";
my $testXML = <$fh>;
close $fh;

SKIP:
{
	skip( $SKIP, 1 ) if ($SKIP);
	soap_eq_or_diff( $xml, $testXML, 'Got expected result');
};

eval 
{ 
	$xml = $soap->serializer->method( 
		$soap->call('test', 
			testAll => [ 'Test 2', 'Test 3' ]
		) 
	);
};

ok( ($@ =~m/illegal\snumber\sof\selements/),
	"Died on illegal number of elements (too many)"
);

eval {
	$xml = $soap->serializer->method( 
		$soap->call('test', 
			testAll => undef
		) 
	)
};
ok($@, 'Died on illegal number of elements (not enough)');

