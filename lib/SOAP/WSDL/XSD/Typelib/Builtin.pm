package SOAP::WSDL::XSD::Typelib::Builtin;
use strict;
use warnings;
use Class::Std::Storable;

use SOAP::WSDL::XSD::Typelib::Builtin::anyType;
use SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType;
use SOAP::WSDL::XSD::Typelib::Builtin::anyURI;
use SOAP::WSDL::XSD::Typelib::Builtin::base64Binary;
use SOAP::WSDL::XSD::Typelib::Builtin::boolean;
use SOAP::WSDL::XSD::Typelib::Builtin::byte;
use SOAP::WSDL::XSD::Typelib::Builtin::date;
use SOAP::WSDL::XSD::Typelib::Builtin::dateTime;
use SOAP::WSDL::XSD::Typelib::Builtin::decimal;
use SOAP::WSDL::XSD::Typelib::Builtin::double;
use SOAP::WSDL::XSD::Typelib::Builtin::duration;
use SOAP::WSDL::XSD::Typelib::Builtin::ENTITY;
use SOAP::WSDL::XSD::Typelib::Builtin::float;
use SOAP::WSDL::XSD::Typelib::Builtin::gDay;
use SOAP::WSDL::XSD::Typelib::Builtin::gMonth;
use SOAP::WSDL::XSD::Typelib::Builtin::gMonthDay;
use SOAP::WSDL::XSD::Typelib::Builtin::gYear;
use SOAP::WSDL::XSD::Typelib::Builtin::gYearMonth;
use SOAP::WSDL::XSD::Typelib::Builtin::hexBinary;
use SOAP::WSDL::XSD::Typelib::Builtin::ID;
use SOAP::WSDL::XSD::Typelib::Builtin::IDREF;
use SOAP::WSDL::XSD::Typelib::Builtin::IDREFS;
use SOAP::WSDL::XSD::Typelib::Builtin::int;
use SOAP::WSDL::XSD::Typelib::Builtin::integer;
use SOAP::WSDL::XSD::Typelib::Builtin::language;
use SOAP::WSDL::XSD::Typelib::Builtin::list;
use SOAP::WSDL::XSD::Typelib::Builtin::long;
use SOAP::WSDL::XSD::Typelib::Builtin::Name;
use SOAP::WSDL::XSD::Typelib::Builtin::NCName;
use SOAP::WSDL::XSD::Typelib::Builtin::negativeInteger;
use SOAP::WSDL::XSD::Typelib::Builtin::nonNegativeInteger;
use SOAP::WSDL::XSD::Typelib::Builtin::nonPositiveInteger;
use SOAP::WSDL::XSD::Typelib::Builtin::normalizedString;
use SOAP::WSDL::XSD::Typelib::Builtin::NOTATION;
use SOAP::WSDL::XSD::Typelib::Builtin::positiveInteger;
use SOAP::WSDL::XSD::Typelib::Builtin::QName;
use SOAP::WSDL::XSD::Typelib::Builtin::short;
use SOAP::WSDL::XSD::Typelib::Builtin::string;
use SOAP::WSDL::XSD::Typelib::Builtin::time;
use SOAP::WSDL::XSD::Typelib::Builtin::token;
use SOAP::WSDL::XSD::Typelib::Builtin::unsignedByte;
use SOAP::WSDL::XSD::Typelib::Builtin::unsignedInt;
use SOAP::WSDL::XSD::Typelib::Builtin::unsignedLong;
use SOAP::WSDL::XSD::Typelib::Builtin::unsignedShort;

1;

__END__

=pod

=head1 NAME

SOAP::WSDL::XSD::Typelib::Builtin - Built-in XML Schema datatypes

=head1 DESCRIPTION

This module implements all builtin Types from the XML schema specification.

Objects of a class may be filled with values and serialize correctly.

These basic type classes are most useful when used as element or simpleType
base classes.

The datatypes classes themselves are split up into 
SOAP::WSDL::XSD::Typelib::Builtin::* modules. 

Using SOAP::WSDL::XSD::Typelib::Builtin uses all of the builtin datatype 
classes.

=head1 EXAMPLES

 my $bool = SOAP::WSDL::XSD::Typelib::Builtin::bool->new({ value => 0} );
 print $bool;    # prints "true"

 # implements <simpleType name="MySimpleType">
 #               <list itemType="xsd:string" />
 #            </simpleType>
 package MySimpleType;
 use SOAP::WSDL::XSD::Typelib::Builtin;
 use SOAP::WSDL::XSD::Typelib::SimpleType;

 use base qw(SOAP::WSDL::XSD::Typelib::SimpleType
    SOAP::WSDL::XSD::Typelib::Builtin::list
    SOAP::WSDL::XSD::Typelib::Builtin::string
 );
 1;

 # somewhere else
 my $list = MySimpleType->new({ value => [ 'You', 'shall', 'overcome' ] });
 print $list;   # prints "You shall overcome"

=head1 CLASS HIERARCHY

This is the inheritance graph for builtin types.

Types with [] marker describe types derived via the item in [] in the XML
Schema specs.

Derivation is implemented via multiple inheritance with the derivation method
as first item in the base class list.

 anyType
 - anySimpleType
     - duration
     - dateTime
     - date
     - time
     - gYearMonth
     - gYear
     - gMonthDay
     - gDay
     - gMonth
     - boolean
     - base64Binary
     - hexBinary
     - float
     - decimal
         - integer
         - nonPositiveInteger
             - negativeInteger
         - nonNegativeInteger
             - positiveInteger
             - unsignedLong
             - unsignedInt
             - unsignedShort
             - unsignedByte
         - long
             - int
                 - short
                     - byte
     - double
     - anyURI
     - string
          - normalizedString
              - language
              - Name
                  - NCName
                      - ID
                      - IDREF
                          - IDREFS [list]
                      - ENTITY
              - NMTOKEN
                  - NMTOKENS [list]

=head1 OVERLOADED OPERATORS

Overloading is implemented via Class::Std's trait mechanism.

The following behaviours apply:

=over

=item * string context

All classes use the C<serialize> method for stringification.

=item * bool context

All classes derived from anySimpleType return their value in bool context

=item * numeric context

The boolean class returns 0 or 1 in numeric context.

decimal, float and double (and derived classes) return their value in
numeric context.

=back

=head1 BUGS AND LIMITATIONS

=over

=item * Thread safety

SOAP::WSDL::XSD::Typelib::Builtin uses Class::Std::Storable which uses
Class::Std. Class::Std is not thread safe, so
SOAP::WSDL::XSD::Typelib::Builtin is neither.

=item * XML Schema facets

No facets are implemented yet.

=back

=head1 AUTHOR

Replace whitespace by @ in e-mail address.

 Martin Kutter E<gt>martin.kutter fen-net.deE<lt>

=head1 Licenxe

Copyright 2004-2007 Martin Kutter.

This library is free software, you may distribute/modify it under the
same terms as perl itself

=cut
