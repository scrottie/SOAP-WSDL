use Test::More tests => 3;
use File::Basename qw(dirname);
use File::Spec;

my $path = File::Spec->rel2abs( dirname __FILE__ );

use_ok qw(SOAP::WSDL::Generator::Visitor::Typelib);
use_ok qw(SOAP::WSDL::Generator::Template::XSD);

use SOAP::WSDL::Expat::WSDLParser;

my $parser = SOAP::WSDL::Expat::WSDLParser->new();
my $definitions = $parser->parse_file(
    "$path/../../../acceptance/wsdl/generator_unsupported_test.wsdl"
);

my $generator = SOAP::WSDL::Generator::Template::XSD->new({
    definitions => $definitions,
});

{
    eval { $generator->generate_typelib() };
}
ok $@, $@;