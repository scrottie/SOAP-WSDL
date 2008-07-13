#!/usr/bin/perl -w
use strict;
use warnings;
# use SOAP::Lite 'trace';
use Devel::Leak;
use Devel::Cycle;
use SOAP::WSDL;
my $path = `pwd`; chomp $path;
# I have to lookup the URL from the WSDL

use SOAP::WSDL::Factory::Transport;
SOAP::WSDL::Factory::Transport->register('http' => 'SOAP::WSDL::Transport::HTTP');

my $table;
my $count = Devel::Leak::NoteSV($table);

for (1..10) { 
    my $soap;
    $soap = SOAP::WSDL->new(
	    wsdl => "file://$path/../wsdl/11_helloworld.wsdl",
    );
    $count = Devel::Leak::NoteSV($table);
    print "SVs: $count\n";

    $soap->wsdlinit();
    # $count = Devel::Leak::NoteSV($table);
    # print "SVs: $count\n";
    # $soap->autotype(0);

my $som = $soap->call(
    "sayHello", 
    'sayHello', => { 'name' => 'Your Name',
    'givenName' => 'Your given name',
	}
);

die $som->fault->{ faultstring } if ($som->fault);

print $som->result, "\n";
    undef $som;
# $count = Devel::Leak::NoteSV($table);
# print "SVs: $count\n";
}
#}
sleep 500;
