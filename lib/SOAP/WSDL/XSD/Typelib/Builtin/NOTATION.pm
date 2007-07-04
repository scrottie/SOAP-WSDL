package SOAP::WSDL::XSD::Typelib::Builtin::NOTATION;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

my %length_of           :ATTR(:name<length> :default<()>);
my %minLength_of        :ATTR(:name<minLength> :default<()>);
my %maxLength_of        :ATTR(:name<maxLength> :default<()>);
my %pattern_of          :ATTR(:name<pattern> :default<()>);
my %enumeration_of      :ATTR(:name<enumeration> :default<()>);
my %whiteSpace_of       :ATTR(:name<whiteSpace> :default<()>);


1;

__END__

=pod

=head1 NAME

SOAP::WSDL::XSD::Typelib::Builtin::NOTATION - NOTATION object

=head1 DESCRIPTION

NOTATION represents the NOTATION attribute type from 
XML 1.0 (Second Edition)

=head1 BUGS AND LIMITATIONS

Facets are implemented but don't have any influence yet.

No constraints are implemented yet.

=head1 LICENSE

This file is part of SOAP-WSDL. You may distribute/modify it under 
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=cut