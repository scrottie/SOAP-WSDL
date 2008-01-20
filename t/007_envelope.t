#!/usr/bin/perl
use strict;
use warnings;

use Test::More qw/no_plan/;
use lib '../lib';

eval {
    require Test::XML;
    import Test::XML;
};

use_ok qw/SOAP::WSDL::Serializer::XSD/;

my $opt = {
    readable => 1,
    namespace => {
    },
};
my $xml;
ok( $xml = SOAP::WSDL::Serializer::XSD->serialize(
    undef, undef, $opt
    ),
    "serialize empty envelope"
);

SKIP: {
    skip 'Cannot test XML content without Test::XML', 1
        if (not $Test::XML::VERSION);
    is_xml( $xml, q{<SOAP-ENV:Envelope
        xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" >
<SOAP-ENV:Body >
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>}
        , 'Content comparison' );
}
