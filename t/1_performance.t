#!/usr/bin/perl -w
use strict;
use Test;
plan tests=> 6;
use Time::HiRes qw( gettimeofday tv_interval );
use lib '../..';
use Data::Dumper;
use Cwd;
use SOAP::WSDL;
ok 1; # if we made it this far, we're ok
### test vars END

print "Testing SOAP::WSDL ". $SOAP::WSDL::VERSION."\n";
print "Performance test with simple WSDL file\n";

my $data = {
		name => 'Mein Name',
		givenName => 'Vorname'
		
};

my $dir = cwd;

# chomp /t/ to allow running the script from t/ directory
$dir=~s|/t/?||;

my $t0 = [gettimeofday];
ok( my $soap=SOAP::WSDL->new(
	wsdl => "file://$dir/t/acceptance/helloworld.asmx.xml",
	no_dispatch => 1
) );
print "Create SOAP::WSDL object (".tv_interval ( $t0, [gettimeofday]) ."ms)\n" ;

$soap->proxy('http://helloworld/helloworld.asmx');

$t0 = [gettimeofday];
eval{ $soap->wsdlinit(caching => 1) };
unless ($@) {
	ok(1);
} else {
		ok 0;
		print STDERR $@;
}
print "wsdl file init (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;;
$soap->readable(1);

$t0 = [gettimeofday];
ok( $soap->call("sayHello" , %{ $data }));
print "1 x call pre-work (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;

$t0 = [gettimeofday];
ok($soap->call(sayHello => %{ $data }) );
print "1 x call pre-work (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;

$t0 = [gettimeofday];
for (my $i=1; $i<100; $i++) {
	$soap->call(sayHello => %{ $data });
}
ok(1);
print "100 x call pre-work (".tv_interval ( $t0, [gettimeofday]) ."s)\n";
