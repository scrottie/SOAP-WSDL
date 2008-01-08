package SOAP::WSDL::Expat::Base;
use strict;
use warnings;
use XML::Parser::Expat;

our $VERSION = '2.00_27';

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

=pod

=head1 NAME

SOAP::WSDL::Expat::Base - Base class for XML::Parser::Expat based XML parsers

=head1 DESCRIPTION

Base class for XML::Parser::Expat based XML parsers. All XML::SAX::Expat based
parsers in SOAP::WSDL inherit from this class.

=head1 AUTHOR

Replace the whitespace by @ for E-Mail Address.

 Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright 2004-2007 Martin Kutter.

This file is part of SOAP-WSDL. You may distribute/modify it under
the same terms as perl itself

=head1 Repository information

 $Id: $

 $LastChangedDate: 2007-09-10 18:19:23 +0200 (Mo, 10 Sep 2007) $
 $LastChangedRevision: 218 $
 $LastChangedBy: kutterma $

 $HeadURL: https://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL/Expat/MessageParser.pm $
