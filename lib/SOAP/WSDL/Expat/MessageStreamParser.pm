#!/usr/bin/perl
package SOAP::WSDL::Expat::MessageStreamParser;
use strict;
use warnings;
use XML::Parser::Expat;
use SOAP::WSDL::Expat::MessageParser;
use base qw(SOAP::WSDL::Expat::MessageParser);

sub parse_start {
    my $self = shift;
    $self->{ parser } = $_[0]->_initialize( XML::Parser::ExpatNB->new() );
}
sub init;
*init = \&parse_start;

sub parse_more {
    $_[0]->{ parser }->parse_more( $_[1] );
}

sub parse_done {
    $_[0]->{ parser }->parse_done();
}

1;

=pod

=head1 NAME

SOAP::WSDL::Expat::MessageStreamParser - Convert SOAP messages to custom object trees

=head1 SYNOPSIS

 my $lwp = LWP::UserAgent->new();

 my $parser = SOAP::WSDL::Expat::MessageParser->new({
    class_resolver => 'My::Resolver'   
 });
 my $chunk_parser = $parser->init();
 # process response while it comes in, trying to read 32k chunks.
 $lwp->request( $request, sub { $chunk_parser->parse_more($_[0]) } , 32468 );
 $chunk_parser->parse_done();
 
 my $obj = $parser->get_data();

=head1 DESCRIPTION

ExpatNB based parser for parsing huge documents.

See L<SOAP::WSDL::Parser> for details.

=head1 Bugs and Limitations

See SOAP::WSDL::Expat::MessageParser

=head1 AUTHOR

Replace the whitespace by @ for E-Mail Address.

 Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=head1 COPYING

This module may be used under the same terms as perl itself.

=head1 Repository information

 $ID: $

 $LastChangedDate: 2007-09-10 17:54:52 +0200 (Mo, 10 Sep 2007) $
 $LastChangedRevision: 214 $
 $LastChangedBy: kutterma $

 $HeadURL: https://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL/Expat/MessageStreamParser.pm $

