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
use Test::More tests => 5;
use Time::HiRes qw( gettimeofday tv_interval );
use lib '../..';
use Cwd;
use_ok "SOAP::WSDL";
### test vars END
print "Testing SOAP::WSDL ". $SOAP::WSDL::VERSION."\n";
print "Acceptance test against sample output with simple WSDL\n";

my $data = {
	name => 'test',
#	givenName => 'GIVENNAME',
#	test => {
#		name => 'TESTNAME',
#		givenName => 'GIVENNAME',
#	},
#	test1 => {
#		name => 'TESTNAME',
#		givenName => 'GIVENNAME',
#		extend => 'EXTEND',
#	},
#	test2 => { 
#		name => 'TESTNAME',
#		givenName => 'GIVENNAME',
#	}
};

my $t0 = [gettimeofday];
my $dir= cwd;
$dir=~s/\/t//;
ok( my $soap=SOAP::WSDL->new(
	wsdl => 'file:///'.$dir.'/t/acceptance/test.wsdl.xml',
	no_dispatch => 1
), "Create SOAP::WSDL object (".tv_interval ( $t0, [gettimeofday]) ."s)" ); #->proxy('http://erlm5aqa.ww001.siemens.net/lasttest/helloworld/helloworld.asmx' );
$soap->proxy('http://helloworld/helloworld.asmx');
$t0 = [gettimeofday];
ok($soap->wsdlinit(), "WSDL init (".tv_interval ( $t0, [gettimeofday]) ."s)") ;

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

		if ( ($xml) && ($xml eq $xml_test) ) { pass ("Message encoding (" .tv_interval ( $t0, [gettimeofday]) ."s)") } else { 
			fail( "Message encoding (".tv_interval ( $t0, [gettimeofday]) ."s)") ;
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

		if ( ($xml) && ($xml eq $xml_test) ) { pass ("Message encoding (" .tv_interval ( $t0, [gettimeofday]) ."s)") } else { 
			fail( "Message encoding (".tv_interval ( $t0, [gettimeofday]) ."s)") ;
			print "$xml\n$xml_test\n"; };
	};
	