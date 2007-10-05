package SOAP::WSDL::XSD::Typelib::Builtin::normalizedString;
use strict;
use warnings;

# Speed up. Class::Std::new is slow - and we don't need it's functionality...
BEGIN {
    use Class::Std::Storable;
    use base qw(SOAP::WSDL::XSD::Typelib::Builtin::string);

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

};

# replace all \t, \r, \n by \s
sub set_value {
    my $value = $_[1];
    $value =~ s{ [\r\n\t] }{ }xmsg if defined($value);
    $_[0]->SUPER::set_value($value);
}

1;
