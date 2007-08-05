package MyTypemaps::GlobalWeather;
use strict;
use warnings;

my %typemap = (
# SOAP 1.1 fault typemap
'Fault' => 'SOAP::WSDL::SOAP::Typelib::Fault11',
'Fault/faultcode' => 'SOAP::WSDL::XSD::Typelib::Builtin::anyURI',
'Fault/faultactor' => 'SOAP::WSDL::XSD::Typelib::Builtin::TOKEN',
'Fault/faultstring' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
'Fault/detail' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',

# generated typemap
'GetWeather' => 'MyElements::GetWeather',
# atomic complex type (sequence)
'GetWeather/CityName' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
'GetWeather/CountryName' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',

# end atomic complex type (sequence)
'GetWeatherResponse' => 'MyElements::GetWeatherResponse',
# atomic complex type (sequence)
'GetWeatherResponse/GetWeatherResult' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',

# end atomic complex type (sequence)
'GetCitiesByCountry' => 'MyElements::GetCitiesByCountry',
# atomic complex type (sequence)
'GetCitiesByCountry/CountryName' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',

# end atomic complex type (sequence)
'GetCitiesByCountryResponse' => 'MyElements::GetCitiesByCountryResponse',
# atomic complex type (sequence)
'GetCitiesByCountryResponse/GetCitiesByCountryResult' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',

# end atomic complex type (sequence)




);

sub get_class { 
  my $name = join '/', @{ $_[1] };
  exists $typemap{ $name } or die "Cannot resolve $name via " . __PACKAGE__;
  return $typemap{ $name };
}

1;

__END__

