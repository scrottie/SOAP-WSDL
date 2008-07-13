#!/usr/bin/perl -w
use strict;
use warnings;
# use SOAP::Lite 'trace';
use Devel::Leak;
use SOAP::WSDL;
use SOAP::WSDL::Definitions;
use SOAP::WSDL::Binding;
my $path = `pwd`; chomp $path;
# I have to lookup the URL from the WSDL

my $table;
my $count = Devel::Leak::NoteSV($table);
for (1..3) {
print "SVs: $count\n";
my $definitions = SOAP::WSDL::Definitions->new({
	annotation => 'Foo',
});

$definitions->set_binding(
    SOAP::WSDL::Binding->new({ parent => $definitions })
);

undef $definitions;
$count = Devel::Leak::NoteSV($table);
}
print "SVs: $count\n";

