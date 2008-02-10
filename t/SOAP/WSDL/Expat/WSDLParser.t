use strict;
use warnings;
use Test::More tests => 10; #qw(no_plan);
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

#my $code = "";
#$generator->set_output(\$code);
#$generator->generate_typelib();
#{
#    eval $code;
#    ok !$@;
#    print $@ if $@;
#}

$definitions = $parser->parse_uri(
     "file://$path/../../../acceptance/wsdl/WSDLParser-import.wsdl"
);

ok my $service = $definitions->first_service();
is $service->get_name(), 'Service1', 'wsdl:import service name';
is $definitions->first_binding()->get_name(), 'Service1Soap', 'wsdl:import binding name';

ok my $schema_from_ref = $definitions->first_types()->get_schema();
is @{ $schema_from_ref }, 2, 'got builtin and imported schema';
ok @{ $schema_from_ref->[1]->get_element } > 0;
is $schema_from_ref->[1]->get_element->[0]->get_name(), 'sayHello';

__END__

$generator->set_type_prefix('MyTypes');
$generator->set_element_prefix('MyElements');
$generator->set_typemap_prefix('MyTypemaps');
$generator->set_interface_prefix('MyInterfaces');

$generator->set_output(undef);
$generator->generate();

