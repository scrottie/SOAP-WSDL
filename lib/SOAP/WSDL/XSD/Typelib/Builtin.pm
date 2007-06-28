package SOAP::WSDL::XSD::Typelib::Builtin;
use strict;
use warnings;
use Class::Std::Storable;

# derivation classes first...
package SOAP::WSDL::XSD::Typelib::Builtin::list;
use strict;
use warnings;
use Class::Std::Storable;

sub serialize {
    my ($self, $opt) = @_;
    my $value = $self->get_value();
    return $self->start_tag({ %$opt, nil => 1 }) if not defined $value;
    $value = [ $value ] if not ref $value;
    return join q{}, $self->start_tag($opt, $value)
        , join( q{ }, @{ $value } )
        , $self->end_tag($opt, $value);
}

# Builtin classes
# Every XML schema type inherits from anyType...
package SOAP::WSDL::XSD::Typelib::Builtin::anyType;
use strict;
use warnings;
use Class::Std::Storable;

sub start_tag { 
    my ($self, $opt) = @_;
    $opt ||= {};
    return '<' . $opt->{name} . ' >' if $opt->{ name };
    return q{}
}
sub end_tag { 
    my ($self, $opt) = @_;
    $opt ||= {};
    return '</' . $opt->{name} . ' >' if $opt->{ name };
    return q{}
};

sub serialize_qualified :STRINGIFY {
    return $_[0]->serialize( { qualified => 1 } );
}

# All builtin and all simpleType types inherit from anySimpleType
package SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anyType);

my %value_of :ATTR(:name<value> :default<()>);

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

sub as_bool :BOOLIFY {
    return $value_of { ident $_[0] };
}

package SOAP::WSDL::XSD::Typelib::Builtin::dateTime;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

package SOAP::WSDL::XSD::Typelib::Builtin::duration;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

package SOAP::WSDL::XSD::Typelib::Builtin::date;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

package SOAP::WSDL::XSD::Typelib::Builtin::time;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

package SOAP::WSDL::XSD::Typelib::Builtin::gYearMonth;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

package SOAP::WSDL::XSD::Typelib::Builtin::gYear;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

package SOAP::WSDL::XSD::Typelib::Builtin::gMonthDay;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

package SOAP::WSDL::XSD::Typelib::Builtin::gMonth;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

package SOAP::WSDL::XSD::Typelib::Builtin::gDay;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

package SOAP::WSDL::XSD::Typelib::Builtin::boolean;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

sub serialize {
    my ($self, $opt) = @_;
    my $ident = ident $self;
    $opt ||= {};
    return $self->start_tag({ %$opt, nil => 1})
            if not defined $value_of{ $ident };
    return join q{}
        , $self->start_tag($opt)
        , $value_of{ $ident } ? 'true' : 'false'
        , $self->end_tag($opt);
}

sub as_num :NUMERIFY {
    return $_[0]->get_value();
}

sub set_value {
    my ($self, $value) = @_;
    $value_of{ ident $self } = defined $value
        ? ($value ne 'false' or ($value))
            ? 1 : 0
        : 0;
}

package SOAP::WSDL::XSD::Typelib::Builtin::string;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

package SOAP::WSDL::XSD::Typelib::Builtin::normalizedString;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::string);

package SOAP::WSDL::XSD::Typelib::Builtin::token;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::normalizedString);

package SOAP::WSDL::XSD::Typelib::Builtin::language;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::token);

package SOAP::WSDL::XSD::Typelib::Builtin::Name;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::token);

package SOAP::WSDL::XSD::Typelib::Builtin::NCName;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::Name);

package SOAP::WSDL::XSD::Typelib::Builtin::ID;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::NCName);

package SOAP::WSDL::XSD::Typelib::Builtin::IDREF;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::ID);

package SOAP::WSDL::XSD::Typelib::Builtin::IDREFS;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(
    SOAP::WSDL::XSD::Typelib::Builtin::list
    SOAP::WSDL::XSD::Typelib::Builtin::IDREF);

package SOAP::WSDL::XSD::Typelib::Builtin::ENTITY;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::NCName);

package SOAP::WSDL::XSD::Typelib::Builtin::NMTOKEN;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::token);

package SOAP::WSDL::XSD::Typelib::Builtin::NMTOKENS;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(
    SOAP::WSDL::XSD::Typelib::Builtin::list
    SOAP::WSDL::XSD::Typelib::Builtin::token);

package SOAP::WSDL::XSD::Typelib::Builtin::decimal;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

sub as_num :NUMERIFY :BOOLIFY {
    return $_[0]->get_value();
}

package SOAP::WSDL::XSD::Typelib::Builtin::base64Binary;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

package SOAP::WSDL::XSD::Typelib::Builtin::hex64Binary;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

package SOAP::WSDL::XSD::Typelib::Builtin::float;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

sub as_num :NUMERIFY {
    return $_[0]->get_value();
}

package SOAP::WSDL::XSD::Typelib::Builtin::double;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

sub as_num :NUMERIFY {
    return $_[0]->get_value();
}

package SOAP::WSDL::XSD::Typelib::Builtin::anyURI;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

package SOAP::WSDL::XSD::Typelib::Builtin::qName;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

package SOAP::WSDL::XSD::Typelib::Builtin::NOTATION;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

package SOAP::WSDL::XSD::Typelib::Builtin::integer;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::decimal);

package SOAP::WSDL::XSD::Typelib::Builtin::nonPositiveInteger;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::integer);

package SOAP::WSDL::XSD::Typelib::Builtin::negativeInteger;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::nonPositiveInteger);

package SOAP::WSDL::XSD::Typelib::Builtin::nonNegativeInteger;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::integer);

package SOAP::WSDL::XSD::Typelib::Builtin::unsignedLong;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::nonNegativeInteger);

package SOAP::WSDL::XSD::Typelib::Builtin::positiveInteger;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::nonNegativeInteger);

package SOAP::WSDL::XSD::Typelib::Builtin::unsignedInt;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::unsignedLong);

package SOAP::WSDL::XSD::Typelib::Builtin::unsignedShort;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::unsignedInt);

package SOAP::WSDL::XSD::Typelib::Builtin::unsignedByte;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::unsignedShort);

package SOAP::WSDL::XSD::Typelib::Builtin::long;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::integer);

package SOAP::WSDL::XSD::Typelib::Builtin::int;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::long);

package SOAP::WSDL::XSD::Typelib::Builtin::short;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::int);

package SOAP::WSDL::XSD::Typelib::Builtin::byte;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::short);

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

=head1 COPYING

This library is free software, you may distribute/modify it under the
same terms as perl itself

=cut
