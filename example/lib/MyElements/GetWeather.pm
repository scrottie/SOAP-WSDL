package MyElements::GetWeather;
use strict;
use Class::Std::Storable;
use SOAP::WSDL::XSD::Typelib::Element;


# atomic complexType
# <element name="GetWeather"><complexType> definition
use SOAP::WSDL::XSD::Typelib::ComplexType;
use base qw(
    SOAP::WSDL::XSD::Typelib::Element
    SOAP::WSDL::XSD::Typelib::ComplexType
);


my %CityName_of :ATTR(:get<CityName>);

my %CountryName_of :ATTR(:get<CountryName>);


__PACKAGE__->_factory(
    [ qw(
    CityName
    
    CountryName
    ) ],
    { 
       CityName => \%CityName_of, 
       CountryName => \%CountryName_of, 
        
    },
    {
      
        CityName => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
        
      
        CountryName => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
        
      
    }
);



sub get_xmlns { 'http://www.webserviceX.NET' }

__PACKAGE__->__set_name('GetWeather');
__PACKAGE__->__set_nillable();
__PACKAGE__->__set_minOccurs();
__PACKAGE__->__set_maxOccurs();
__PACKAGE__->__set_ref('');

1;


__END__






=pod

=head1 NAME 

MyElements::GetWeather

=head1 SYNOPSIS

=head1 DESCRIPTION

Type class for the XML element GetWeather. 

=head1 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY 
methods:

 CityName
 CountryName

=head1 Object structure

        CityName => 'SOAP::WSDL::XSD::Typelib::Builtin::string',        
        
        CountryName => 'SOAP::WSDL::XSD::Typelib::Builtin::string',        
        

Structure as perl hash: 

 The object structure is displayed as hash below though this is not correct.
 Complex hash elements actually are objects of their corresponding classes 
 (look for classes of the same name in your typleib).
 new() will accept a hash structure like this, but transform it to a object 
 tree.

    'GetWeather'=> {
     'CityName' => $someValue,
     'CountryName' => $someValue,
   },


=cut

