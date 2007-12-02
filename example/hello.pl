#!/usr/bin/perl -w
use strict;
use warnings;
use lib 'lib';

# I have to generate the interface using wsdl2perl.pl before
use MyInterfaces::HelloWorld::HelloWorldSoap;

my $soap = MyInterfaces::HelloWorld::HelloWorldSoap->new();

# I have to lookup the method and synopsis from the interface's pod
my $result = $soap->sayHello({
    name => $ARGV[1] || '"Your name"',
    givenName => $ARGV[0] || '"Your given name"',
});

die $result if not $result;

# I have to lookup the output parameter from the interface's POD - or try:
# Bad method names will die with a list of available methods
print $result->get_sayHelloResult(), "\n";