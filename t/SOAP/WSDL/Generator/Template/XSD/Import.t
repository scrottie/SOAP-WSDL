use Test::More tests => 3;
use File::Basename qw(dirname);
use File::Spec;
use File::Path;
use diagnostics;
my $path = File::Spec->rel2abs( dirname __FILE__ );

use_ok qw(SOAP::WSDL::Generator::Visitor::Typelib);
use_ok qw(SOAP::WSDL::Generator::Template::XSD);

use SOAP::WSDL::Expat::WSDLParser;

my $parser = SOAP::WSDL::Expat::WSDLParser->new();

my $definitions = $parser->parse_uri(
            "file://$path/../../../../../acceptance/wsdl/WSDLParser-import.wsdl"
        );

my $generator = SOAP::WSDL::Generator::Template::XSD->new({
    definitions => $definitions,
    type_prefix => 'Foo',
    element_prefix => 'Foo',
    typemap_prefix => 'Foo',
    OUTPUT_PATH => "$path/testlib",
});

my $code = "";
$generator->set_output(\$code);
$generator->generate_typelib();
{
    eval $code;
    ok !$@;
    print $@ if $@;
}

rmtree "$path/testlib";
