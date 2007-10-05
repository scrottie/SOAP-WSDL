package SOAP::WSDL::XSD::Typelib::Builtin::dateTime;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);
use Date::Parse;
use Date::Format;


# XML Schema facets. We don't know how to implement them yet, but they're 
# her, just in case you wanted to know.
#
#my %pattern_of          :ATTR(:name<pattern> :default<()>);
#my %enumeration_of      :ATTR(:name<enumeration> :default<()>);
#my %whiteSpace_of       :ATTR(:name<whiteSpace> :default<()>);
#my %maxInclusive_of     :ATTR(:name<maxInclusive> :default<()>);
#my %maxExclusive_of     :ATTR(:name<maxExclusive> :default<()>);
#my %minInclusive_of     :ATTR(:name<minInclusive> :default<()>);
#my %minExclusive_of     :ATTR(:name<minExclusive> :default<()>);

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
    # use set_value from base class if we have a XML-DateTime format
    #2037-12-31T00:00:00.0000000+01:00
    return $_[0]->SUPER::set_value($_[1]) if (
        $_[1] =~ m{ ^\d{4} \- \d{2} \- \d{2} 
            T \d{2} \: \d{2} \: \d{2} (:? \. \d{1,7} )?
            [\+\-] \d{2} \: \d{2} $
        }xms       
    );
    
    # strptime sets empty values to undef - and strftime doesn't like that...
    my @time_from = map { ! defined $_ ? 0 : $_ } strptime($_[1]);
    undef $time_from[-1];
        
    my $time_str = strftime( '%Y-%m-%dT%H:%M:%S%z', @time_from );
    substr $time_str, -2, 0, ':';
    $_[0]->SUPER::set_value($time_str);
}

1;
