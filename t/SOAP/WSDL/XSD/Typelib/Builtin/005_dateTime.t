use Test::More tests => 4;
use strict;
use warnings;
use lib '../lib';
use Date::Parse;
use Date::Format;

sub timezone {
    my @time = strptime shift;
    my $tz = strftime('%z', @time);
    substr $tz, -2, 0, ':';
    return $tz;
}

use_ok('SOAP::WSDL::XSD::Typelib::Builtin::dateTime');

print "# timezone is " . timezone( scalar localtime(time) ) . "\n";
my $obj;
my %dates = (
    '2007-12-31 12:32' => '2007-12-31T12:32:00', 
    '2007-08-31 00:32' => '2007-08-31T00:32:00',
    '30 Aug 2007' => '2007-08-30T00:00:00',
);

while (my ($date, $converted) = each %dates ) {

    $obj = SOAP::WSDL::XSD::Typelib::Builtin::dateTime->new();
    $obj->set_value( $date );
    
    is $obj->get_value() , $converted . timezone($date), 'conversion with timezone';
}
$obj->set_value('2007-12-31T00:00:00.0000000+01:00');
