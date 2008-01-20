use strict;
use warnings;
use Test::More tests => 4; #qw(no_plan);
use File::Spec;
use File::Basename;

my $path = File::Spec->rel2abs( dirname __FILE__ );

use_ok qw( SOAP::WSDL::Expat::WSDLParser);

my $parser =  SOAP::WSDL::Expat::WSDLParser->new();

my $definitions = $parser->parse_file( 
     "$path/../../../acceptance/wsdl/WSDLParser.wsdl"
);

use Data::Dumper;
my $schema = $definitions->first_types()->get_schema()->[1];
my $attr = $schema->get_element()->[0]->first_complexType->first_attribute();
ok $attr->get_name('testAttribute');
ok $attr->get_type('xs:string');


use SOAP::WSDL::Generator::Template::XSD;
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

# print $code;

__END__

$generator->set_type_prefix('MyTypes');
$generator->set_element_prefix('MyElements');
$generator->set_typemap_prefix('MyTypemaps');
$generator->set_interface_prefix('MyInterfaces');

$generator->set_output(undef);
$generator->generate();

