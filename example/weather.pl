# Accessing the fortune cookie service at
# www.webservicex.net/GlobalWeather/GlobalWeather.asmx
#
# I have no connection to www.webservicex.net
# 
# Use this script at your own risk.

use lib 'lib/';
use MyInterfaces::GlobalWeather;
my $webservice = MyInterfaces::GlobalWeather->new();

my $result = $webservice->GetWeather({ CountryName => 'Germany', CityName => 'Munich' });

if ($result) {
  print $result->get_GetWeatherResult()->get_value(), "\n";
}
else {
  print $result;
}
