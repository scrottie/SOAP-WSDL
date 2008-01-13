#!/usr/bin/perl -w
#######################################################################################
#
# 2_helloworld.t
#
# Acceptance test for message encoding, based on .NET wsdl and example code.
# SOAP::WSDL's encoding doesn't I<exactly> match the .NET example, because 
# .NET doesn't always specify types (SOAP::WSDL does), and the namespace 
# prefixes chosen are different (maybe the encoding style, too ? this would be a bug !)
#
########################################################################################

use strict;
use diagnostics;
use Test;
plan tests => 5;
use Time::HiRes qw( gettimeofday tv_interval );
use lib '../lib';
use Cwd;
use SOAP::WSDL;
ok 1; # if we made it this far, we're ok
### test vars END
print "# Testing SOAP::WSDL ". $SOAP::WSDL::VERSION."\n";
print "# Acceptance test against sample output with simple WSDL\n";

my $data = {
	name => 'test',
	givenName => 'GIVENNAME',
	test => {
		name => 'TESTNAME',
		givenName => 'GIVENNAME',
	},
};


my $dir= cwd;
$dir=~s/\/t\/?$//;

my $t0 = [gettimeofday];
ok( my $soap=SOAP::WSDL->new(wsdl => 'file:///'.$dir.'/t/acceptance/test.wsdl.xml',
			     no_dispatch => 1 ) );

print "# Create SOAP::WSDL object (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ; 

$t0 = [gettimeofday];
eval{ $soap->wsdlinit() };
unless ($@) {
  ok(1);
} else {
  ok 0;
  print STDERR $@;
}

print "# WSDL init (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;
$soap->servicename("Service1");
$soap->portname("Service1Soap");

$t0 = [gettimeofday];
do {
		my $xml = $soap->serializer->method( $soap->call(sayHello => %{ $data }) );
	
		open (FILE, "acceptance/helloworld.xml")
		 || open (FILE, "t/acceptance/helloworld.xml") || die "can't open acceptance file";
		my $xml_test=<FILE>;
		close FILE;
		$xml=~s/^.+\<([^\/]+?)\:Body\>//;
		$xml=~s/\<\/$1\:Body\>.*//;
		
		$xml_test=~s/^.+\<([^\/]+?)\:Body\>//;
		$xml_test=~s/\<\/$1\:Body\>.*//;

		if ( ($xml) && ($xml eq $xml_test) ) { 
			ok 1;
			print "# Message encoding (" .tv_interval ( $t0, [gettimeofday]) ."s)\n"
		} else { 
			ok 0;
			print "# Message encoding (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;
			print "$xml\n$xml_test\n"; };
	};

$t0 = [gettimeofday];
do {
		my $xml = $soap->serializer->method( $soap->call(sayHello => %{ $data }) );
	
		open (FILE, "acceptance/helloworld.xml")
		 || open FILE, ("t/acceptance/helloworld.xml") || die "can't open acceptance file";
		my $xml_test=<FILE>;
		close FILE;
		$xml=~s/^.+\<([^\/]+?)\:Body\>//;
		$xml=~s/\<\/$1\:Body\>.*//;
		
		$xml_test=~s/^.+\<([^\/]+?)\:Body\>//;
		$xml_test=~s/\<\/$1\:Body\>.*//;

		if ( ($xml) && ($xml eq $xml_test) ) { 
				ok 1;
				print "# Message encoding (" .tv_interval ( $t0, [gettimeofday]) ."s)\n";
		} else { 
			ok 0;
			print "# Message encoding (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;
			print "$xml\n$xml_test\n"; 
		      };
	      };
	
