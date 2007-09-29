#!/usr/bin/perl -w
%DB::packages=(SOAP::WSDL::Expat::MessageParser => 1);
use strict;
use warnings;
use lib '../lib';
use lib 'lib';
use lib '../t/lib';
# use SOAP::WSDL::SAX::MessageHandler;

use Benchmark;
use SOAP::WSDL::Expat::MessageParser;
use SOAP::WSDL::Expat::Message2Hash;
use XML::Simple;
use XML::LibXML;
use MyComplexType;
use MyElement;
use MySimpleType;

my $xml = q{<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" >
    <SOAP-ENV:Body><MyAtomicComplexTypeElement xmlns="urn:Test" >
    <test>Test</test>
    <test2 >Test2</test2>
    <test2 >Test2</test2>
    <test2 >Test2</test2>
    <test2 >Test2</test2>
    <test2 >Test2</test2>
    <test2 >Test2</test2>
    <test2 >Test2</test2>
    <test2 >Test2</test2>
    <test2 >Test2</test2>
    <test2 >Test2</test2>
    <test2 >Test2</test2>
    <test2 >Test2</test2>
    <test2 >Test2</test2>
    <test>Test</test>
    <test>Test</test>
    <test>Test</test>
    <test>Test</test>
    <test>Test</test>
    <test>Test</test>
    <test>Test</test>
    <test>Test</test>
    <test>Test</test>
    <test>Test</test>
    <test>Test</test>
    </MyAtomicComplexTypeElement>
</SOAP-ENV:Body></SOAP-ENV:Envelope>};


my $parser = SOAP::WSDL::Expat::MessageParser->new({
    class_resolver => 'FakeResolver'
});

my $hash_parser = SOAP::WSDL::Expat::Message2Hash->new();

$XML::Simple::PREFERRED_PARSER = 'XML::Parser';

my $libxml = XML::LibXML->new();
my @data;
timethese 10000, 
{
  'Hash (SOAP:WSDL)' => sub { push @data, $hash_parser->parse( $xml ) },
  'XSD (SOAP::WSDL)' => sub { push @data, $parser->parse( $xml ) },
  'XML::Simple (Hash)' => sub { push @data, XMLin $xml },
#  'XML::LibXML (DOM)' => sub { push @data,  $libxml->parse_string( $xml ) },
};

# use Test::More tests => 1;
#is $parser->get_data(), q{<MyAtomicComplexTypeElement xmlns="urn:Test" >}
#    . q{<test >Test</test><test2 >Test2</test2></MyAtomicComplexTypeElement>}
#    , 'Content comparison';

#$parser->class_resolver( 'FakeResolver2' );


# data classes reside in t/lib/Typelib/
BEGIN {
    package FakeResolver;
    {
        my %class_list = (
            'MyAtomicComplexTypeElement' => 'MyAtomicComplexTypeElement',
            'MyAtomicComplexTypeElement/test' => 'MyTestElement',
            'MyAtomicComplexTypeElement/test2' => 'MyTestElement2',
        );

        sub get_map { return \%class_list };

        sub new { return bless {}, 'FakeResolver' };

        sub get_class {
            my $name = join('/', @{ $_[1] });
            return ($class_list{ $name }) ? $class_list{ $name }
                : warn "no class found for $name";
        };
    };
};
