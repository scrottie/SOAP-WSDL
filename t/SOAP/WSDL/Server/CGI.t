package MyTypemap;
sub get_typemap { return {} };

package HandlerClass;

sub bar {
    return "Verdammte Axt";
}
package main;
use Test::More;
eval "require IO::Scalar"
    or plan skip_all => 'IO::Scalar required for testing...';

plan tests => 8;

use_ok(SOAP::WSDL::Server);
use_ok(SOAP::WSDL::Server::CGI);

my $server = SOAP::WSDL::Server::CGI->new({
    class_resolver => 'MyTypemap',
});
$server->set_action_map_ref({
    'testaction' => 'testmethod',
});

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
like $output, qr{no \s element \s found}xms;
$output = q{};

$ENV{REQUEST_METHOD} = 'POST';
$ENV{HTTP_SOAPACTION} = 'test';
$server->handle();
like $output, qr{no \s element \s found}xms;
$output = q{};

delete $ENV{HTTP_SOAPACTION};

$ENV{EXPECT} = 'Foo';
$ENV{HTTP_SOAPAction} = 'foo';
$server->handle();

like $output, qr{no \s element \s found}xms;
$output = q{};

$ENV{EXPECT} = '100-Continue';
$ENV{HTTP_SOAPAction} = 'foo';
$server->handle();
like $output, qr{100 \s Continue}xms;
$output = q{};


*STDOUT = $stdout;

# print $output;