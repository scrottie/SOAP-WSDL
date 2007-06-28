#!/usr/bin/perl
package SOAP::WSDL::XSD::Typelib::SimpleType;
use strict;
use Class::Std::Storable;
use SOAP::WSDL::XSD::Typelib::Builtin;

package SOAP::WSDL::XSD::Typelib::SimpleType::restriction;
use strict;
use Class::Std::Storable;
use SOAP::WSDL::XSD::Typelib::Builtin;
use base qw(SOAP::WSDL::XSD::Typelib::SimpleType);

1;
__END__

=pod

=head1 NAME

SOAP::WSDL::XSD::Typelib::SimpleType - simple type base class

=head1 DESCRIPTION

This module implements a base class for designing simple type classes
modelling XML Schema simpleType definitions.

=head1 SYNOPSIS

    # example simpleType derived by restriction
    # XSD would be:
    # <simpleType name="MySimpleType">
    #    <restriction base="xsd:string" />
    # </simpleType>
    package MySimpleType;
    use Class::Std::Storable;
    # restriction base implemented via inheritance
    use SOAP::WSDL::XSD::Typelib::Builtin;
    use SOAP::WSDL::XSD::Typelib::SimpleType;
    use base qw(
        # derive by restriction
        'SOAP::WSDL::XSD::Typelib::SimpleType::restriction',
        # restriction base
        'SOAP::WSDL::XSD::Typelib::Builtin::string'
    );

    # example simpleType derived by list.
    # XSD would be:
    # <simpleType name="MySimpleListType">
    #    <list itemTipe="xsd:string" />
    # </simpleType>
    package MySimpleListType;
    use Class::Std::Storable;
    # restriction base implemented via inheritance
    use SOAP::WSDL::XSD::Typelib::Builtin;
    use base ('SOAP::WSDL::XSD::Typelib::SimpleType',
        'SOAP::WSDL::XSD::Typelib::Builtin::list',        # derive by list
        'SOAP::WSDL::XSD::Typelib::Builtin::string'       # list itemType
    );

=head1 How to write your own simple type

Writing a simple type class is easy - all you have to do is setting up the
base classes correctly.

The following rules apply:

=over

=item * simpleType derived via list

simpleType classes derived via list must inherit from these classes in
exactly this order:

 SOAP::WSDL::XSD::Typelib::SimpleType
 SOAP::WSDL::XSD::Typelib::Builtin::list         # derive by list
 The::List::ItemType::Class                      # list itemType

The::List::ItemType::Class can either be a builtin class (see
SOAP::WSDL::XSD::Builtin) or another simpleType class (any other class
implementing the right methods is supported too, but not for the
faint of heart).

=item * simpleType derived via restriction

simpleType classes derived via restriction must inherit from these classes in
exactly this order:

 SOAP::WSDL::XSD::Typelib::SimpleType               # you may leave out this
 SOAP::WSDL::XSD::Typelib::SimpleType::restriction  # derive by retriction
 The::Restriction::Base::Class                      # resytriction base

The::Restriction::Base::Class can either be a builtin class (see
SOAP::WSDL::XSD::Builtin) or another simpleType class.

The slight inconsistency between the these variants is caused by the
restriction element, which has different meanings for simpleType and
complexType definitions.

=head1 Bugs and limitations

=over *

=item * Thread safety

SOAP::WSDL::XSD::Typelib::SimpleType uses Class::Std::Storable which uses
Class::Std. Class::Std is not thread safe, so
SOAP::WSDL::XSD::Typelib::SimpleType is neither.

=item * union

union simple types are not supported yet.

=item * XML Schema facets

No facets are implemented yet.

=back

=head1 AUTHOR

Replace whitespace by @ in e-mail address.

 Martin Kutter E<gt>martin.kutter fen-net.deE<lt>

=head1 COPYING

This library is free software, you may distribute/modify it under the
same terms as perl itself

=cut
