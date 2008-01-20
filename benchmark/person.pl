use lib '../lib';
use lib '../example/lib';
use lib '../../SOAP-WSDL_XS/blib/lib';
use lib '../../SOAP-WSDL_XS/blib/arch';
use strict;

use Benchmark qw(cmpthese);

use XML::Compile::Transport::SOAPHTTP();
use XML::Compile::Util;
use XML::Compile::WSDL11;
use XML::Simple;

use SOAP::WSDL::Deserializer::XSD_XS;
use SOAP::WSDL::Factory::Deserializer;

$XML::Simple::PREFERRED_PARSER = 'XML::Parser';
use SOAP::Lite;

use MyInterfaces::TestService::TestPort;

my $compile = XML::Compile::WSDL11->new('../example/wsdl/Person.wsdl');
my $call = $compile->compileClient('ListPerson');
$call->({ in => undef});

# Initialize SOAP::Lite
my $deserializer = SOAP::Deserializer->new();

# Initialize SOAP::WSDL interface
my $soap = MyInterfaces::TestService::TestPort->new();
# Load all classes - XML::Compile has created everything before, too
$soap->ListPerson({});

my $lite = SOAP::Lite->new()->default_ns('http://www.example.org/benchmark/')
	->proxy('http://localhost:81/soap-wsdl-test/person.pl');
$lite->on_action( sub { 'http://www.example.org/benchmark/ListPerson' } );

# # register for SOAP 1.1
SOAP::WSDL::Factory::Deserializer->register('1.1' => 'SOAP::WSDL::Deserializer::XSD_XS' );
my $wsdl_xs = MyInterfaces::TestService::TestPort->new();

# trigger loading of XML Data
my $count = 100;
my @data = ();
my $n = 0;
print "Benchmark conducted with
SOAP::Lite - $SOAP::Lite::VERSION
SOAP::WSDL - $SOAP::WSDL::Client::VERSION
SOAP::WSDL_XS - $SOAP::WSDL::Deserializer::XSD_XS::VERSION;
XML::Compile::SOAP - $XML::Compile::SOAP::VERSION

Benchmark $n: Store result in private variable and destroy it
";
$n++;
cmpthese $count, {
#    'XML::Simple' => sub { my $result = XMLin( MyData::xml() )},
    'SOAP::WSDL' => sub { my $result = $soap->ListPerson({}) },
    'XML::Compile' => sub { my $result = $call->() },
    'SOAP::WSDL_XS' => sub { my $result = $wsdl_xs->ListPerson({}) },
#    'SOAP::Lite' => sub { my $result = $deserializer->deserialize( MyData::xml() )},
	'SOAP::Lite'	=> sub { my $som = $lite->call('ListPerson') },
};

print "\nBenchmark $n: Push result on list\n";
$n++;
cmpthese $count, {
#    'XML::Simple' => sub { push @data, XMLin( MyData::xml() )},
    'SOAP::WSDL' => sub { push @data, $soap->ListPerson({}) },
    'XML::Compile' => sub { push @data, $call->() },
    'SOAP::WSDL_XS' => sub { push @data, $wsdl_xs->ListPerson({}) },
#    'SOAP::Lite' => sub { push @data, $deserializer->deserialize( MyData::xml() )}
	'SOAP::Lite'	=> sub { push @data, $lite->call('ListPerson') },
};

@data = ();
print "\nBenchmark $n: Play it again, Sam\n";

cmpthese $count, {
#    'XML::Simple' => sub { push @data, XMLin( MyData::xml() )},
    'SOAP::WSDL' => sub { push @data, $soap->ListPerson({}) },
    'SOAP::WSDL_XS' => sub { push @data, $wsdl_xs->ListPerson({}) },
    'XML::Compile' => sub { push @data, $call->() },
#    'SOAP::Lite' => sub { push @data, $deserializer->deserialize( MyData::xml() )}
	'SOAP::Lite'	=> sub { push @data, $lite->call('ListPerson') },
};

