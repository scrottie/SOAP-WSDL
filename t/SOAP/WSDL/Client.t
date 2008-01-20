use strict;
use warnings;
use Test::More tests => 4; #qw(no_plan);

use_ok qw(SOAP::WSDL::Client);

ok my $client = SOAP::WSDL::Client->new();

ok $client = SOAP::WSDL::Client->new({
    proxy => 'http://localhost',
});

is $client->get_endpoint(), 'http://localhost';