#!/usr/bin/perl -w
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'      => 'SOAP::WSDL',
    'VERSION_FROM' => 'WSDL.pm', # finds $VERSION
    'PREREQ_PM' => { 'XML::XPath' => 0,
    		'SOAP::Lite' => 0 }
);
