use lib '../lib';
use Test;
use SOAP::WSDL;
use Cwd;
use Data::Dumper;

plan tests => 9;

print "# Using SOAP::WSDL Version $SOAP::WSDL::VERSION\n";

my $name = '02_port';
# chdir to my location
my $cwd = cwd;


if (-d 't')
{
	$cwd .= '/t';
}


my $url = 'http://127.0.0.1/testPort';


ok(1);

ok( $soap = SOAP::WSDL->new(
	wsdl => 'file:///' . $cwd . '/acceptance/wsdl/' . $name . '.wsdl'
) );
ok( ($soap->servicename('testService') eq 'testService' ) );
ok( ($soap->portname('testPort') eq 'testPort' ) );

ok( $soap->wsdlinit( url => $url ) );


__END__

my $xpath = $soap->_wsdl_xpath(  );

my @ports = $xpath->findnodes( '/definitions/service[@name="' . $soap->servicename() . '"]/port/soap:address[@location="' . $url .'"]');
if (@ports)
{
	print "# found testPort URL\n";
	my $address = shift @ports;
	my $port = $address->getParentNode();
	print $port->getAttribute('binding'), "\n";
	print $port->getAttribute('name'), "\n";
}