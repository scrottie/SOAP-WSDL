use SOAP::WSDL::Expat::WSDLParser;
use Devel::Leak;
my $xml = `cat ../wsdl/11_helloworld.wsdl`;

my ($table, $count);


for (1..5) {
	$count = Devel::Leak::NoteSV($table);
	print "SV: $count \n";
	my $parser = SOAP::WSDL::Expat::WSDLParser->new();
	$parser->parse_string($xml);
	my $data = $parser->get_data();
	undef $parser;
	undef $data;
}
