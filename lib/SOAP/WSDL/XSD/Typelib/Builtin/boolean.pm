package SOAP::WSDL::XSD::Typelib::Builtin::boolean;
use strict;
use warnings;

my %pattern_of          :ATTR(:name<pattern> :default<()>);
my %whiteSpace_of       :ATTR(:name<whiteSpace> :default<()>);
my %value_of            :ATTR(:get<value> :init_attr<value> :default<()>);


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
            $value_of{ ident $self } = $_[0]->{ value }
                if exists $_[0]->{ value }
        }
        return $self;
    };
}


sub serialize {
    my ($self, $opt) = @_;
    my $ident = ident $self;
    $opt ||= {};
    return $self->start_tag({ %$opt, nil => 1})
            if not defined $value_of{ $ident };
    return join q{}
        , $self->start_tag($opt)
        , $value_of{ $ident } ? 'true' : 'false'
        , $self->end_tag($opt);
}

sub as_num :NUMERIFY :BOOLIFY {
    return $_[0]->get_value();
}

sub set_value {
    my ($self, $value) = @_;
    $value_of{ ident $self } = defined $value
        ? ($value ne 'false' or ($value))
            ? 1 : 0
        : 0;
}



Class::Std::initialize();   # make :BOOLIFY overloading serializable

1;
