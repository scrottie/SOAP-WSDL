package SOAP::WSDL::XSD::Typelib::Builtin::string;
use strict;
use warnings;
use Class::Std::Storable;
# use HTML::Entities qw(encode_entities);
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

my %length_of           :ATTR(:name<length> :default<()>);
my %minLength_of        :ATTR(:name<minLength> :default<()>);
my %maxLength_of        :ATTR(:name<maxLength> :default<()>);
my %pattern_of          :ATTR(:name<pattern> :default<()>);
my %enumeration_of      :ATTR(:name<enumeration> :default<()>);
my %whiteSpace_of       :ATTR(:name<whiteSpace> :default<()>);

my %char2entity = (
    q{&} => q{&amp;},
    q{<} => q{&lt;},
    q{>} => q{&gt;},
    q{"} => q{&qout;},
    q{'} => q{&apos;},
);

sub serialize {
    my ($self, $opt) = @_;
    my $ident = ident $self;
    $opt ||= {};
    my $value = $self->get_value();
    return $self->start_tag({ %$opt, nil => 1})
        if not defined $value;

    # HTML::Entities does the same - and more, thus it's around 1/3 slower...
    $value =~ s{([&<>"'])}{$char2entity{$1}}xgmso;

    return join q{}, $self->start_tag($opt, $value)
        #, encode_entities( $value, q{&<>"'} )
        , $value
        , $self->end_tag($opt);
}

1;

__END__

=pod

=head1 NAME

SOAP::WSDL::XSD::Typelib::Builtin::string - string objects

=head1 DESCRIPTION

String objects. XML entities (&, E<lt> E<gt> " ') are encoded on 
serialization.

=head1 LICENSE

This file is part of SOAP-WSDL. You may distribute/modify it under 
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=cut