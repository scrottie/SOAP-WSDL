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
use lib '../..';
use Cwd;
use File::Basename;

use SOAP::WSDL;
ok 1; # if we made it this far, we're ok
### test vars END
print "Testing SOAP::WSDL ". $SOAP::WSDL::VERSION."\n";
print "Acceptance test against sample output with simple WSDL\n";

my $data = {
	name => 'test',
	givenName => 'test',
};

my $t0 = [gettimeofday];
# chdir to my location
my $cwd = cwd;
my $path = dirname( $0 );
my $soap = undef;
my $name = basename( $0 );
$name =~s/\.(t|pl)$//;
chdir $path;

$path = cwd;

$path =~s{/attic}{}xms;


ok( $soap=SOAP::WSDL->new(
	wsdl => 'file:///'.$path.'/acceptance/wsdl/11_helloworld.wsdl',
	no_dispatch => 1
) ); 

$soap->serializer()->namespace('SOAP-ENV');
$soap->serializer()->encodingspace('SOAP-ENC');

print "Create SOAP::WSDL object (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ; 
$soap->proxy('http://helloworld/helloworld.asmx');
$t0 = [gettimeofday];
ok($soap->wsdlinit());
print "WSDL init (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;

$t0 = [gettimeofday];
do {
		my $xml = $soap->call('sayHello', 'sayHello' => %{ $data });
	
		open (FILE, "../acceptance/results/11_helloworld.xml")
		 || open (FILE, "t/acceptance/results/11_helloworld.xml") || die "can't open acceptance file";
		my $xml_test=<FILE>;
		close FILE;
		$xml=~s/^.+\<([^\/]+?)\:Body\>//;
		$xml=~s/\<\/$1\:Body\>.*//;
		
		$xml_test=~s/^.+\<([^\/]+?)\:Body\>//;
		$xml_test=~s/\<\/$1\:Body\>.*//;

		if ( ($xml) && ($xml eq $xml_test) ) { 
			ok 1;
			print "Message encoding (" .tv_interval ( $t0, [gettimeofday]) ."s)\n"
		} else { 
			ok 0;
			print "Message encoding (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;
			print "$xml\n$xml_test\n"; };
	};

$t0 = [gettimeofday];
do {
		my $xml = $soap->call(sayHello => %{ $data });
	
		open (FILE, "../acceptance/results/11_helloworld.xml")
		 || open FILE, ("t/acceptance/results/11_helloworld.xml") || die "can't open acceptance file";
		my $xml_test=<FILE>;
		close FILE;
		$xml=~s/^.+\<([^\/]+?)\:Body\>//;
		$xml=~s/\<\/$1\:Body\>.*//;
		
		$xml_test=~s/^.+\<([^\/]+?)\:Body\>//;
		$xml_test=~s/\<\/$1\:Body\>.*//;

		if ( ($xml) && ($xml eq $xml_test) ) { 
				ok 1;
				print "Message encoding (" .tv_interval ( $t0, [gettimeofday]) ."s)\n";
		} else { 
			ok 0;
			print "Message encoding (".tv_interval ( $t0, [gettimeofday]) ."s)\n" ;
			print "$xml\n$xml_test\n"; };
	};

chdir $cwd;
