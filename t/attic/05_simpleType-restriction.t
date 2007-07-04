use Test::More tests => 8;
use strict;
use warnings;
use diagnostics;
use Cwd;
use File::Basename;
use lib '../lib';
use lib 'lib';
use lib 't/lib';

use_ok(qw/SOAP::WSDL/);

my $xml;

my $name = basename( $0 );
$name =~s/\.(t|pl)$//;

my $path = cwd;
$path =~s{/attic}{}xms;

my $soap;
#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file:///' . $path . '/acceptance/wsdl/' . $name . '.wsdl'
), 'Instantiated object' );

#3
$soap->readable(1);
ok( $soap->wsdlinit(), 'parsed WSDL' );
$soap->no_dispatch(1);
$soap->autotype(0);

#4
ok $xml = $soap->call('test', testAll => [ 1, 2 ] ) , 'Serialize list call';

# print $xml, "\n";

TODO: {
  local $TODO = "implement minLength/maxLength checks";
  eval { $soap->call('test', testAll => [ 1, 2, 3 ] ) };
  ok($@, 'Died on illegal number of elements (too many)');	
	
  eval { $soap->call('test', testAll => [] ) };
  ok($@, 'Died on illegal number of elements (not enough)');
}

TODO: {
    local $TODO = "minValue check not implemented ";
    eval { $xml = $soap->call('test', testAll => 0 ) };
    ok($@, 'Died on illegal value');
}

TODO: {
    local $TODO =  "maxValue check not implemented ";
    eval { $xml = $soap->call('test', testAll => 100 ) };
    ok($@, 'Died on illegal value');
}
