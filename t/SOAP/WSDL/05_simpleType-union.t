use Test::More skip_all => 'Not supported yet';
use strict;
use warnings;
use Cwd;
use File::Basename;

use lib '../lib';

use_ok qw/SOAP::WSDL/;

my $xml;
my $soap = undef;
my $name = basename( $0 );
$name =~s/\.(t|pl)$//;

my $path = cwd;

$path =~s{(/t)?/SOAP/WSDL}{}xms;

#2
ok $soap = SOAP::WSDL->new(
	wsdl => 'file:///' . $path . '/t/acceptance/wsdl/' . $name . '.wsdl'
), 'Instantiated object';

#3
$soap->readable(1);
ok $soap->wsdlinit(), 'parsed WSDL';
$soap->no_dispatch(1);

#4
ok $xml = $soap->call('test', testAll => 1 ) , 'Serialized call';

# 6
eval {
		$xml = $soap->serializer->method( 
			$soap->call('test', 
				testAll => [ 1 , 'union']
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

#8
ok ( $xml = $soap->serializer->method( $soap->call('test2', 
						testAll => 1 ) 
			),
	'Serialized (simple) call (list)' );

#9
eval {
		$xml = $soap->serializer->method( 
			$soap->call('test', 
				testAll => [ 1 , 'union']
			) 
		)
};
ok($@, 'Died on illegal number of elements (not enough)');	
