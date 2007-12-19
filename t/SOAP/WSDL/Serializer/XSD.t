use strict;
use warnings;
use Test::More qw(no_plan);

use_ok qw(SOAP::WSDL::Serializer::XSD);

my $serializer = SOAP::WSDL::Serializer::XSD->new();

like $serializer->serialize(), qr{<SOAP-ENV:Body></SOAP-ENV:Body>}, 'empty body';
like $serializer->serialize({ body => {} }), qr{<SOAP-ENV:Body></SOAP-ENV:Body>}, 'empty body';
like $serializer->serialize({ body => [] }), qr{<SOAP-ENV:Body></SOAP-ENV:Body>}, 'empty body';
like $serializer->serialize({ header => {}, body => [] }), 
    qr{<SOAP-ENV:Header></SOAP-ENV:Header><SOAP-ENV:Body></SOAP-ENV:Body>}, 'empty header and body';