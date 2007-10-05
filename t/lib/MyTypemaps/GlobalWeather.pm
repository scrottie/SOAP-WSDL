package MyInterfaces::GlobalWeather;

use strict;
use warnings;
use MyTypemaps::GlobalWeather;
use base 'SOAP::WSDL::Client::Base';

sub new {
    my $class = shift;
    my $arg_ref = shift || {};
    my $self = $class->SUPER::new({
        class_resolver => 'MyTypemaps::GlobalWeather',
        proxy => 'http://www.webservicex.net/globalweather.asmx',
        %{ $arg_ref }
    });
    return bless $self, $class;
}

__PACKAGE__->__create_methods(
        GetWeather => {
            parts => [ 'MyElements::GetWeather', ],
            soap_action => 'http://www.webserviceX.NET/GetWeather',
            style => 'document',
            # use => '', # use not implemented yet 
        },
        GetCitiesByCountry => {
            parts => [ 'MyElements::GetCitiesByCountry', ],
            soap_action => 'http://www.webserviceX.NET/GetCitiesByCountry',
            style => 'document',
            # use => '', # use not implemented yet 
        },

);

1;

__END__





=pod

=head1 NAME 

MyInterfaces::GlobalWeather - SOAP interface to GlobalWeather at 
http://www.webservicex.net/globalweather.asmx

=head1 SYNOPSIS

 my $interface = MyInterfaces::GlobalWeather->new();
 my $GetCitiesByCountry = $interface->GetCitiesByCountry();


=head1 METHODS

=head2 GetWeather

Get weather report for all major cities around the world.

SYNOPSIS:

 $service->GetWeather({
     'CityName' => $someValue,
     'CountryName' => $someValue,
 });


=head2 GetCitiesByCountry

Get all major cities by country name(full / part).

SYNOPSIS:

 $service->GetCitiesByCountry({
     'CountryName' => $someValue,
 });



=pod

