use Test::More tests => 2;
use strict;
use warnings;
use lib '../lib';

use_ok('SOAP::WSDL::XSD::Typelib::Builtin::dateTime');
my $obj;

$obj = SOAP::WSDL::XSD::Typelib::Builtin::dateTime->new();

$obj->set_value( '2037-12-31' );

is $obj->get_value() , '2037-12-31T00:00:00+01:00', 'conversion';

$obj->set_value('2037-12-31T00:00:00.0000000+01:00');



# exit;

#~ use Benchmark;
#~ timethese 10000, {
    #~ xml => sub { $obj->set_value('2037-12-31T00:00:00.0000000+01:00') },
    #~ string => sub { $obj->set_value('2037-12-31') },
#~ }