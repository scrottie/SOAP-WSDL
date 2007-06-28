use Test::More tests => 10;
use lib '../lib';
use lib 'lib';
use lib 't/lib';
use Cwd;
use File::Basename;
use Test::SOAPMessage;
use diagnostics;


use_ok(qw/SOAP::WSDL/);

unless ($SOAP::WSDL::MISSING) {  };

my ($xml, $xml2);

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

#4
ok ( $xml = $soap->serializer->method( $soap->call('test', 
						testAll => [ 1, 2 ] ) 
			),
	'Serialized (simple) call (list)' );

#print $xml, "\n";

SKIP: {
	
	open (my $fh, $path . '/acceptance/results/' . $name . '.xml')
		|| skip("Cannot open acceptance results file", 1);
	my $testXML = <$fh>;
	close $fh;
	#5	
	soap_eq_or_diff( $xml, $testXML, 'Got expected result');
}

#6
ok ( $xml2 = $soap->serializer->method( $soap->call('test', 
						testAll => "1 2" ) 
			),
	'Serialized (simple) call (scalar)' );
#7
ok( $xml eq $xml2, 'Got expected result');

#8
ok (
		$xml = $soap->serializer->method( 
			$soap->call('test', 
				testAll => 2
			) 
		), "Serialized simple call (scalar value)"
);
	
#9	
eval {
		$xml = $soap->serializer->method( 
			$soap->call('test', 
				testAll => undef
			) 
		)
};
ok($@, 'Died on illegal number of elements (not enough)');


#10
SKIP:
{
	skip ("maxLength test not implemented", 1)
		if ( $SOAP::WSDL::MISSING->{ simpleType }->{ list }->{ maxLength } );	
	eval {
			$xml = $soap->serializer->method( 
				$soap->call('test', 
					testAll => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 ]
				) 
			)
	};
	ok($@, 'Died on illegal number of elements (more than maxLength)');
	
}

chdir $cwd;