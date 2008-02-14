use strict;
use warnings;
use Test::More tests => 2; #qw(no_plan);

use_ok qw(SOAP::WSDL::XSD::ComplexType);

my $obj = SOAP::WSDL::XSD::ComplexType->new();
$obj->set_variety('extension');

eval { $obj->serialize('foo') };
like $@, qr{sorry, \s we \s just}xsm;
