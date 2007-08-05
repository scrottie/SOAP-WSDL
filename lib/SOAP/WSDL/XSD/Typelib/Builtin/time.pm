package SOAP::WSDL::XSD::Typelib::Builtin::time;
use strict;
use warnings;
use Date::Parse;
use Date::Format;

my %pattern_of          :ATTR(:name<pattern> :default<()>);
my %enumeration_of      :ATTR(:name<enumeration> :default<()>);
my %whiteSpace_of       :ATTR(:name<whiteSpace> :default<()>);
my %maxInclusive_of     :ATTR(:name<maxInclusive> :default<()>);
my %maxExclusive_of     :ATTR(:name<maxExclusive> :default<()>);
my %minInclusive_of     :ATTR(:name<minInclusive> :default<()>);
my %minExclusive_of     :ATTR(:name<minExclusive> :default<()>);

# Speed up. Class::Std::new is slow - and we don't need it's functionality...
BEGIN {
    use Class::Std::Storable;
    use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

    no warnings qw(redefine);
    no strict qw(refs);

    # Yes, I know it's ugly - but this is the fastest constructor to write 
    # for Class::Std-Style inside out objects..
    *{ __PACKAGE__ . '::new' } = sub {   
        my $self = bless \do { my $foo } , shift;
        if (@_) {
            $self->set_value( $_[0]->{ value } )
                if exists $_[0]->{ value }
        }
        return $self;
    };
}

sub set_value {
    # use set_value from base class if we have a XML-Time format
    # 00:00:00.0000000+01:00
    if (
        $_[1] =~ m{ ^ \d{2} \: \d{2} \: \d{2} (:? \. \d{1,7} )?
            [\+\-] \d{2} \: \d{2} $
        }xms       
    ) {
        $_[0]->SUPER::set_value($_[1])
    }
    # use a combination of strptime and strftime for converting the date
    # Unfortunately, strftime outputs the time zone as [+-]0000, whereas XML
    # whants it as [+-]00:00
    # We leave out the optional nanoseconds part, as it would always be empty.
    else {
        # strptime sets empty values to undef - and strftime doesn't like that...
        # we even need to set it to 1 to prevent a "Day '0' out of range 1..31" warning...
        my @time_from = map { ! defined $_ ? 1 : $_ } strptime($_[1]);
        my $time_str = strftime( '%H:%M:%S%z', @time_from );
        substr $time_str, -2, 0, ':';
        $_[0]->SUPER::set_value($time_str);

    }
}


1;
