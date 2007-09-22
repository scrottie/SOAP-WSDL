# Addresses issue reported by David Bussenschutt
use Test::More tests => 1;
use lib '../lib';
use SOAP::Lite;
use SOAP::WSDL;
use File::Spec;
use File::Basename qw(dirname);

my $path = File::Spec->rel2abs( dirname __FILE__);

my $soap = SOAP::WSDL->new(
    wsdl => "file://$path/acceptance/helloworld.asmx.xml"
);
my $transport = $soap->schema()->useragent()->protocols_forbidden(['file']);

# If it dies with 500 Access to 'file'..., wsdlinit uses the same UA...
eval { $soap->wsdlinit()};
ok index( $@, q{500 Access to 'file}) > 0;

