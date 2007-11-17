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

# use $_[n] for speed.
# This is less readable, but notably faster.
#
# use postfix-if for speed. This is slightly faster, as it saves
# perl from creating a pad (variable context).
#
# The methods below may get called zillions of times, so
# every little statement matters...

sub serialize {
    no warnings qw(uninitialized);
    my $ident = ident $_[0];
    $_[1]->{ nil } = 1 if not defined $value_of{ $ident };
    return join q{}
        , $_[0]->start_tag($_[1], $value_of{ $ident })
        , $value_of{ $ident }
        , $_[0]->end_tag($_[1]);
}

sub as_bool :BOOLIFY {
    return $value_of { ident $_[0] };
}

Class::Std::initialize();   # make :BOOLIFY overloading serializable


1;
