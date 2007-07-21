# Accessing the fortune cookie service at
# www.fullerdata.com/FortuneCookie/FortuneCookie.asmx
#
# I have no connection to www.fullerdata.com 
# 
# Use this script at your own risk.

# Run before:
# D:\Eigene Dateien\Martin\SOAP-WSDL\trunk>perl -I../lib wsdl2perl.pl "file:///D:/
# Eigene Dateien/Martin/SOAP-WSDL/trunk/bin/FortuneCookie.xml"

use lib 'lib/';
use MyInterfaces::FullerData_x0020_Fortune_x0020_Cookie;
use MyElements::GetFortuneCookie;
my $cookieService = MyInterfaces::FullerData_x0020_Fortune_x0020_Cookie->new();

my $cookie = $cookieService->GetFortuneCookie();

if ($cookie) {
  print $cookie->get_GetFortuneCookieResult()->get_value, "\n";
}
else {
  print $cookie;
}

$cookie = $cookieService->GetSpecificCookie({ index => 23 });
if ($cookie) {
  print $cookie
  ->get_GetSpecificCookieResult(), "\n";
}
else {
  print $cookie;
}
