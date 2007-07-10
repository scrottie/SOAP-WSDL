use Test::More tests => 4;
use strict;
use warnings;
use diagnostics;
use lib '../lib';
use Benchmark;

use_ok('SOAP::WSDL::XSD::Typelib::Builtin::string');
my $obj;

ok $obj = SOAP::WSDL::XSD::Typelib::Builtin::string->new(
    { value => '& "Aber" <test>'})
    , "Object creation";
    
is $obj, '&amp; &qout;Aber&qout; &lt;test&gt;'
    , 'escape text on serialization';
    
is $obj->serialize({ name => 'test'})
    , '<test >&amp; &qout;Aber&qout; &lt;test&gt;</test >'
    , 'Serialization with name';