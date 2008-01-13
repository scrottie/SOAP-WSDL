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
use Test::More tests => 6;
use Time::HiRes qw( gettimeofday tv_interval );
use lib '../lib';
use Cwd;
use_ok qw/SOAP::WSDL/;

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

# print $dir;
my $url = $dir . '/t/acceptance/test.wsdl.xml';
die "no wsdl found" if (not -e $url);
ok( my $soap=SOAP::WSDL->new( wsdl => 'file:///'. $url ), "Create SOAP::WSDL object");
$soap->no_dispatch( 1 );

eval{ $soap->wsdlinit() };
unless ($@) {
  pass "wsdlinit";
} else {
  fail "wsdlinit - $@";
}


ok( $soap->call(sayHello => %{ $data }) , "SOAP call");

is( $soap->servicename() , 'Service1', "Auto-detected servicename");
is( $soap->portname() , 'Service1Soap', "Auto-detected portname");

