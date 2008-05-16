use strict;
use warnings;
use Test::More tests => 8; #qw(no_plan);
use_ok qw(SOAP::WSDL::Client);

ok my $client = SOAP::WSDL::Client->new();

ok $client = SOAP::WSDL::Client->new({
    proxy => 'http://localhost',
});

is $client->get_endpoint(), 'http://localhost';

$client->no_dispatch(1);
$client->set_serializer('main');
my $serialize = $client->call({
    operation => 'testMethod'
}, { foo => 'bar'}, { bar => 'baz'});
is $serialize->{ body }->{ foo }, 'bar';
is $serialize->{ header }->{ bar }, 'baz';

# Old calling style compatibility test - foo => bar is body...
$serialize = $client->call({
    operation => 'testMethod'
}, foo => 'bar');
is $serialize->{ body }->{ foo }, 'bar';

# Old calling style compatibility test - foo => bar is body...
$serialize = $client->call('testMethod', foo => 'bar');
is $serialize->{ body }->{ foo }, 'bar';

sub serialize {
    my $self = shift;
    return shift;
}
