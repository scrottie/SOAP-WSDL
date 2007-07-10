use Test::More tests => 8;
use strict;
use lib '../lib';
use lib 'lib';
use lib 't/lib';
use Cwd;
use File::Basename;

use_ok(qw/SOAP::WSDL/);

my ($soap, $xml, $xml2);

# chdir to my location
my $name = basename( $0 );
$name =~s/\.(t|pl)$//;

my $path = cwd;
$path =~s{(/t)/SOAP/WSDL}{}xms;

#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file:///' . $path . '/t/acceptance/wsdl/' . $name . '.wsdl'
), 'Instantiated object' );

$soap->readable(1);

#3
ok( $soap->wsdlinit(
    servicename => 'testService',
), 'parsed WSDL' );
$soap->no_dispatch(1);

#4
ok $xml = $soap->call('test', testAll => [ 1, 2 ] ), 'Serialize list call';

#5
ok ( $xml2 = $soap->call('test', testAll => "1 2" ) , 'Serialized scalar call' );
#6
ok( $xml eq $xml2, 'Got expected result');

#7	
TODO: {
    local $TODO = "implement minLength check";
    eval { $xml = $soap->call('test', testAll => undef ) };
    ok($@, 'Died on illegal number of elements (not enough)');
}

#8
TODO: {
    local $TODO = "maxLength test not implemented";
    eval { $xml = $soap->call('test', testAll => [ 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 ] ) };
	ok($@, 'Died on illegal number of elements (more than maxLength)');	
}
