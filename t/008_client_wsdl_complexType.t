#!/usr/bin/perl -w
use strict;
use warnings;
use Test::More qw/no_plan/; # TODO: change to tests => N;
use lib '../lib';
use diagnostics;

use Cwd;

my $path = cwd;
$path =~s|\/t\/?$||;      # allow running from t/ and above (Build test)

use_ok(qw/SOAP::WSDL::Client/);

my $soap = SOAP::WSDL::Client->new(
    wsdl => 'file:///' . $path .'/t/acceptance/wsdl/008_complexType.wsdl'
)->wsdlinit();

my $wsdl = $soap->{ _WSDL }->{ wsdl_definitions };
my $schema = $wsdl->first_types();
my $type = $schema->find_type('Test' , 'testComplexTypeAll');
my $element = $type->get_element()->[0];

is $element->get_minOccurs() , 0, "minOccurs default for all";
is $element->get_maxOccurs() , 1, "maxOccurs default for all";

$type = $schema->find_type('Test' , 'testComplexTypeSequence');
$element = $type->get_element()->[0];

is $element->get_minOccurs() , 1, "minOccurs default for sequence";
is $element->get_maxOccurs() , 1, "maxOccurs default for sequence";
