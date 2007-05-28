#!/usr/bin/perl -w
use strict;
use Test;
plan tests=> 11;
use Time::HiRes qw( gettimeofday tv_interval );
use lib '../lib';
use Data::Dumper;
use Cwd;

use SOAP::WSDL;

ok 1; # if we made it this far, we're ok
### test vars END

print "# Testing SOAP::WSDL ". $SOAP::WSDL::VERSION."\n";
print "# Performance test with WSDL file\n";

my $data = {	name => 'Mein Name',
		givenName => 'Vorname' };

my $dir = cwd;

# chomp /t/ to allow running the script from t/ directory
$dir=~s|/t/?||;

my $t0 = [gettimeofday];

{
  ok( my $soap=SOAP::WSDL->new(
			       wsdl => "file://$dir/t/acceptance/helloworld.asmx.xml",
			       no_dispatch => 1
			      ) );
  
  print "# Test with NO caching\n";
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
  $soap->wsdl_cache_store();
  $soap->servicename("Service1");
  $soap->portname("Service1Soap");

  $t0 = [gettimeofday];
  ok( $soap->call("sayHello" , %{ $data }));
  print "# NO cache first call: (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;
  
  $t0 = [gettimeofday];
  ok($soap->call(sayHello => %{ $data }) );
  print "# NO cache second call (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;
  
  $t0 = [gettimeofday];
  for (my $i=1; $i<100; $i++) {
    $soap->call(sayHello => %{ $data });
  }
  ok(1);
  print "# NO cache: 100 x call (".tv_interval ( $t0, [gettimeofday]) ."s)\n";
}
{
  print "# Test with caching ENABLED\n";

  $t0 = [gettimeofday];  
  ok(my $soap=SOAP::WSDL->new(
			      wsdl => "file://$dir/t/acceptance/helloworld.asmx.xml",
			      no_dispatch => 1
			     ) );
  print "# Create SOAP::WSDL object (".tv_interval ( $t0, [gettimeofday]) ."ms)\n" ;
  -e "$dir/t/cache" or mkdir "$dir/t/cache";

  $t0 = [gettimeofday];
  eval{ $soap->wsdlinit(caching => 1,cache_directory =>"$dir/t/cache") };
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
  print "# CACHE first call (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;
  
  $t0 = [gettimeofday];
  ok($soap->call(sayHello => %{ $data }) );
  print "# CACHE second call: (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;
  
  $t0 = [gettimeofday];
  for (my $i=1; $i<100; $i++) {
    $soap->call(sayHello => %{ $data });
  }
  ok(1);
  print "# CACHE: 100 x call (".tv_interval ( $t0, [gettimeofday]) ."s)\n";
  
}
