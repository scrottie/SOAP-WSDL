package MyTypemap;
sub get_typemap { return {} };

package HandlerClass;

sub bar {
    return "Verdammte Axt";
}
package main;
use Test::More tests => 4;

use_ok(SOAP::WSDL::Server);
use_ok(SOAP::WSDL::Server::CGI);

my $server = SOAP::WSDL::Server::CGI->new({
    class_resolver => 'MyTypemap',
});
$server->set_action_map_ref({
    'testaction' => 'testmethod',
});

eval "require IO::Scalar"
    or exit 0;
{
    no warnings qw(once);
    *IO::Scalar::BINMODE = sub {};
}
my $output = q{};
my $fh = IO::Scalar->new(\$output);
my $stdout = *STDOUT;

*STDOUT = $fh;

$server->handle();

like $output, qr{ \A Status: \s 411 \s Length \s Required}x;
$output = q{};

$ENV{'CONTENT_LENGTH'} = '0e0';
$server->handle();

like $output, qr{ Error \s deserializing }xsm;
$output = q{};

$server->set_action_map_ref({
    'foo' => 'bar',
});
$server->set_dispatch_to( 'HandlerClass' );

$server->handle();

print "\n";

$ENV{HTTP_SOAPAction} = 'test';
$server->handle();

print "\n";

$ENV{HTTP_SOAPAction} = 'foo';
$server->handle();

*STDOUT = $stdout;

# print $output;