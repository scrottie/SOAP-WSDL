#!/usr/bin/perl -w
use strict;
use warnings;
use lib '../lib';
use lib 'lib';
use lib '../t/lib';
use SOAP::WSDL::SAX::MessageHandler;

use Benchmark;
use SOAP::WSDL::Expat::MessageParser;
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
    </MyAtomicComplexTypeElement></SOAP-ENV:Body></SOAP-ENV:Envelope>};


my $parser = SOAP::WSDL::Expat::MessageParser->new({
    class_resolver => 'FakeResolver'
});

$XML::Simple::PREFERRED_PARSER = 'XML::Parser';

my $libxml = XML::LibXML->new();

timethese 1000, 
{
  'SOAP::WSDL' => sub { $parser->parse( $xml ) },
  #'XML::Simple (Hash)' => sub { XMLin $xml },
  'XML::LibXML (DOM)' => sub { my $dom = $libxml->parse_string( $xml ) },
};

use Test::More tests => 1;
is $parser->get_data(), q{<MyAtomicComplexTypeElement xmlns="urn:Test" >}
    . q{<test >Test</test><test2 >Test2</test2></MyAtomicComplexTypeElement>}
    , 'Content comparison';

$parser->class_resolver( 'FakeResolver2' );


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
