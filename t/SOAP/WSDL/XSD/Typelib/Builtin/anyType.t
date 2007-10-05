use strict;
use warnings;
use Test::More tests => 7;
use Scalar::Util qw(blessed);
use lib '../../../../../../lib';
use_ok qw(SOAP::WSDL::XSD::Typelib::Builtin::anyType);

my $obj = SOAP::WSDL::XSD::Typelib::Builtin::anyType->new();

ok blessed $obj, 'constructor returned blessed reference';

$obj = SOAP::WSDL::XSD::Typelib::Builtin::anyType->new({
    xmlns => 'urn:Siemens.mosaic'
});

ok blessed $obj, 'constructor returned blessed reference';

is $obj->get_xmlns(), 'http://www.w3.org/2001/XMLSchema', 'get_xmlns';

is $obj->start_tag({ name => 'test' }), '<test >', 'start_tag';
is $obj->end_tag({ name => 'test' }), '</test >', 'end_tag';

is "$obj", q{}, 'serialize overloading';