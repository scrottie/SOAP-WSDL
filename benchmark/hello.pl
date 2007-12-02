#!/usr/bin/perl -w
use strict;
use warnings;
use lib '../example/lib';
use lib '/home/martin/workspace/SOAP-WSDL-Fast_XS/blib/lib';
use lib '/home/martin/workspace/SOAP-WSDL-Fast_XS/blib/arch';
use SOAP::Lite;
use XML::Compile::WSDL11;
use XML::Compile::Transport::SOAPHTTP;
use MyInterfaces::HelloWorld::HelloWorldSoap;
use SOAP::WSDL::Deserializer::XSD_XS;
use Benchmark qw(cmpthese);

my $lite = SOAP::Lite->new(
    proxy => 'http://localhost:81/soap-wsdl-test/helloworld.pl'
);

$lite->on_action( sub { "urn:HelloWorld#sayHello" });
$lite->autotype(0);

my $soap = MyInterfaces::HelloWorld::HelloWorldSoap->new();

my $soap_xs = MyInterfaces::HelloWorld::HelloWorldSoap->new();
$soap_xs->set_deserializer( SOAP::WSDL::Deserializer::XSD_XS->new() );

my @result;

sub wsdl_bench {
    push @result, $soap->sayHello({
        name => $ARGV[1] || '"Your name"',
        givenName => $ARGV[0] || '"Your given name"',
    });
}

sub wsdl_xs_bench {
    push @result, $soap_xs->sayHello({
        name => $ARGV[1] || '"Your name"',
        givenName => $ARGV[0] || '"Your given name"',
    });
}

my $wsdl = XML::Compile::WSDL11->new('../example/wsdl/11_helloworld.wsdl');
my $call = $wsdl->compileClient('sayHello');

sub compile_bench {
    push @result, $call->(
        name => $ARGV[1] || '"Your name"',
        givenName => $ARGV[0] || '"Your given name"',
    );
}

sub lite_bench {
    push @result, $lite->call(
        SOAP::Data->name("sayHello")
            ->attr({ xmlns => 'urn:HelloWorld' }),
        SOAP::Data->name('name')->value( $ARGV[1] || '"Your name"'),
        SOAP::Data->name('givenName')->value( $ARGV[0] || '"Your given name"'),
    );
}

wsdl_bench();
wsdl_xs_bench();

cmpthese 150, {
    'SOAP::WSDL' => \&wsdl_bench,
    'SOAP::WSDL_XS' => \&wsdl_xs_bench,
    'XML::Compile' => \&compile_bench,
    # 'SOAP::Lite' => \&lite_bench,
}
