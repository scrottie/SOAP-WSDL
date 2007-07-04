package SOAP::WSDL::XSD::Typelib::Builtin::anyType;
use strict;
use warnings;
use Class::Std::Storable;

# use $_[1] for performance
sub start_tag { 
    my $opt = $_[1] ||= {};
    return '<' . $opt->{name} . ' >' if $opt->{ name };
    return q{}
}

# use $_[1] for performance
sub end_tag { 
    return $_[1] && defined $_[1]->{ name }
        ? "</$_[1]->{name} >"
        : q{};
};

sub serialize_qualified :STRINGIFY {
    return $_[0]->serialize( { qualified => 1 } );
}

1;

__END__

=pod

=head1 NAME

SOAP::WSDL::XSD::Typelib::Builtin::anyType - Base of all XSD Types

=head1 LICENSE

Copyright 2004-2007 Martin Kutter.

This file is part of SOAP-WSDL. You may distribute/modify it under 
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=cut