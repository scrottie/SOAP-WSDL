use Test::More tests => 6;
use strict;
use warnings;
use lib '../lib';
use Date::Format;
use Date::Parse;
use_ok('SOAP::WSDL::XSD::Typelib::Builtin::date');
my $obj;

sub timezone {
    my @time = strptime shift;
    my $tz = strftime('%z', @time);
    substr $tz, -2, 0, ':';
    return $tz;
}

my %dates = (
    '2007/12/31' => '2007-12-31', 
    '2007:08:31' => '2007-08-31',
    '30 Aug 2007' => '2007-08-30',
);

while (my ($date, $converted) = each %dates ) {

    $obj = SOAP::WSDL::XSD::Typelib::Builtin::date->new();
    $obj->set_value( $date );
    
    is $obj->get_value() , $converted . timezone($date), 'conversion';
}

$obj->set_value('2007-12-31T00:00:00.0000000+01:00');
is $obj->get_value() , '2007-12-31+01:00', 'conversion from XML dateTime';

$obj->set_value( '2037-12-31' );
is $obj->get_value() , '2037-12-31', 'no conversion on match';

