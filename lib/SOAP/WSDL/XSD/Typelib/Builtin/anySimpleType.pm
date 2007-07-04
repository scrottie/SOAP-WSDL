package SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anyType);

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

__END__

=pod

=head1 NAME

SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType - All builtin and all simpleType types inherit from anySimpleType

=head1 CAVEATS

=over

=item * set_value

In contrast to Class::Std-generated mutators (setters), set_value does 
not return the last value.

This is for speed reasons: SOAP::WSDL never needs to know the last value 
when calling set_calue, but calls it over and over again...

=back

=head1 LICENSE

Copyright 2004-2007 Martin Kutter.

This file is part of SOAP-WSDL. You may distribute/modify it under 
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=cut