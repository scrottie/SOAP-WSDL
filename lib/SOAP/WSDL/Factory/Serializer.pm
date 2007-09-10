package SOAP::WSDL::Factory::Serializer;
use strict;
use warnings;

my %SERIALIZER = (
    '1.1' => 'SOAP::WSDL::Serializer::SOAP11',
);

# class method
sub register {
    my ($class, $ref_type, $package) = @_;
    $SERIALIZER{ $ref_type } = $package;
}

sub get_serializer {
    my ($self, $args_of_ref) = @_;
    eval "require $SERIALIZER{ $args_of_ref->{ soap_version } }" or die $@;
    return $SERIALIZER{ $args_of_ref->{ soap_version } }->new();
}

1;

=pod

=head1 NAME

SOAP::WSDL::Factory::Serializer - factory for retrieving serializer objects

=head1 SYNOPSIS

 # from SOAP::WSDL::Client:
 $serializer = SOAP::WSDL::Factory::Serializer->get_serializer({
     soap_version => $soap_version,
 });

 # in serializer class:
 package MyWickedSerializer;
 use SOAP::WSDL::Factory::Serializer;
 
 # u don't know the SOAP 1.2 recommendation? poor boy...
 SOAP::WSDL::Factory::Serializer->register( '1.2' , __PACKAGE__ );
 
=head1 DESCRIPTION

SOAP::WSDL::Factory::Serializer serves as factory for retrieving 
serializer objects for SOAP::WSDL.

The actual work is done by specific serializer classes.

SOAP::WSDL::Serializer tries to load one of the following classes:

 a) the class registered for the scheme via register()

=head1 METHODS

=head2 register

 SOAP::WSDL::Serializer->register('1.1', 'MyWickedSerializer');

Globally registers a class for use as serializer class.

=head2 get_serializer

Returns an object of the serializer class for this endpoint.

=head1 WRITING YOUR OWN SERIALIZER CLASS

Serializer classes may register with SOAP::WSDL::Factory::Serializer.

Serializer objects may also be passed directly to SOAP::WSDL::Client 
by using the set_serializer method. Note that serializers objects set 
via SOAP::WSDL::Client's set_serializer method are discarded when the 
SOAP version is changed via set_soap_version.

Registering a serializer class with SOAP::WSDL::Factory::Serializer 
is done by executing the following code where $version is the 
SOAP version the class should be used for, and $class is the class
name.

 SOAP::WSDL::Factory::Serializer->register( $version, $class);

To auto-register your transport class on loading, execute register() 
in your tranport class (see L<SYNOPSIS|SYNOPSIS> above).

Serializer modules must be named equal to the serializer 
class they contain. There can only be one serializer class per 
serializer module.

Serializer class must implement the following methods:

=over 

=item * new

Constructor.

=item * serialize

Serializes data to XML. The following named parameters are passed to 
the serialize method in a anonymous hash ref:

 {
   method => $operation_name,
   header => $header_data,
   body => $body_data,
 }

=back

=head1 LICENSE

Copyright 2004-2007 Martin Kutter.

This file is part of SOAP-WSDL. You may distribute/modify it under 
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=head1 REPOSITORY INFORMATION

 $Rev: 218 $
 $LastChangedBy: kutterma $
 $Id: Serializer.pm 218 2007-09-10 16:19:23Z kutterma $
 $HeadURL: https://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL/Factory/Serializer.pm $
 
=cut
