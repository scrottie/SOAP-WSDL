package SOAP::WSDL::Deserializer::SOM;
use strict;
use warnings;
use Class::Std::Storable;
use SOAP::Lite;

our $VERSION='2.00_13';

sub BUILD {
    my ($self, $ident, $args_of_ref) = @_;
    
    # ignore all options
    for (keys %{ $args_of_ref }) {
        delete $args_of_ref->{ $_ };
    }
}

sub deserialize {
    my ($self, $content) = @_;
    return SOAP::Deserializer->new()->deserialize( $content );
}

sub generate_fault {
    my ($self, $args_from_ref) = @_;
    # code, message, detail, actor
    die SOAP::Fault->new(
        faultcode => $args_from_ref->{ code },
        faultstring => $args_from_ref->{ message },
        faultactor => $args_from_ref->{ role },
    );
}

1;

__END__

=head1 NAME

SOAP::WSDL::Deserializer::SOM - Deserializer SOAP messages into SOM objects

=head1 SYNOPSIS

 use SOAP::WSDL;
 use SOAP::WSDL::Deserializer::SOM;
 use SOAP::WSDL::Factory::Deserializer;
 SOAP::WSDL::Factory::Deserializer->register( '1.1', __PACKAGE__ );
 
=head1 DESCRIPTION

Deserializer for creating SOAP::Lite's SOM object as result of a SOAP call.

This package is mainly here for compatibility reasons: You don't have to 
change the rest of your SOAP::Lite based app when switching to SOAP::WSDL, 
but can just use SOAP::WSDL::Deserializer::SOM to get back the same objects 
as you were used to.

SOAP::WSDL::Deserializer will not auroregister itself - just use the lines 
from the L</SYNOPSIS> to register it as deserializer for SOAP::WSDL.

=head2 Differences from SOAP::Lite

=over

=item * No on_fault handler

You cannot specify what to do when an error occurs - SOAP::WSDL will die 
with a SOAP::Fault object on transport errors.

=back

=head2 Differences from other SOAP::WSDL::Deserializer classes

=over

=item * generate_fault

SOAP::WSDL::Deserializer::SOM will die with a SOAP::Fault object on calls 
to generate_fault.

=back

=head1 LICENSE

Copyright 2004-2007 Martin Kutter.

This file is part of SOAP-WSDL. You may distribute/modify it under 
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=head1 REPOSITORY INFORMATION

 $Rev: 176 $
 $LastChangedBy: kutterma $
 $Id: Serializer.pm 176 2007-08-31 15:28:29Z kutterma $
 $HeadURL: https://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL/Factory/Serializer.pm $
 
=cut
