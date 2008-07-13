use strict; use warnings;
use Test::More tests => 6;

use_ok qw(SOAP::WSDL::Base);

my $obj = SOAP::WSDL::Base->new();

ok $obj->push_annotation('foo');
ok $obj->push_annotation('foo');
ok $obj->push_annotation('foo');

ok $obj->set_namespace('foo');
ok $obj->push_namespace('foo');
