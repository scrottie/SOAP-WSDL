use Test::More tests => 176;
use Scalar::Util qw(blessed);

# use SOAP::WSDL::XSD::Typelib::Builtin::anyType;
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
use SOAP::WSDL::XSD::Typelib::Builtin::long;
use SOAP::WSDL::XSD::Typelib::Builtin::Name;
use SOAP::WSDL::XSD::Typelib::Builtin::NCName;
use SOAP::WSDL::XSD::Typelib::Builtin::NMTOKEN;
use SOAP::WSDL::XSD::Typelib::Builtin::NMTOKENS;
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


for (
qw(
 SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType
 SOAP::WSDL::XSD::Typelib::Builtin::anyURI
 SOAP::WSDL::XSD::Typelib::Builtin::base64Binary
 SOAP::WSDL::XSD::Typelib::Builtin::boolean
 SOAP::WSDL::XSD::Typelib::Builtin::byte
 SOAP::WSDL::XSD::Typelib::Builtin::date
 SOAP::WSDL::XSD::Typelib::Builtin::dateTime
 SOAP::WSDL::XSD::Typelib::Builtin::decimal
 SOAP::WSDL::XSD::Typelib::Builtin::double
 SOAP::WSDL::XSD::Typelib::Builtin::duration
 SOAP::WSDL::XSD::Typelib::Builtin::ENTITY
 SOAP::WSDL::XSD::Typelib::Builtin::float
 SOAP::WSDL::XSD::Typelib::Builtin::gDay
 SOAP::WSDL::XSD::Typelib::Builtin::gMonth
 SOAP::WSDL::XSD::Typelib::Builtin::gMonthDay
 SOAP::WSDL::XSD::Typelib::Builtin::gYear
 SOAP::WSDL::XSD::Typelib::Builtin::gYearMonth
 SOAP::WSDL::XSD::Typelib::Builtin::hexBinary
 SOAP::WSDL::XSD::Typelib::Builtin::ID
 SOAP::WSDL::XSD::Typelib::Builtin::IDREF
 SOAP::WSDL::XSD::Typelib::Builtin::IDREFS
 SOAP::WSDL::XSD::Typelib::Builtin::int
 SOAP::WSDL::XSD::Typelib::Builtin::integer
 SOAP::WSDL::XSD::Typelib::Builtin::language
 SOAP::WSDL::XSD::Typelib::Builtin::long
 SOAP::WSDL::XSD::Typelib::Builtin::Name
 SOAP::WSDL::XSD::Typelib::Builtin::NCName
 SOAP::WSDL::XSD::Typelib::Builtin::negativeInteger
 SOAP::WSDL::XSD::Typelib::Builtin::NMTOKEN
 SOAP::WSDL::XSD::Typelib::Builtin::NMTOKENS
 SOAP::WSDL::XSD::Typelib::Builtin::nonNegativeInteger
 SOAP::WSDL::XSD::Typelib::Builtin::nonPositiveInteger
 SOAP::WSDL::XSD::Typelib::Builtin::normalizedString
 SOAP::WSDL::XSD::Typelib::Builtin::NOTATION
 SOAP::WSDL::XSD::Typelib::Builtin::positiveInteger
 SOAP::WSDL::XSD::Typelib::Builtin::QName
 SOAP::WSDL::XSD::Typelib::Builtin::short
 SOAP::WSDL::XSD::Typelib::Builtin::string
 SOAP::WSDL::XSD::Typelib::Builtin::time
 SOAP::WSDL::XSD::Typelib::Builtin::token
 SOAP::WSDL::XSD::Typelib::Builtin::unsignedByte
 SOAP::WSDL::XSD::Typelib::Builtin::unsignedInt
 SOAP::WSDL::XSD::Typelib::Builtin::unsignedLong
 SOAP::WSDL::XSD::Typelib::Builtin::unsignedShort
) ) {
   my $obj = $_->new();
   ok blessed $obj;
   is $obj->get_value(), undef;
   $obj = $_->new({});
   ok blessed $obj;
    is $obj->get_value(), undef;
}