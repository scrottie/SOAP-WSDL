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
=for later
use lib 'lib/';
use lib '../lib';
use SOAP::WSDL;
use File::Basename qw(dirname);
use File::Spec;
my $path = File::Spec->rel2abs( dirname __FILE__);

my $soap = SOAP::WSDL->new();
my $som = $soap->wsdl("file:///$path/wsdl/globalweather.xml")->no_dispatch(1)
  ->call('GetWeather', GetWeather => { CountryName => 'Germany', CityName => 'Munich' });

print $som;

=for later use

die $som->message() if $som->fault();

print $som->result();

=cut

use Carp;
use diagnostics;

use XML::Compile::WSDL;
my $schema = XML::Compile::WSDL->new('wsdl/globalweather.xml',
    schema_dirs => 'D:/Test/XMLC/'
);

my $operation = $schema->prepare('GetWeather', role => 'CLIENT', port => 'GlobalWeatherSoap');
use Data::Dumper;
print Dumper $operation;
