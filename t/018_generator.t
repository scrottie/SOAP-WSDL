#!/usr/bin/perl -w
use strict;
use warnings;
use Test::More tests => 1;
use lib '../lib';
use XML::LibXML;
use SOAP::WSDL::SAX::WSDLHandler;
use SOAP::WSDL::SAX::MessageHandler;
use File::Path;
use File::Basename;

my $path = dirname __FILE__;

my $filter = SOAP::WSDL::SAX::WSDLHandler->new();
my $parser = XML::LibXML->new();
$parser->set_handler( $filter );
$parser->parse_file( "$path/../example/wsdl/globalweather.xml" );

my $wsdl;
ok( $wsdl = $filter->get_data() , "get object tree");

$wsdl->create({
  base_path => "$path/testlib",
  typemap_prefix => "Test::Typemap::",
  type_prefix => "Test::Type::",
  element_prefix => "Test::Element::",
  interface_prefix => "Test::Interface::",
});

rmtree "$path/testlib";