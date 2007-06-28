use Test::More tests => 9;
use diagnostics;

use Cwd;
use File::Basename;

use lib '../lib';
use lib 'lib';
use lib 't/lib';

use Test::SOAPMessage;

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
$soap->autotype(0);
#4
ok ( $xml = $soap->serializer->method( $soap->call('test', 
						testAll => 1 ) 
			),
	'Serialized (simple) call (list)' );

print $xml, "\n";


SKIP: {
	skip 'broken', 1;
	open (my $fh, $path . '/acceptance/results/' . $name . '.xml')
		|| skip("Cannot open acceptance results file ". $name . '.xml', 1);
	my $testXML = <$fh>;
	close $fh;
	chomp $testXML;
	chomp $xml;
	
	soap_eq_or_diff( $xml, $testXML, 'Got expected result');
}

# 6
eval {
		$xml = $soap->serializer->method( 
			$soap->call('test', 
				testAll => [ 1, 2 ]
			) 
		)
};
ok($@, 'Died on illegal number of elements (not enough)');	
	
eval {
		$xml = $soap->serializer->method( 
			$soap->call('test', 
				testAll => undef
			) 
		)
};
ok($@, 'Died on illegal number of elements (not enough)');

SKIP: 
{
	skip( "minValue check not implemented ", 1)
		if ($SOAP::WSDL::MISSING->{ simpleType }->{ restriction }->{ minValue });
	eval {
		$xml = $soap->serializer->method( 
			$soap->call('test', 
				testAll => 0
			) 
		)
	};
	ok($@, 'Died on illegal value');
}

SKIP: 
{
	skip( "maxValue check not implemented ", 1)
		if ($SOAP::WSDL::MISSING->{ simpleType }->{ restriction }->{ maxValue });
	eval {
		$xml = $soap->serializer->method( 
			$soap->call('test', 
				testAll => 100
			) 
		)
	};
	ok($@, 'Died on illegal value');
}


chdir $cwd;