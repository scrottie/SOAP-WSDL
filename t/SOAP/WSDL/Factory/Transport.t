use strict;
use warnings;
use Test::More tests => 4;
use Scalar::Util qw(blessed);
use SOAP::WSDL::Factory::Transport;

eval { SOAP::WSDL::Factory::Transport->get_transport('zumsl') };
like $@, qr{^no transport};

ok my $obj = SOAP::WSDL::Factory::Transport->get_transport('http');
ok blessed $obj;

SOAP::WSDL::Factory::Transport->register('zumsl', 'Hope_You_Have_No_Such_Package_Installed');

eval { SOAP::WSDL::Factory::Transport->get_transport('zumsl') };
like $@, qr{^Cannot load};
