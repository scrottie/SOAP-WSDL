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
  my ($package, %parts_of) = @_;
  
  no strict qw(refs);
  
  for my $method (keys %parts_of){
      *{ "$package\::$method" } = sub {
          my $self = shift;
          my @param = map { 
            my $data = shift || {};
            eval "require $_";
            $_->new( $data );
          } @{ $parts_of{ $method } };
          
          $self->call( $method, @param );
      }
  }

}

1;

__END__

=pod

=head1 NAME

SOAP::WSDL::Client::Base - Base client for WSDL-based SOAP access

=head1 SYNOPSIS

 package MySoapClient;
 use SOAP::WSDL::Client::Base;
 __PACKAGE__->__create_methods( qw(one two three) );
 1;

=cut