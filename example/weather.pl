# Accessing the globalweather service at
# www.webservicex.net/GlobalWeather/GlobalWeather.asmx
#
# Note that the GlobalWeather web service returns a (quoted) XML structure - 
# don't be surprised by the response's format.
#
# I have no connection to www.webservicex.net
# Use this script at your own risk.
#
# This script demonstrates the use of a interface generated by wsdl2perl.pl

use lib 'lib/';
use MyInterfaces::GlobalWeather;
my $weather = MyInterfaces::GlobalWeather->new();
my $result = $weather->GetWeather({ CountryName => 'Germany', CityName => 'Munich' });

die $result->get_faultstring()->get_value() if not ($result);   # boolean comparison overloaded

print $result->get_GetWeatherResult()->get_value() , "\n";
