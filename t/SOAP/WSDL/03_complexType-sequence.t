BEGIN {
    use Test::More tests => 6;
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

my $path = File::Spec->rel2abs( dirname __FILE__ );

#2
ok( $soap = SOAP::WSDL->new(
	wsdl => 'file://' . $path . '/../../acceptance/wsdl/03_complexType-sequence.wsdl'
), 'Instantiated object' );

#3
ok( $soap->wsdlinit(
	checkoccurs => 1,
	servicename => 'testService',
), 'parsed WSDL' );
$soap->no_dispatch(1);

# won't work without - would require SOAP::WSDL::Deserializer::SOM,
# which requires SOAP::Lite
$soap->outputxml(1);


#4
ok $xml = $soap->call('test', 
	testSequence => {
		Test1 => 'Test 1',
		Test2 => 'Test 2',
	}
), 'Serialized complexType';

TODO: {
    local $TODO = "not implemented yet";
    #5
    eval 
    { 
            $xml = $soap->call('test', 
                            testSequence => {
                                    Test1 => 'Test 1',
                            }
                    );
    };
    ok( ($@),
            "Died on illegal number of elements"
    );
    
    #6
    eval 
    { 
            $xml = $soap->call('test', 
                            testSequence => {
                                    Test1 => 'Test 1',
                                    Test2 => [ 1, 2, 3, ]
                            }
                    ); 
    };
    ok( ($@),
            "Died on illegal number of elements"
    );
};