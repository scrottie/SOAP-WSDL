#!/usr/bin/perl -w
use strict;
use warnings;
use Test::More tests => 12;
use lib '../lib';
use SOAP::WSDL::Expat::WSDLParser;
use File::Find;
use File::Basename;

my $path = dirname __FILE__;
my $wsdl;

my $parser = SOAP::WSDL::Expat::WSDLParser->new();
ok( $wsdl = $parser->parse_file( "$path/../example/wsdl/globalweather.xml" ) );

$wsdl->create({
  base_path => "$path/testlib",
  typemap_prefix => "Test::Typemap::",
  type_prefix => "Test::Type::",
  element_prefix => "Test::Element::",
  interface_prefix => "Test::Interface::",
});

# Check for created files (and dirs) - value is the number of entries
# with this (local) name
my %expected = (
    'GetCitiesByCountry.pm' => 1,
    'GetCitiesByCountryResponse.pm' => 1,
    'GetWeather.pm' => 1,
    'GetWeatherResponse.pm' => 1,
    'string.pm' => 1,
    'Element' => 1,
    'Interface' => 1,
    'GlobalWeather.pm' => 2,
    'Typemap' => 1,
    'Test' => 1,
);

File::Find::finddepth(
    sub { 
        return if $_ eq '.';
        ok $expected{ $_ }--, $_;
        unlink $_ if -f $_;
        rmdir $_ if -d $_;      
    },
    "$path/testlib",
);

rmdir "$path/testlib";