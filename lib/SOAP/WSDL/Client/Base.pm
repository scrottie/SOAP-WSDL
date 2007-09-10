package SOAP::WSDL::Client::Base;
use strict;
use warnings;
use base 'SOAP::WSDL::Client';

sub __create_new {
  my ($package, %args_of) = @_;
  
  no strict qw(refs);
  
  *{ "$package\::new" } = sub {
      my $class = shift;
      my $self = $class->SUPER::new({
          proxy => $args_of{ proxy },
          class_resolver => $args_of{ class_resolver }
      });
      bless $self, $class;
      return $self;
  }
  
}

sub __create_methods {
  my ($package, %info_of) = @_;
  
  no strict qw(refs);
  
  for my $method (keys %info_of){
      my ($soap_action, @parts); 
      
      # up to 2.00_10 we had list refs...
      if (ref $info_of{ $method }eq 'HASH') {
          @parts = @{ $info_of{ $method }->{ parts } };
          $soap_action = $info_of{ $method }->{ soap_action };
      }
      else {
          @parts = @{ $info_of{ $method } };
          $soap_action = ();          
      }
      
      *{ "$package\::$method" } = sub {
          my $self = shift;
          my @param = map { 
            my $data = shift || {};
            eval "require $_";
            $_->new( $data );
          } @parts;
          
          return $self->SUPER::call( { 
              operation => $method, 
              soap_action => $soap_action,
          }, @param );          
      }
  }
}

1;

__END__

=pod

=head1 NAME

SOAP::WSDL::Client::Base - Factory class for WSDL-based SOAP access

=head1 SYNOPSIS

 package MySoapInterface;
 use SOAP::WSDL::Client::Base;
 __PACKAGE__->__create_new( 
        proxy => 'http://somewhere.over.the.rainbow',
        class_resolver => 'Typemap::MySoapInterface'
 );
 __PACKAGE__->__create_methods( qw(one two three) );
 1;

=head1 DESCRIPTION

Factory class for creating interface classes. Should probably be renamed to 
SOAP::WSDL::Factory::Interface...

=head1 LICENSE

Copyright 2004-2007 Martin Kutter.

This file is part of SOAP-WSDL. You may distribute/modify it under 
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=head1 REPOSITORY INFORMATION

 $Rev: 214 $
 $LastChangedBy: kutterma $
 $Id: Base.pm 214 2007-09-10 15:54:52Z kutterma $
 $HeadURL: https://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL/Client/Base.pm $
 
=cut
