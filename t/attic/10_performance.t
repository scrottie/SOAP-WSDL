#!/usr/bin/perl -w
use strict;
use Test::More tests=> 6;
use Time::HiRes qw( gettimeofday tv_interval );
use lib '../..';
use Data::Dumper;
use Cwd;
use File::Basename;
use_ok qw/ SOAP::WSDL /;
use Benchmark;

# print "Testing SOAP::WSDL ". $SOAP::WSDL::VERSION."\n";
# print "Performance test with simple WSDL file\n";

my $data = {
		name => 'Mein Name',
		givenName => 'Vorname'
		
};

# chdir to my location
my $cwd = cwd;
my $path = dirname( $0 );
my $soap = undef;
my $name = basename( $0 );
$name =~s/\.(t|pl)$//;
chdir $path;

$path = cwd;

my $cacheDir;
if ($^O =~ m/Win/)
{
	$cacheDir = 'C:/Temp/WSDL';
}
else
{
	$cacheDir = '/tmp/';
}


my $t0 = [gettimeofday];
ok( 
	$soap=SOAP::WSDL->new(
		wsdl => "file://$path/acceptance/wsdl/10_helloworld.asmx.xml",
		no_dispatch => 1
	),
    "Create SOAP::WSDL object (".tv_interval ( $t0, [gettimeofday]) ."ms)" );

$soap->proxy('http://helloworld/helloworld.asmx');

$t0 = [gettimeofday];
eval{ 
	$soap->wsdlinit(caching => 1,
	cache_directory => $cacheDir ) };
	
unless ($@) {
	pass("wsdl file init (".tv_interval ( $t0, [gettimeofday]) ."s)");
} else {
	fail( $@ );
}
$soap->readable(1);

$t0 = [gettimeofday];
ok( $soap->call("sayHello" , %{ $data }),
	"1 x call pre-work (".tv_interval ( $t0, [gettimeofday]) ."s)") ;

$t0 = [gettimeofday];
ok($soap->call(sayHello => %{ $data }),
	"1 x call pre-work (".tv_interval ( $t0, [gettimeofday]) ."s)" );

timethis 500, sub { $soap->call(sayHello => %{ $data }) };

__END__

$t0 = [gettimeofday];
for (my $i=1; $i<100; $i++) 
{
	$soap->call(sayHello => %{ $data });
}
ok(1, "100 x call pre-work (".tv_interval ( $t0, [gettimeofday]) ."s)");

chdir $cwd;