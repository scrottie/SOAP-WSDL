# Accessing the globalweather service at
# www.webservicex.net/GlobalWeather/GlobalWeather.asmx
#
# Note that the GlobalWeather web service returns a (quoted) XML structure - 
# don't be surprised by the response's format.
#
# I have no connection to www.webservicex.net
# Use this script at your own risk.
#
# This script demonstrates the use of SOAP::WSDL in SOAP::Lite style.

use lib 'lib/';
use lib '../lib';
use SOAP::WSDL;
use File::Basename qw(dirname);
use File::Spec;
my $path = File::Spec->rel2abs( dirname __FILE__);

my $soap = SOAP::WSDL->new();
my $som = $soap->wsdl("file:///$path/wsdl/globalweather.xml")
  ->call('GetWeather', GetWeather => { CountryName => 'Germany', CityName => 'Munich' });

die $som->message() if $som->fault();

print $som->result();
