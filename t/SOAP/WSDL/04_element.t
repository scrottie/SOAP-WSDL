use Test::More tests => 8;
use strict;
use warnings;
use lib '../lib';
use lib 't/lib';
use File::Spec;
use File::Basename;

our $SKIP;
eval "use Test::SOAPMessage";
if ($@) {
    $SKIP = "Test::Differences required for testing.";
}

use_ok(qw/SOAP::WSDL/);

my $soap;
my $xml;
my $path = File::Spec->rel2abs( dirname __FILE__ );

#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file://' . $path . '/../../acceptance/wsdl/04_element.wsdl'
), 'Instantiated object' );

#3
$soap->readable(1);
$soap->outputxml(1);

ok( $soap->wsdlinit(
    servicename => 'testService',
), 'parsed WSDL' );
$soap->no_dispatch(1);

ok ($xml = $soap->call('test', 
	testElement1 => 'Test'
), 'Serialized (simple) element' );

ok ($xml = $soap->call('testRef', 
	testElementRef => 'Test'
), 'Serialized (simple) element' );

is $xml 
    , q{<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" ><SOAP-ENV:Body><testElementRef  xmlns="urn:Test">Test</testElementRef></SOAP-ENV:Body></SOAP-ENV:Envelope>}
    , 'element ref serialization result'
;

TODO: {
    local $TODO="implement min/maxOccurs checks";

    eval { 
	$xml = 	$soap->call('test', 
			testAll => [ 'Test 2', 'Test 3' ]
		); 
    };

    ok( ($@ =~m/illegal\snumber\sof\selements/),
	"Died on illegal number of elements (too many)"
    );

    eval {
	$xml = $soap->call('test', testAll => undef ); 
    };
    ok($@, 'Died on illegal number of elements (not enough)');
}

