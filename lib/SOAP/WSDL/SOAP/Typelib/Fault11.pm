package SOAP::WSDL::SOAP::Typelib::Fault11;
use strict;
use warnings;
use Class::Std::Fast::Storable constructor => 'none';

our $VERSION=q{2.00_25};

use SOAP::WSDL::XSD::Typelib::ComplexType;
use SOAP::WSDL::XSD::Typelib::Element;

use base qw(
    SOAP::WSDL::XSD::Typelib::Element
    SOAP::WSDL::XSD::Typelib::ComplexType
);

my %faultcode_of :ATTR(:get<faultcode>);
my %faultstring_of :ATTR(:get<faultstring>);
my %faultactor_of :ATTR(:get<faultactor>);
my %detail_of :ATTR(:get<detail>);

__PACKAGE__->_factory(
    [ qw(faultcode faultstring faultactor detail) ],
    {
        faultcode => \%faultcode_of,
        faultstring => \%faultstring_of,
        faultactor => \%faultactor_of,
        detail => \%detail_of,
    },
    {
        faultcode => 'SOAP::WSDL::XSD::Typelib::Builtin::QName',
        faultstring => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
        faultactor => 'SOAP::WSDL::XSD::Typelib::Builtin::anyURI',
        detail => 'SOAP::WSDL::XSD::Typelib::Builtin::anyType',
    }
);

sub get_xmlns { return 'http://schemas.xmlsoap.org/soap/envelope/' };

__PACKAGE__->__set_name('Fault');
__PACKAGE__->__set_nillable();
__PACKAGE__->__set_minOccurs();
__PACKAGE__->__set_maxOccurs();
__PACKAGE__->__set_ref('');

# always return false in boolean context - a fault is never true...
sub as_bool : BOOLIFY { return; }

Class::Std::initialize();
1;

=pod

=head1 NAME

SOAP::WSDL::SOAP::Typelib::Fault11 - SOAP 1.1 Fault class

=head1 DESCRIPTION

Models a SOAP 1.1 Fault.

SOAP::WSDL::SOAP::Typelib::Fault11 objects are false in boolean context
and serialize to XML on stringification.

This means you can do something like:

 my $soap = SOAP::WSDL::Client->new();
 # ...
 my $result = $soap->call($method, $data);
 if (not $result) {
     die "Error calling SOAP method: ", $result->get_faultstring();
 }

=head1 METHODS

=head2 get_faultcode / set_faultcode

Getter/setter for object's the faultcode property.

=head2 get_faultstring / set_faultstring

Getter/setter for object's the faultstring property.

=head2 get_faultactor / set_faultactor

Getter/setter for object's the faultactor property.

=head2 get_detail / set_detail

Getter/setter for detail object's detail property.

=head1 LICENSE AND COPYRIGHT

Copyright 2007 Martin Kutter. All rights reserved.

This file is part of SOAP-WSDL. You may distribute/modify it under
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=head1 REPOSITORY INFORMATION

 $Rev: 427 $
 $LastChangedBy: kutterma $
 $Id: Fault11.pm 427 2007-12-02 22:20:24Z kutterma $
 $HeadURL: http://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL/SOAP/Typelib/Fault11.pm $

=cut

