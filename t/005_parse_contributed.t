#!/usr/bin/perl -w
use strict;
use warnings;
use Test::More qw(no_plan);
use lib '../lib';
use File::Basename qw(dirname);
use_ok(qw/SOAP::WSDL::Expat::WSDLParser/);

my $parser;

ok($parser = SOAP::WSDL::Expat::WSDLParser->new(), "Object creation");
eval { $parser->parse_file( dirname(__FILE__) .'/contributed.wsdl' ) };
if ($@)
{
	fail("parsing WSDL");
	die "Can't test without parsed WSDL: $@";
}
else
{
	pass("parsing XML");
}

my $wsdl;
ok( $wsdl = $parser->get_data() , "get object tree");
