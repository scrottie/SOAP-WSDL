package Foo;
sub serialize {
    return "serialized $_[1] $_[2]";
}
package main;
use strict;
use warnings;
use Test::More tests => 12;

use_ok qw(SOAP::WSDL::XSD::Element);

my $element = SOAP::WSDL::XSD::Element->new();

is $element->first_simpleType(), undef;

$element->set_simpleType('Foo');
is $element->first_simpleType(), 'Foo';

$element->set_simpleType( [ 'Foo', 'Bar' ]);
is $element->first_simpleType(), 'Foo';

is $element->first_complexType(), undef;

$element->set_complexType('Foo');
is $element->first_complexType(), 'Foo';

$element->set_complexType( [ 'Foo', 'Bar' ]);
is $element->first_complexType(), 'Foo';

$element->set_default('Foo');
is $element->serialize('Foobar', undef, { namespace => {} } ), 'serialized Foobar Foo';

$element->set_name('Bar');
is $element->serialize(undef, undef, { namespace => {} } ), 'serialized Bar Foo';

$element->set_fixed('Foobar');
is $element->serialize(undef, undef, { namespace => {} } ), 'serialized Bar Foobar';

$element->set_abstract('1');
is $element->serialize('Bar', undef, { namespace => {} } ), 'serialized Bar Foobar';

eval { $element->serialize(undef, undef, { namespace => {} } ) };
like $@, qr{cannot \s serialize \s abstract}xms;