package SOAP::WSDL::SOAP::Typelib::Fault11;
use strict;
use warnings;
use Class::Std::Storable;
use Data::Dumper;

use SOAP::WSDL::XSD::Typelib::ComplexType;
use SOAP::WSDL::XSD::Typelib::Element;

use base qw(
    SOAP::WSDL::XSD::Typelib::Element
    SOAP::WSDL::XSD::Typelib::ComplexType
);

my %faultcode_of :ATTR(:get<faultcode>);
my %faultstring_of :ATTR(:get<faultstring>);
my %faultactor_of :ATTR(:get<faultactor>);
my %detail_of :ATTR(:get<faultdetail>);

# always return false in boolean context - a fault is never true...
sub as_bool :BOOLIFY { return; }

__PACKAGE__->_factory(
    [ qw(faultcode faultstring faultactor faultdetail) ],
    {
        faultcode => \%faultcode_of,
        faultstring => \%faultstring_of,
        faultactor => \%faultactor_of,
        detail => \%detail_of,          
    },
    {
        faultcode => 'SOAP::WSDL::XSD::Typelib::Builtin::QName',
        faultstring => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
        faultactor => 'SOAP::WSDL::XSD::Typelib::Builtin::anyURI',
        detail => 'SOAP::WSDL::XSD::Typelib::Builtin::anyType',            
    }
);

sub get_xmlns { return 'http://schemas.xmlsoap.org/soap/envelope/' };

__PACKAGE__->__set_name('Fault');
__PACKAGE__->__set_nillable();
__PACKAGE__->__set_minOccurs();
__PACKAGE__->__set_maxOccurs();
__PACKAGE__->__set_ref('');

1;