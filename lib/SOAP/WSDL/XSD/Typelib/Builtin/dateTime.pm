package SOAP::WSDL::XSD::Typelib::Builtin::dateTime;
use strict;
use warnings;
use Date::Parse;
use Date::Format;
use Time::Zone;
use Class::Std::Fast::Storable constructor => 'none', cache => 1;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

sub set_value {
    # use set_value from base class if we have a XML-DateTime format
    #2037-12-31T00:00:00.0000000+01:00
    return $_[0]->SUPER::set_value($_[1]) if not $_[1];
    return $_[0]->SUPER::set_value($_[1]) if (
        $_[1] =~ m{ ^\d{4} \- \d{2} \- \d{2}
            T \d{2} \: \d{2} \: \d{2} (:? \. \d{1,7} )?
            [\+\-] \d{2} \: \d{2} $
        }xms
    );
    no warnings qw(uninitialized);
    # strptime sets empty values to undef - and strftime doesn't like that...
    my @time_from = map { ! defined $_ ? 0 : $_ } strptime($_[1]);

    undef $time_from[$#time_from];

    my $time_str = do { # no warnings;
        strftime( '%Y-%m-%dT%H:%M:%S%z', @time_from );
    };

    # insert : in timezone info
    substr $time_str, -2, 0, ':';
    $_[0]->SUPER::set_value($time_str);
}

1;
