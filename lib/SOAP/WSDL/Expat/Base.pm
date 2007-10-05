package SOAP::WSDL::Expat::Base;
use strict;
use warnings;
use XML::Parser::Expat;

sub new {
    my ($class, $args) = @_;
    my $self = {};
    bless $self, $class;
    return $self;
}

sub parse {
    eval { 
        $_[0]->_initialize( XML::Parser::Expat->new( Namespaces => 1 )  )->parse( $_[1] );
        $_[0]->{ parser }->release();
    };
    $_[0]->{ parser }->xpcroak( $@ ) if $@;
    return $_[0]->{ data };     
}

sub parsefile {
    eval { 
        $_[0]->_initialize( XML::Parser::Expat->new(Namespaces => 1) )->parsefile( $_[1] ); 
        $_[0]->{ parser }->release();
    };
    $_[0]->{ parser }->xpcroak( $@ ) if $@;
    return $_[0]->{ data };     
}

# SAX-like aliases
sub parse_string;
*parse_string = \&parse;

sub parse_file;
*parse_file = \&parsefile;

sub get_data {
    return $_[0]->{ data };
}

1;