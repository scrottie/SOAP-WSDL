package SOAP::WSDL::XSD::Typelib::Builtin::string;
use strict;
use warnings;

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
