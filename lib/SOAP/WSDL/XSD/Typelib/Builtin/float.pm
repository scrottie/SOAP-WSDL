package SOAP::WSDL::XSD::Typelib::Builtin::float;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

my %pattern_of          :ATTR(:name<pattern> :default<()>);
my %enumeration_of      :ATTR(:name<enumeration> :default<()>);
my %whiteSpace_of       :ATTR(:name<whiteSpace> :default<()>);
my %maxInclusive_of     :ATTR(:name<maxInclusive> :default<()>);
my %maxExclusive_of     :ATTR(:name<maxExclusive> :default<()>);
my %minInclusive_of     :ATTR(:name<minInclusive> :default<()>);
my %minExclusive_of     :ATTR(:name<minExclusive> :default<()>);


sub as_num :NUMERIFY {
    return $_[0]->get_value();
}

1;

__END__

=pod

=head1 NAME

SOAP::WSDL::XSD::Typelib::Builtin::float - float objects

=head1 LICENSE

Copyright 2004-2007 Martin Kutter.

This file is part of SOAP-WSDL. You may distribute/modify it under 
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=cut