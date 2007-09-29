package SOAP::WSDL::XSD::Schema::Builtin;
use strict;
use warnings;
use Class::Std::Storable;
use SOAP::WSDL::XSD::Schema;
use SOAP::WSDL::XSD::Builtin;
use base qw(SOAP::WSDL::XSD::Schema);

# all builtin types - add validation (e.g. content restrictions) later...
my %BUILTINS = (
	'string' => {},
	'boolean' => {},
	'decimal' => {},
	'dateTime' => {},
	'float' => {},
	'double' => {},
	'duration' => {},
	'time' => {},
	'date' => {},
	'gYearMonth' => {},
	'gYear' => {},
	'gMonthDay' => {},
	'gDay' => {},
	'gMonth' => {},
	'hexBinary' => {},
	'base64Binary' => {},
	'anyURI' => {},
	'QName' => {},
	'NOTATION' => {},
	'integer' => {},
	'nonPositiveInteger' => {},
	'nonNegativeInteger' => {},
	'positiveInteger' => {},
	'negativeInteger' => {},
    'long' => {},
	'int' => {},
	'unsignedInt' => {},
	'short' => {},
	'unsignedShort' => {},
	'byte' => {},
	'unsignedByte' => {},
	'normalizedString' => {},
	'token' => {},
	'NMTOKEN' => {},
);

sub START {
	my $self = shift;
	my @args = @_;

	while (my ($name, $value) = each %BUILTINS )
	{
		$self->push_type( SOAP::WSDL::XSD::Builtin->new({
                name => $name,
                targetNamespace => 'http://www.w3.org/2001/XMLSchema',
            } )
		);
	}
    return $self;
}

1;
