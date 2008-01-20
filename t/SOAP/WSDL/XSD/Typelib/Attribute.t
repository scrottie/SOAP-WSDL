use strict;
use warnings;
use Test::More tests => 3; #qw(no_plan);

use_ok qw(SOAP::WSDL::XSD::Typelib::Attribute);
is SOAP::WSDL::XSD::Typelib::Attribute->start_tag(), '';
is SOAP::WSDL::XSD::Typelib::Attribute->start_tag({ name => 'foo'}, 'bar'), q{ foo="};
