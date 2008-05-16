use strict;
use warnings;
use Test::More tests => 14; #qw(no_plan);
use File::Spec;
use File::Basename;

my $path = File::Spec->rel2abs( dirname __FILE__ );
$path =~s{\\}{/}xg;     # stupid windows workaround: $path works with /, but not
                        # with \

use_ok qw( SOAP::WSDL::Expat::WSDLParser);

my $parser =  SOAP::WSDL::Expat::WSDLParser->new();

my $definitions = $parser->parse_file(
     "$path/../../../acceptance/wsdl/WSDLParser.wsdl"
);

use Data::Dumper;
my $schema = $definitions->first_types()->get_schema()->[1];
my $attr = $schema->get_element()->[0]->first_complexType->first_attribute();
ok $attr->get_name('testAttribute'),    'attribute name';
ok $attr->get_type('xs:string'),        'attribute type';


#use SOAP::WSDL::Generator::Template::XSD;
#my $generator = SOAP::WSDL::Generator::Template::XSD->new({
#    definitions => $definitions,
#    type_prefix => 'Foo',
#    element_prefix => 'Foo',
#    typemap_prefix => 'Foo',
#    OUTPUT_PATH => "$path/testlib",
#});

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

{
    my $warn_parser = SOAP::WSDL::Expat::WSDLParser->new();
    my $warning;
    local $SIG{__WARN__} = sub { $warning = join(q{}, @_ )};
    $definitions = $warn_parser->parse_file(
        "$path/../../../acceptance/wsdl/WSDLParser/import_no_location.wsdl"
    );
    like $warning, qr{cannot \s import \s document \s for \s namespace \s >urn:Test< \s without \slocation}x
        , 'warn on import without location';

    $definitions = $warn_parser->parse_uri(
        "file://$path/../../../acceptance/wsdl/WSDLParser/xsd_import_no_location.wsdl"
    );
    like $warning, qr{cannot \s import \s document \s for \s namespace \s >urn:Test< \s without \slocation}x
        , 'warn on import without location';
};

eval {
    my $warn_parser = SOAP::WSDL::Expat::WSDLParser->new();

    $definitions = $warn_parser->parse_file(
        "$path/../../../acceptance/wsdl/WSDLParser/import_xsd_cascade.wsdl"
    );
};
like $@, qr{\A cannot \s import \s document \s from \s namespace \s
    >urn:Test< \s without \s base \s uri\. \s
    Use \s >parse_uri< \s or \s >set_uri< \s to \s set \s one\.}x;

# Alarm is just to be sure - may loop infinitely if broken
$SIG{ALRM} = sub { die 'looped'};
alarm 1;

$definitions = $parser->parse_file(
     "$path/../../../acceptance/wsdl/WSDLParser_import_loop.wsdl"
);

alarm 0;
pass 'import loop';
