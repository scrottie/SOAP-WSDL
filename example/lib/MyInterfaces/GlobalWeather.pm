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
              GetWeather => [ 'MyElements::GetWeather', ],
              GetCitiesByCountry => [ 'MyElements::GetCitiesByCountry', ],
      
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


=head1 Service GlobalWeather

=head2 Service information:

 Port name: GlobalWeatherSoap
 Binding: tns:GlobalWeatherSoap
 Location: http://www.webservicex.net/globalweather.asmx

=head2 SOAP Operations 

B<Note:>

 Input, output and fault messages are stated as perl hash refs. 
 
 These are only for informational purposes - the actual implementation 
 normally uses object trees, not hash refs, though the input messages 
 may be passed to the respective methods as hash refs and will be 
 converted to object trees automatically.


=head3 GetWeather

B<Input Message:>

 {
   'GetWeather'=> {
     'CityName' => $someValue,
     'CountryName' => $someValue,
   },
 }


B<Output Message:>

 {
   'GetWeather'=> {
     'CityName' => $someValue,
     'CountryName' => $someValue,
   },
 }


B<Fault:>




=head3 GetCitiesByCountry

B<Input Message:>

 {
   'GetWeather'=> {
     'CityName' => $someValue,
     'CountryName' => $someValue,
   },
 }


B<Output Message:>

 {
   'GetWeather'=> {
     'CityName' => $someValue,
     'CountryName' => $someValue,
   },
 }


B<Fault:>



=head2 Service information:

 Port name: GlobalWeatherHttpGet
 Binding: tns:GlobalWeatherHttpGet
 Location: 

=head2 SOAP Operations 

B<Note:>

 Input, output and fault messages are stated as perl hash refs. 
 
 These are only for informational purposes - the actual implementation 
 normally uses object trees, not hash refs, though the input messages 
 may be passed to the respective methods as hash refs and will be 
 converted to object trees automatically.


=head3 GetWeather

B<Input Message:>

 {
   'GetWeather'=> {
     'CityName' => $someValue,
     'CountryName' => $someValue,
   },
 }


B<Output Message:>

 {
   'GetWeather'=> {
     'CityName' => $someValue,
     'CountryName' => $someValue,
   },
 }


B<Fault:>




=head3 GetCitiesByCountry

B<Input Message:>

 {
   'GetWeather'=> {
     'CityName' => $someValue,
     'CountryName' => $someValue,
   },
 }


B<Output Message:>

 {
   'GetWeather'=> {
     'CityName' => $someValue,
     'CountryName' => $someValue,
   },
 }


B<Fault:>



=head2 Service information:

 Port name: GlobalWeatherHttpPost
 Binding: tns:GlobalWeatherHttpPost
 Location: 

=head2 SOAP Operations 

B<Note:>

 Input, output and fault messages are stated as perl hash refs. 
 
 These are only for informational purposes - the actual implementation 
 normally uses object trees, not hash refs, though the input messages 
 may be passed to the respective methods as hash refs and will be 
 converted to object trees automatically.


=head3 GetWeather

B<Input Message:>

 {
   'GetWeather'=> {
     'CityName' => $someValue,
     'CountryName' => $someValue,
   },
 }


B<Output Message:>

 {
   'GetWeather'=> {
     'CityName' => $someValue,
     'CountryName' => $someValue,
   },
 }


B<Fault:>




=head3 GetCitiesByCountry

B<Input Message:>

 {
   'GetWeather'=> {
     'CityName' => $someValue,
     'CountryName' => $someValue,
   },
 }


B<Output Message:>

 {
   'GetWeather'=> {
     'CityName' => $someValue,
     'CountryName' => $someValue,
   },
 }


B<Fault:>





=cut

