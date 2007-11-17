use Test::More tests => 37;
use File::Basename qw(dirname);
use File::Spec;
use File::Path;

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

$generator->set_type_prefix('MyTypes');
$generator->set_element_prefix('MyElements');
$generator->set_typemap_prefix('MyTypemaps');
$generator->set_interface_prefix('MyInterfaces');

$generator->set_output(undef);
$generator->generate();
#$generator->generate_typelib();
#$generator->generate_typemap();
#$generator->generate_interface();

eval "use lib '$path/testlib'";
use_ok qw( MyInterfaces::testService::testPort );

my $interface;

ok $interface = MyInterfaces::testService::testPort->new(), 'instanciate interface';
$interface->set_no_dispatch(1);

my $message;

ok $message = $interface->testHeader( { Test1 => 'Test1', Test2 => 'Test2'} 
    , { Test1 => 'Header1', Test2 => 'Header2'}), 'call soap method (no_dispatch)';

use_ok qw(SOAP::WSDL::Expat::MessageParser);
use_ok qw(MyTypemaps::testService);

$parser = SOAP::WSDL::Expat::MessageParser->new({
    class_resolver => 'MyTypemaps::testService'
});

ok $parser->parse_string($message), 'parse message with header';
ok $parser->get_header()->get_Test1(), 'Header1';ok $message = $interface->testChoice( { Test1 => 'Test1' }  ), 'call soap method (no_dispatch)';
ok $parser->get_header()->get_Test2(), 'Header2';

ok $parser->get_data()->get_Test1(), 'Test1';
ok $parser->get_data()->get_Test2(), 'Test2';

use_ok qw(SOAP::WSDL::Transport::Loopback);

$interface->set_no_dispatch(undef);
$interface->set_transport(undef);
$interface->set_proxy('http://127.0.0.1/Test');

for (1..2) {
    my ($body, $header) = $interface->testHeader( { Test1 => 'Test1', Test2 => 'Test2'} , { Test1 => 'Header1', Test2 => 'Header2'});
    is $header->get_Test1(), 'Header1', 'Header content';
    is $header->get_Test2(), 'Header2', 'Header content';
}


# complexType choice test
ok $message = $interface->testChoice( { Test1 => 'Test1' }  ), 'call soap method (no_dispatch)';
ok $message = $interface->testChoice( { Test2 => 'Test2' }  ), 'call soap method (no_dispatch)';

TODO: {
    local $TODO = 'implement content check';
    eval { $interface->testChoice( { Test1 => 'Test1', Test2 => 'Test2' }  ) };
    ok $@, 'fail on both choice options';
}
#

ok eval { require MyTypes::testComplexTypeRestriction };
my $complexRestriction = MyTypes::testComplexTypeRestriction->new();
$complexRestriction->set_Test1('Test');
is $complexRestriction->get_Test1(), 'Test';

$complexRestriction = MyTypes::testComplexTypeRestriction->new({
    Test1 => 'test1',
    Test2 => 'test2',
});
is $complexRestriction->get_Test1(), 'test1';
is $complexRestriction->get_Test2(), 'test2';

ok eval { require MyTypes::testComplexTypeExtension };
$complexExtension = MyTypes::testComplexTypeExtension->new({
    Test1 => 'test1',
    Test2 => 'test2',
    Test3 => 'test3',
});
is $complexExtension->get_Test1(), 'test1';
is $complexExtension->get_Test2(), 'test2';
is $complexExtension->get_Test3(), 'test3';


ok eval { require MyTypes::testComplexTypeElementAtomicSimpleType; };
my $ct_east = MyTypes::testComplexTypeElementAtomicSimpleType->new({
    testString => 'Just some test',
    testAtomicSimpleTypeElement => 42,
    testAtomicSimpleTypeElement2 => 23,
});

is $ct_east->get_testAtomicSimpleTypeElement, 42;
is $ct_east->get_testAtomicSimpleTypeElement->get_value(), 42;
isa_ok($ct_east->get_testAtomicSimpleTypeElement, 
    'MyTypes::testComplexTypeElementAtomicSimpleType::_testAtomicSimpleTypeElement');


is $ct_east->get_testAtomicSimpleTypeElement2, 23;
is $ct_east->get_testAtomicSimpleTypeElement2->get_value(), 23;
isa_ok($ct_east->get_testAtomicSimpleTypeElement2, 
    'MyTypes::testComplexTypeElementAtomicSimpleType::_testAtomicSimpleTypeElement2');


rmtree "$path/testlib";
