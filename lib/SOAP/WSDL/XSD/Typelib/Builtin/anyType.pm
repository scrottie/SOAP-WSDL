package SOAP::WSDL::XSD::Typelib::Builtin::anyType;
use strict;
use warnings;
use Class::Std::Fast::Storable constructor => 'none';

sub get_xmlns { 'http://www.w3.org/2001/XMLSchema' };

# use $_[1] for performance
sub start_tag {
    return q{} if not $#_;          # return if no second argument ($opt)
    if ($_[1]->{ name }) {
        return "<$_[1]->{name} />" if $_[1]->{ empty };
        return "<$_[1]->{name} >";
    }
    return q{};
}

# use $_[1] for performance
sub end_tag {
    return $_[1] && defined $_[1]->{ name }
        ? "</$_[1]->{name} >"
        : q{};
};

sub serialize { q{} };

sub serialize_qualified :STRINGIFY {
    return $_[0]->serialize( { qualified => 1 } );
}

sub as_list :ARRAYIFY {
    return [ $_[0] ];
}

Class::Std::initialize();           # make :STRINGIFY overloading serializable

1;

