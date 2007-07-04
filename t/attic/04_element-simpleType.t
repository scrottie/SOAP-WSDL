use Test::More; 
use strict;
use warnings;
plan  qw/no_plan/;
use lib '../lib';
use lib 't/lib';
use lib 'lib';
use Cwd;
use File::Basename;

our $SKIP;
eval "use Test::SOAPMessage";
if ($@) {
    $SKIP = "Test::Differences required for testing.";
}


use_ok(qw/SOAP::WSDL/);

my $xml;

my $soap = undef;
my $name = basename( $0 );
$name =~s/\.(t|pl)$//;

my $path = cwd;

$path =~s{/attic}{}xms;

#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file:///' . $path . '/acceptance/wsdl/' . $name . '.wsdl'
), 'Instantiated object' );

#3
$soap->readable(1);
ok( $soap->wsdlinit(), 'parsed WSDL' );
$soap->no_dispatch(1);

ok ( $xml = $soap->call('test', testElement1 => 1 ) ,
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
}

TODO: {
    local $TODO="implement min/maxOccurs checks";
    
    eval { $soap->call('test', testAll => [ 2, 3 ] ); };
	
    like $@, qr{illegal\snumber\sof\selements}, "Died on illegal number of elements (too many)";
    
    eval { $soap->call('test', testAll => undef ) };
    ok $@, 'Died on illegal number of elements (not enough)';
}

