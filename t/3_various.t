#!/usr/bin/perl -w
use strict;
use Test;
plan tests=> 8;
use Time::HiRes qw( gettimeofday tv_interval );
use lib '../lib';
use Data::Dumper;
use Cwd;
use SOAP::WSDL;

ok 1; # if we made it this far, we're ok
### test vars END

print "# Testing SOAP::WSDL ". $SOAP::WSDL::VERSION."\n";
print "# Various Features Test with WSDL file \n";

my $data = {name => 'Mein Name',
	    givenName => 'Vorname'};

my $dir = cwd;

# chomp /t/ to allow running the script from t/ directory
$dir=~s|/t/?||;

my $t0 = [gettimeofday];
ok( my $soap=SOAP::WSDL->new(wsdl => "file://$dir/t/acceptance/helloworld.asmx.xml",
			     no_dispatch => 1
			    ));

print "# Create SOAP::WSDL object (".tv_interval ( $t0, [gettimeofday]) ."ms)\n" ;

$t0 = [gettimeofday];
eval{ $soap->wsdlinit(caching => 0) };
unless ($@) {
  ok(1);
} else {
  ok 0;
  print STDERR $@;
}
print "# wsdl file init (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;;

$soap->readable(1);
$soap->servicename("Service1");
$soap->portname("Service1Soap");

$t0 = [gettimeofday];

ok( $soap->call("sayHello" , %{ $data }));
print "# Normal Call: (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;

$soap->servicename("Service2");
$soap->portname("Service2Soap");

$data = {name => 'Mein Name',
	 givenName => 'Vorname'};

$t0 = [gettimeofday];
ok($soap->call(sayGoodBye => %{ $data }) );
print "# Multiple Services/Port Call: (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;

$soap->servicename("Service2");
$soap->portname("Service2Soap");
$data = {name => 'Mein Name',
	 givenName => 'Vorname',
	 wsdl_input_name => 'firstOverload'
	};

$t0 = [gettimeofday];

my $xml = $soap->serializer->method( $soap->call(sayGoodByeOverload => %{ $data }) );
$xml =~ /<name/ and ok(1);

$data = {
	 name => 'Mein Name',
	 givenName => 'Vorname',
	 wsdl_input_name => 'secondOverload'
	};

$t0 = [gettimeofday];
$xml = $soap->serializer->method( $soap->call(sayGoodByeOverload => %{ $data }) );
$xml !~ /<name/ and ok(1);

print "# Overloaded Calls: (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;

$soap->servicename("Service2");
$soap->portname("Service2Soap");
$data = { name => 'Mein Name',
	 'recipients' => [
			  {user_name => 'Adam', last_name => "Eden"},
			  {user_name => 'Eve',last_name => 'Apple'},
			 ],
	 wsdl_input_name => 'thirdOverload'
	};

$t0 = [gettimeofday];
$xml = $soap->serializer->method( $soap->call(sayGoodByeOverload => %{ $data }) );

my $xpath = new XML::XPath->new(xml=>$xml);

my @recipients = $xpath->findnodes('//recipients');
if($recipients[0]->findvalue("user_name")  eq "Adam" and
   $recipients[0]->findvalue("last_name")  eq "Eden" and
   $recipients[1]->findvalue("user_name")  eq "Eve" and
   $recipients[1]->findvalue("last_name")  eq "Apple"){
  ok(1);
}else{
  ok(0);
}
print "# Restricted Arrays: (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;
print "#End\n";


