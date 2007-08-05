use Test::More tests => 3;
use strict;
use warnings;
use lib '../lib';

use_ok('SOAP::WSDL::XSD::Typelib::Builtin::date');
my $obj;

$obj = SOAP::WSDL::XSD::Typelib::Builtin::date->new();

$obj->set_value( '2037/12/31' );

is $obj->get_value() , '2037-12-31+01:00', 'conversion';


$obj->set_value( '2037-12-31' );
is $obj->get_value() , '2037-12-31', 'no conversion on match';

