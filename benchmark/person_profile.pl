use lib '../lib';
use lib '../example/lib';
use lib '../../SOAP-WSDL_XS/blib/lib';
use lib '../../SOAP-WSDL_XS/blib/arch';
use strict;

use MyInterfaces::TestService::TestPort;

my $soap = MyInterfaces::TestService::TestPort->new();
# Load all classes - XML::Compile has created everything before, too
for (1..100) { $soap->ListPerson({}) };
