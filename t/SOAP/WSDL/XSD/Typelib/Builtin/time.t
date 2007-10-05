use Test::More tests => 3;
use strict;
use warnings;
use lib '../lib';

use_ok('SOAP::WSDL::XSD::Typelib::Builtin::time');
my $obj;

$obj = SOAP::WSDL::XSD::Typelib::Builtin::time->new();

$obj->set_value( '12:23:03' );
is $obj->get_value() , '12:23:03+01:00', 'conversion';

$obj->set_value( '12:23:03.12345+01:00' ), ;
is $obj->get_value() , '12:23:03.12345+01:00', 'no conversion';



# exit;

#~ use Benchmark;
#~ timethese 10000, {
    #~ xml => sub { $obj->set_value('2037-12-31T00:00:00.0000000+01:00') },
    #~ string => sub { $obj->set_value('2037-12-31') },
#~ }