use Test::More qw(no_plan);
use File::Basename qw(dirname);
use File::Spec;

my $path = File::Spec->rel2abs( dirname __FILE__ );

use_ok qw(SOAP::WSDL::Generator::Visitor::Typelib);
use_ok qw(SOAP::WSDL::Generator::Template::XSD);

use SOAP::WSDL::Expat::WSDLParser;

my $parser = SOAP::WSDL::Expat::WSDLParser->new();
my $definitions = $parser->parse_file( 
     "$path/../../../acceptance/wsdl/generator_test.wsdl"
    #"$path/../../../acceptance/wsdl/elementAtomicComplexType.xml"
);

my $generator = SOAP::WSDL::Generator::Template::XSD->new({
    definitions => $definitions,
});

my $code = "";
$generator->set_output(\$code);  
$generator->generate_typelib();
eval $code;
ok !$@;
print $@ if $@;
#print $code;
