package MyPart;
use Class::Std::Fast;

package main;
use strict;
use warnings;
use Test::More qw(no_plan);
use_ok qw(SOAP::WSDL::Client::Base);

my $client = SOAP::WSDL::Client::Base->new();

{
    no warnings qw(redefine once);
    *SOAP::WSDL::Client::call = sub { is $_[1]->{ operation }, 'sayHello', 'Called method';
        return $_[2], $_[3];
    };
}

my @result = $client->call({
        operation => 'sayHello',
        soap_action => 'urn:HelloWorld#sayHello',
        style => 'document',
        body => {
            
           'use' => 'literal',
            namespace => '',
            encodingStyle => '',
            parts => [qw( SOAP::WSDL::XSD::Typelib::Builtin::string )],
        },
        header => {
            parts => [qw( SOAP::WSDL::XSD::Typelib::Builtin::string )],
        },
        headerfault => {
            
        }
    }, { value => 'Body' }, { value => 'Header' });

is $result[0], 'Body';
is $result[1], 'Header';
isa_ok $result[0], 'SOAP::WSDL::XSD::Typelib::Builtin::string';

@result = $client->call({
        operation => 'sayHello',
        soap_action => 'urn:HelloWorld#sayHello',
        style => 'document',
        body => {
            
           'use' => 'literal',
            namespace => '',
            encodingStyle => '',
            parts => [qw( SOAP::WSDL::XSD::Typelib::Builtin::string )],
        },
        header => {
            parts => [qw( SOAP::WSDL::XSD::Typelib::Builtin::string )],
        },
        headerfault => {
            
        }
    }, SOAP::WSDL::XSD::Typelib::Builtin::string->new({ value => 'Body2' }), 
       SOAP::WSDL::XSD::Typelib::Builtin::string->new({ value => 'Header2' })
    );

is $result[0], 'Body2';
is $result[1], 'Header2';
isa_ok $result[1], 'SOAP::WSDL::XSD::Typelib::Builtin::string';
