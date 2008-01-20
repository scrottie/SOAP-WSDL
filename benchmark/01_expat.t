#!/usr/bin/perl -w
%DB::packages=(SOAP::WSDL::Expat::MessageParser => 1);
use strict;
use warnings;
use lib '../lib';
use lib '../../Class-Std-Fast/lib';
use lib '../t/lib';
# use SOAP::WSDL::SAX::MessageHandler;

use Benchmark qw(cmpthese timethese);
use SOAP::WSDL::Expat::MessageParser;
use SOAP::WSDL::Expat::Message2Hash;
use SOAP::Lite;
use XML::Simple;
use XML::LibXML;
use MyComplexType;
use MyElement;
use MySimpleType;

my $xml = q{<SOAP-ENV:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" >
    <SOAP-ENV:Body>
    <MyAtomicComplexTypeElement xmlns="urn:Test" >
    <test>
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
    <test2 >Test55</test2>
    </test>
    </MyAtomicComplexTypeElement>
</SOAP-ENV:Body></SOAP-ENV:Envelope>};



my $parser = SOAP::WSDL::Expat::MessageParser->new({
    class_resolver => 'FakeResolver'
});

my $hash_parser = SOAP::WSDL::Expat::Message2Hash->new();

$XML::Simple::PREFERRED_PARSER = 'XML::Parser';

print "xml length: ${ \length $xml } bytes\n";

my $libxml = XML::LibXML->new();
$libxml->keep_blanks(0);
my @data;

my $deserializer = SOAP::Deserializer->new();

sub libxml_test { 
        my $dom = $libxml->parse_string( $xml );
        push @data, dom2hash( $dom->firstChild );
};

sub dom2hash {
    for ($_[0]->childNodes) {  
        if (exists $_[1]->{ $_->nodeName }) {
            if (ref $_[1]->{ $_->nodeName } eq 'ARRAY') {
                if ($_->nodeName eq '#text') {
                    push @{ $_[1] } ,$_->textContent;
                }
                else {
                    push @{ $_[1]->{ $_->nodeName } }, dom2hash( $_, {} );
                }
            }
            else {
                if ($_->nodeName eq '#text') {
                    $_[1] = [ $_[1], $_->textContent() ];
                }
                else {
                    $_[1]->{ $_->nodeName } = [ $_[1]->{ $_->nodeName } , 
                        dom2hash( $_, {} ) ];
                }
            }
        }
        else {
            if ($_->nodeName eq '#text') {
                $_[1] = $_->textContent();
            }
            else {
                $_[1]->{ $_->nodeName } = dom2hash( $_, {} );
            }
        }
    }
    return $_[1];
}

cmpthese 5000, 
{
  'SOAP::WSDL (Hash)' => sub { push @data, $hash_parser->parse( $xml ) },
  'SOAP::WSDL (XSD)' => sub { push @data, $parser->parse( $xml ) },
  'XML::Simple (Hash)' => sub { push @data, XMLin $xml },
  'XML::LibXML (DOM)' => sub { push @data,  $libxml->parse_string( $xml ) },
  'XML::LibXML (Hash)' => \&libxml_test,
  'SOAP::Lite' => sub { push @data, $deserializer->deserialize( $xml ) },
};

# data classes reside in t/lib/Typelib/
BEGIN {
    package FakeResolver;
    {
        my %class_list = (
            'MyAtomicComplexTypeElement' => 'MyAtomicComplexTypeElement',
            'MyAtomicComplexTypeElement/test' => 'MyAtomicComplexTypeElement',
            'MyAtomicComplexTypeElement/test/test2' => 'MyTestElement2',
        );

        sub get_typemap { return \%class_list; };

        sub get_map { return \%class_list };

        sub new { return bless {}, 'FakeResolver' };

        sub get_class {
            my $name = join('/', @{ $_[1] });
            return ($class_list{ $name }) ? $class_list{ $name }
                : warn "no class found for $name";
        };
    };
};
