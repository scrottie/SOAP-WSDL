use lib '../lib';
use lib '../example/lib';
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
    # warn MyData::xml;
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
$XML::Simple::PREFERRED_PARSER = 'XML::Parser';
use SOAP::Lite;

use MyInterfaces::TestService::TestPort;

my $tester = XML::Compile::SOAP::Tester->new();

my $action = pack_type 'http://example.org', 'ListPerson';
sub ListPerson(@) { MyData::xml };
my $compile = XML::Compile::WSDL11->new('../example/wsdl/Person.wsdl');
# $tester->fromWSDL($wsdl);
$tester->actionCallback($action, \&ListPerson);

# I have to lookup the methods from the WSDL
my $call = $compile->compileClient('ListPerson');

# I have to lookup the parameters from the WSDL
my $result = $call->({ in => undef});
#use Data::Dumper;
#print Dumper $result;

my $deserializer = SOAP::Deserializer->new();

my $soap = MyInterfaces::TestService::TestPort->new();

$result = $soap->ListPerson({});
#print $result;
#exit;

my @data = ();
my $n = 0;
print "Benchmark conducted with
SOAP::Lite - $SOAP::Lite::VERSION
SOAP::WSDL - $SOAP::WSDL::Client::VERSION
XML::Compile::SOAP - $XML::Compile::SOAP::VERSION
XML::Simple - $XML::Simple::VERSION

Benchmark $n: Push result on list
";
$n++;
print "Benchmark $n: Store result in private variable and destroy it\n";
cmpthese 100, {
    'XML::Simple' => sub { my $result = XMLin( MyData::xml() )},
    'SOAP::WSDL' => sub { my $result = $soap->ListPerson({}) },
    'XML::Compile::SOAP' => sub { my $result = $call->() },
    'SOAP::Lite' => sub { my $result = $deserializer->deserialize( MyData::xml() )}
};

$n++;
cmpthese 100, {
    'XML::Simple' => sub { push @data, XMLin( MyData::xml() )},
    'SOAP::WSDL' => sub { push @data, $soap->ListPerson({}) },
    'XML::Compile::SOAP' => sub { push @data, $call->() },
    'SOAP::Lite' => sub { push @data, $deserializer->deserialize( MyData::xml() )}
};

@data = ();
print "Benchmark $n: Play it again, Sam\n";

cmpthese 100, {
    'XML::Simple' => sub { push @data, XMLin( MyData::xml() )},
    'SOAP::WSDL' => sub { push @data, $soap->ListPerson({}) },
    'XML::Compile::SOAP' => sub { push @data, $call->() },
    'SOAP::Lite' => sub { push @data, $deserializer->deserialize( MyData::xml() )}
};

