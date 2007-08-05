#!/usr/bin/perl -w
use strict;
use warnings;
use Test::More qw/no_plan/; # TODO: change to tests => N;
use lib '../lib';
chdir 't/' if (-d 't/');

my @modules = qw(
    SOAP::WSDL::Definitions
    SOAP::WSDL::Message
    SOAP::WSDL::Operation
    SOAP::WSDL::OpMessage
    SOAP::WSDL::SoapOperation
    SOAP::WSDL::Binding
    SOAP::WSDL::Port
    SOAP::WSDL::PortType
    SOAP::WSDL::Types
    SOAP::WSDL::SAX::WSDLHandler
    SOAP::WSDL::XSD::Builtin
    SOAP::WSDL::XSD::ComplexType
    SOAP::WSDL::XSD::SimpleType
    SOAP::WSDL::XSD::Element
    SOAP::WSDL::XSD::Schema
);

for my $module (@modules)
{
    use_ok($module);
    ok($module->new(), "Object creation");
}
