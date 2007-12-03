use lib 'lib';
use MyInterfaces::TestService::TestPort;

my $soap = MyInterfaces::TestService::TestPort->new();
$soap->outputxml(1);
my $result = $soap->ListPerson({});

# print "Found " . scalar @{ $result->get_out->get_NewElement } . " persons\n";

print $result;
