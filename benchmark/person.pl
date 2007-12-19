use lib '../lib';
use lib '../example/lib';
use lib '../../SOAP-WSDL_XS/blib/lib';
use lib '../../SOAP-WSDL_XS/blib/arch';
use strict;

package MyData;
my $XML;
sub xml {
    return $XML if ($XML);

    open my $fh, 'person.xml' or die 'cannot open data file';
    $XML = join '', <$fh>;
    close $fh;
    return $XML;
}

package MyTransport;
use SOAP::WSDL::Factory::Transport;
SOAP::WSDL::Factory::Transport->register( http => __PACKAGE__ );
sub send_receive {
    return MyData::xml();
}
sub new { return bless {}, 'MyTransport' };

package main;

use Benchmark qw(cmpthese);

# Do this BEFORE the client SOAP handlers are compiled!
use XML::Compile::Transport::SOAPHTTP();
use XML::Compile::SOAP::Tester ();
use XML::Compile::Util;#use Data::Dumper;
#print Dumper $result;
use XML::Compile::WSDL11;
use XML::Simple;

use SOAP::WSDL::Deserializer::XSD_XS;
use SOAP::WSDL::Factory::Deserializer;

$XML::Simple::PREFERRED_PARSER = 'XML::Parser';
use SOAP::Lite;

use MyInterfaces::TestService::TestPort;

my $tester = XML::Compile::SOAP::Tester->new();
my $action = pack_type 'http://example.org', 'ListPerson';
my $compile = XML::Compile::WSDL11->new('../example/wsdl/Person.wsdl');

$tester->actionCallback($action, \&MyData::xml);

my $call = $compile->compileClient('ListPerson');
my $result = $call->({ in => undef});

# Initialize SOAP::Lite
my $deserializer = SOAP::Deserializer->new();

# Initialize SOAP::WSDL interface
my $soap = MyInterfaces::TestService::TestPort->new();
# Load all classes - XML::Compile has created everything before, too
$soap->ListPerson({});

# # register for SOAP 1.1
SOAP::WSDL::Factory::Deserializer->register('1.1' => 'SOAP::WSDL::Deserializer::XSD_XS' );

my $wsdl_xs = MyInterfaces::TestService::TestPort->new();

# trigger loading of XML Data
{
    use bytes;
    print "XML length (bytes): " . length( MyData::xml() ), "\n";
}

my @data = ();
my $n = 0;
print "Benchmark conducted with
SOAP::Lite - $SOAP::Lite::VERSION
SOAP::WSDL - $SOAP::WSDL::Client::VERSION
SOAP::WSDL_XS - $SOAP::WSDL::Deserializer::XSD_XS::VERSION;
XML::Compile::SOAP - $XML::Compile::SOAP::VERSION
XML::Simple - $XML::Simple::VERSION

Benchmark $n: Store result in private variable and destroy it
";
$n++;
cmpthese 300, {
    'XML::Simple' => sub { my $result = XMLin( MyData::xml() )},
    'SOAP::WSDL' => sub { my $result = $soap->ListPerson({}) },
    'XML::Compile::SOAP' => sub { my $result = $call->() },
    'SOAP::WSDL_XS' => sub { my $result = @data, $wsdl_xs->ListPerson({}) },
    'SOAP::Lite' => sub { my $result = $deserializer->deserialize( MyData::xml() )}
};

print "Benchmark $n: Push result on list\n";
$n++;
cmpthese 500, {
    'XML::Simple' => sub { push @data, XMLin( MyData::xml() )},
    'SOAP::WSDL' => sub { push @data, $soap->ListPerson({}) },
    'XML::Compile::SOAP' => sub { push @data, $call->() },
    'SOAP::WSDL_XS' => sub { push @data, $wsdl_xs->ListPerson({}) },
    'SOAP::Lite' => sub { push @data, $deserializer->deserialize( MyData::xml() )}
};

@data = ();
print "Benchmark $n: Play it again, Sam\n";

cmpthese 500, {
    'XML::Simple' => sub { push @data, XMLin( MyData::xml() )},
    'SOAP::WSDL' => sub { push @data, $soap->ListPerson({}) },
    'SOAP::WSDL_XS' => sub { push @data, $wsdl_xs->ListPerson({}) },
    'XML::Compile::SOAP' => sub { push @data, $call->() },
    'SOAP::Lite' => sub { push @data, $deserializer->deserialize( MyData::xml() )}
};

