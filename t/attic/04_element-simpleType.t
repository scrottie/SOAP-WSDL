BEGIN 
{
	chdir 't/' if (-d 't/');

	use Test::More; 
	plan  qw/no_plan/;
#	plan "skip_all", "Not yet supported";
#	use Test::More tests => 7;;
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

# chdir to my location
my $cwd = cwd;
my $path = dirname( $0 );
my $soap = undef;
my $name = basename( $0 );
$name =~s/\.(t|pl)$//;
chdir $path;

$path = cwd;

#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file:///' . $path . '/acceptance/wsdl/' . $name . '.wsdl'
), 'Instantiated object' );

#3
ok( $soap->wsdlinit(), 'parsed WSDL' );
$soap->no_dispatch(1);
$soap->serializer()->namespace('SOAP-ENV');
$soap->serializer()->encodingspace('SOAP-ENC');

ok ( $xml = $soap->serializer->method( $soap->call('test', 
						testAll => 1 ) 
			),
	'Serialized (simpler) element' );

# print $xml, "\n";

	
	open (my $fh, $path . '/acceptance/results/' . $name . '.xml')
		|| die 'Cannot open acceptance file ' 
			. $path . '/acceptance/results/' . $name . '.xml';
	my $testXML = <$fh>;
	close $fh;

SKIP: {
	skip($SKIP, 1) if ($SKIP);
	soap_eq_or_diff( $xml, $testXML, 'Got expected result');
};


	eval 
	{ 
		$xml = $soap->serializer->method( 
			$soap->call('test', 
				testAll => [ 2, 3 ]
			) 
		);
	};
	
	# print $@;
	
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

chdir $cwd;