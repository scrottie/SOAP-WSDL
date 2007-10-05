use Test::More tests => 6;
use strict;
use utf8;

use SOAP::WSDL::Transport::HTTP;

my $transport = SOAP::WSDL::Transport::HTTP->new();

ok $transport->is_success(1);
ok $transport->code(200);
ok $transport->status('200 OK');
ok $transport->message('OK');

$transport->send_receive(envelope => 'Test', action => 'foo');

ok ! $transport->is_success();

$transport->send_receive(encoding => 'utf8', envelope => 'ÄÖÜ', 
    action => 'foo');
ok ! $transport->is_success();
