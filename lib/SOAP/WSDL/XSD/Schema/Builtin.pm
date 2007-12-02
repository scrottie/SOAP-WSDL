package SOAP::WSDL::XSD::Schema::Builtin;
use strict;
use warnings;
use Class::Std::Fast::Storable;
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


=pod

=head1 NAME

SOAP:WSDL::XSD::Schema::Builtin - Provides builtin XML Schema datatypes for parsing WSDL

=head1 DESCRIPTION

Used internally by SOAP::WSDL's WSDL parser.

See <SOAP::WSDL::XSD::Typelib::Builtin|SOAP::WSDL::XSD::Typelib::Builtin> for
SOAP::WSDL::XSD's builtin XML Schema datatypes.

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007 Martin Kutter. All rights reserved.

This file is part of SOAP-WSDL. You may distribute/modify it under
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=head1 REPOSITORY INFORMATION

 $Rev: 412 $
 $LastChangedBy: kutterma $
 $Id: Builtin.pm 412 2007-11-27 22:57:52Z kutterma $
 $HeadURL: http://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL/XSD/Schema/Builtin.pm $
 
=cut

