#!/usr/bin/perl -w
use strict;
use Test::More tests=> 7;
use Time::HiRes qw( gettimeofday tv_interval );
use lib '../..';
use Data::Dumper;
use_ok "SOAP::WSDL";
### test vars END

print "Testing SOAP::WSDL ". $SOAP::WSDL::VERSION."\n";
print "Performance test with simple WSDL file\n";

my $data = {
		name => 'Mein Name',
		givenName => 'Vorname'
		
};
my $t0 = [gettimeofday];
ok( my $soap=SOAP::WSDL->new(
	wsdl => 'file:///home/lsc/eclipse3/workspace/SOAP/t/acceptance/helloworld.asmx.xml',
	no_dispatch => 1
), "Create SOAP::WSDL object (".tv_interval ( $t0, [gettimeofday]) ."ms)" ); #->proxy('http://erlm5aqa.ww001.siemens.net/lasttest/helloworld/helloworld.asmx' );

$soap->proxy('http://erlm5aqa.ww001.siemens.net/lasttest/helloworld/helloworld.asmx');

$t0 = [gettimeofday];
ok($soap->wsdlinit(caching => 1), "wsdl file init (".tv_interval ( $t0, [gettimeofday]) ."s)" );;
$soap->readable(1);

$t0 = [gettimeofday];
ok( $soap->call("sayHello" , %{ $data }), "1 x call pre-work (".tv_interval ( $t0, [gettimeofday]) ."s)" );;

$t0 = [gettimeofday];
ok($soap->call(sayHello => %{ $data }), "1 x call pre-work (".tv_interval ( $t0, [gettimeofday]) ."s)" );;

$t0 = [gettimeofday];
for (my $i=1; $i<100; $i++) {
	$soap->call(sayHello => %{ $data });
}
ok(1, "100 x call pre-work (".tv_interval ( $t0, [gettimeofday]) ."s)" );;

$soap->call(sayHello => %{ $data });
$t0 = [gettimeofday];
for (my $i=1; $i<100; $i++) {
	$soap->call(sayHello => %{ $data });
}
ok(1, "100 x call pre-work (".tv_interval ( $t0, [gettimeofday]) ."s)" );;