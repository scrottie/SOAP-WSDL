use strict;
use warnings;
use Test::More qw(no_plan);
use Scalar::Util qw(blessed);
use lib '../../../../../../lib';
use_ok qw(SOAP::WSDL::XSD::Typelib::Builtin::anyType);

my $obj = SOAP::WSDL::XSD::Typelib::Builtin::anyType->new({
    xmlns => 'urn:Siemens.mosaic'
});

ok blessed $obj, 'constructor returned blessed reference';

ok $obj->set_xmlns('urn:SOAP-WSDL'), 'set_xmlns';
is $obj->get_xmlns(), 'urn:SOAP-WSDL', 'get_xmlns';

is $obj->start_tag({ name => 'test' }), '<test >', 'start_tag';
is $obj->end_tag({ name => 'test' }), '</test >', 'end_tag';

is "$obj", q{}, 'serialize overloading';