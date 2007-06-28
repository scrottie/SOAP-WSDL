package SOAP::WSDL::XSD::Schema::Builtin;
use strict;
use warnings;
use Class::Std::Storable;
use SOAP::WSDL::XSD::Schema;
use SOAP::WSDL::XSD::Primitive;
use base qw(SOAP::WSDL::XSD::Schema);

# all builtin types - add validation (e.g. content restrictions) later...
my %PRIMITIVES = (
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
	'non-positive-integer' => {},
	'non-negative-integer' => {},
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

# TODO place into appropriate schema and push on schema definitions list
# in types
sub START {
	my $self = shift;
	my @args = @_;

	while (my ($name, $value) = each %PRIMITIVES )
	{
		$self->push_type( SOAP::WSDL::XSD::Primitive->new({
                name => $name,
                targetNamespace => 'http://www.w3.org/2001/XMLSchema',
            } )
		);
	}
    return $self;
}

1;
