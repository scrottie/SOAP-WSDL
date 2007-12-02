#!/usr/bin/perl -w
use strict;
use warnings;
use XML::Compile::WSDL11;
use XML::Compile::Transport::SOAPHTTP;

my $wsdl = XML::Compile::WSDL11->new('wsdl/11_helloworld.wsdl');

# I have to lookup the methods from the WSDL
my $call = $wsdl->compileClient('sayHello');

# I have to lookup the parameters from the WSDL
my $result = $call->(
    name => $ARGV[1] || '"Your name"',
    givenName => $ARGV[0] || '"Your given name"',
);

die "Error calling soap method" if not defined $result;

# I have to lookup the output parameters from the WSDL - or try Dumper
print $result->{ parameters }->{ sayHelloResult }, "\n";