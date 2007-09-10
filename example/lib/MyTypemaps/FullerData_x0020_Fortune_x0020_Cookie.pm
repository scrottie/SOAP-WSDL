package MyTypemaps::FullerData_x0020_Fortune_x0020_Cookie;
use strict;
use warnings;

my %typemap = (
'readNodeCount' => 'MyElements::readNodeCount',
'readNodeCountResponse' => 'MyElements::readNodeCountResponse',
# atomic complex type (sequence)
'readNodeCountResponse/readNodeCountResult' => 'SOAP::WSDL::XSD::Typelib::Builtin::int',

# end atomic complex type (sequence)
'GetFortuneCookie' => 'MyElements::GetFortuneCookie',
'GetFortuneCookieResponse' => 'MyElements::GetFortuneCookieResponse',
# atomic complex type (sequence)
'GetFortuneCookieResponse/GetFortuneCookieResult' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',

# end atomic complex type (sequence)
'CountCookies' => 'MyElements::CountCookies',
'CountCookiesResponse' => 'MyElements::CountCookiesResponse',
# atomic complex type (sequence)
'CountCookiesResponse/CountCookiesResult' => 'SOAP::WSDL::XSD::Typelib::Builtin::int',

# end atomic complex type (sequence)
'GetSpecificCookie' => 'MyElements::GetSpecificCookie',
# atomic complex type (sequence)
'GetSpecificCookie/index' => 'SOAP::WSDL::XSD::Typelib::Builtin::int',

# end atomic complex type (sequence)
'GetSpecificCookieResponse' => 'MyElements::GetSpecificCookieResponse',
# atomic complex type (sequence)
'GetSpecificCookieResponse/GetSpecificCookieResult' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',

# end atomic complex type (sequence)




);

sub get_class { 
  my $name = join '/', @{ $_[1] };
  exists $typemap{ $name } or die "Cannot resolve $name via " . __PACKAGE__;
  return $typemap{ $name };
}

1;

__END__

