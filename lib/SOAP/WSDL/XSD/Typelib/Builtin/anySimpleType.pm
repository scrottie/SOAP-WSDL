package SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType;
use strict;
use warnings;

BEGIN {
    use Class::Std::Storable;
    use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anyType);
}

my %value_of :ATTR(:get<value> :init_arg<value> :default<()>);

## use $_[n] for speed - we get called zillions of times...
# and we don't need to return the last value...
sub set_value { $value_of{ ident $_[0] } = $_[1] }

sub serialize {
    my ($self, $opt) = @_;
    my $ident = ident $self;
    $opt ||= {};
    return $self->start_tag({ %$opt, nil => 1})
        if not defined $value_of{ $ident };
    return join q{}, $self->start_tag($opt, $value_of{ $ident })
        , $value_of{ $ident }
        , $self->end_tag($opt);
}

# TODO disallow serializing !
sub as_bool :BOOLIFY {
    return $value_of { ident $_[0] };
}

Class::Std::initialize();   # make :BOOLIFY overloading serializable


1;
