package SOAP::WSDL::XSD::Typelib::Builtin::anyType;
use strict;
use warnings;
use Class::Std::Fast::Storable constructor => 'none';

our $VERSION = q{2.00_29};

sub get_xmlns { 'http://www.w3.org/2001/XMLSchema' };

# use $_[1] for performance
#sub start_tag {
#    return q{} if not $#_;          # return if no second argument ($opt)
#    if ($_[1]->{ name }) {
#        return qq{ $_[1]->{name}="} if $_[1]->{ attr };
#        return "<$_[1]->{name}/>" if $_[1]->{ empty };
#        return "<$_[1]->{name}>";
#    }
#    return q{};
#}

sub start_tag {
    return q{} if not $#_;          # return if no second argument ($opt)
    if ($_[1]->{ name }) {
        return qq{ $_[1]->{name}="} if $_[1]->{ attr };
        my $ending = ($_[1]->{ empty }) ? '/>' : '>';
        my @attr_from = ();
        if ($_[1]->{ nil }) {
            push @attr_from, q{ xsi:nil="true"};
            $ending = '/>';
        }
#        if (delete $_[1]->{qualified}) {
#            push @attr_from, q{ xmlns="} . $_[0]->get_xmlns() . q{"};
#        }
        push @attr_from, $_[0]->serialize_attr();

        # do we need to check for name ? Element ref="" should have it's own
        # start_tag. If we don't need to check, we can speed things up
        return join q{}, "<$_[1]->{ name }" , @attr_from , $ending;
    }
    return q{};
}

# use $_[1] for performance
sub end_tag {
    return $_[1] && defined $_[1]->{ name }
        ? $_[1]->{ attr }
            ? q{"}
            : "</$_[1]->{name}>"
        : q{};
};

sub serialize_attr {};

# sub serialize { q{} };

sub serialize_qualified :STRINGIFY {
    return $_[0]->serialize( { qualified => 1 } );
}

sub as_list :ARRAYIFY {
    return [ $_[0] ];
}

Class::Std::initialize();           # make :STRINGIFY overloading work

1;

