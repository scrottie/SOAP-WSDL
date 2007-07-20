#!/usr/bin/perl
package SOAP::WSDL::Expat::MessageStreamParser;
use strict;
use warnings;
use SOAP::WSDL::XSD::Typelib::Builtin;
use XML::Parser::Expat;

=pod

=head2 new

=over

=item SYNOPSIS

 my $obj = ->new();

=item DESCRIPTION

Constructor.

=back

=cut

sub new {
    my $class = shift;
    my $self = {
        class_resolver => shift->{ class_resolver }
    };
    bless $self, $class;
    return $self;
}

sub class_resolver {
    my $self = shift;
    $self->{ class_resolver } = shift;
}

sub init {
	my $self = shift;
    my $xml = shift; 
	$self->{ data } = undef;
    
    my $characters;
    my $current = '__STOP__';
    my $ignore = [ 'Envelope', 'Body' ];
    my $list = [];
    my $namespace = {};
    my $path = [];
    my $parser = XML::Parser::ExpatNB->new();

    no strict qw(refs);     
    $parser->setHandlers(
        Start => sub {
            my ($parser, $element, %attrs) = @_;
            my ($prefix, $localname) = split m{:}xms , $element;
            # for non-prefixed elements
            if (not $localname) {
                $localname = $element;
                $prefix = q{};
            }
            # ignore top level elements
            if (@{ $ignore } && $localname eq $ignore->[0]) {
                shift @{ $ignore };
                return;
            }
            # empty characters
            $characters = q{};
    
            push @{ $path }, $localname;  # step down...
            push @{ $list }, $current;    # remember current
    
            # resolve class of this element
            my $class = $self->{ class_resolver }->get_class( $path )
                or die "Cannot resolve class for "
                    . join('/', @{ $path }) . " via $self->{ class_resolver }";
    
            # Check whether we have a primitive - we implement them as classes
            # TODO replace with UNIVERSAL->isa()
            # match is a bit faster if the string does not match, but WAY slower 
            # if $class matches...
            # if (not $class=~m{^SOAP::WSDL::XSD::Typelib::Builtin}xms) {
                
            if (index $class, 'SOAP::WSDL::XSD::Typelib::Builtin', 0 < 0) {           

                # check wheter there is a CODE reference for $class::new.
                # If not, require it - all classes required here MUST
                # define new()
                # This is the same as $class->can('new'), but it's way faster  
                *{ "$class\::new" }{ CODE } 
                    or eval "require $class"   ## no critic qw(ProhibitStringyEval)
                        or die $@;                        
            }
            # create object
            # set current object
            $current = $class->new({ %attrs });
        
            # remember top level element
            defined $self->{ data } 
                or ($self->{ data } = $current); 
        },
        Char => sub {
            $characters .= $_[1];
        },
        End => sub {        
            my $element = $_[1];

            my ($prefix, $localname) = split m{:}xms , $element;
            # for non-prefixed elements
            if (not $localname) {
                $localname = $element;
                $prefix = q{};
            }
      
            # This one easily handles ignores for us, too...
            return if not ref $list->[-1];
    
            if ( $current
                ->isa('SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType') ) {
                $current->set_value( $characters );
            }
        
            # set appropriate attribute in last element
            # multiple values must be implemented in base class
            my $method = "add_$localname";
        
            $list->[-1]->$method( $current );
        
            # step up in path
            pop @{ $path };
            
            # step up in object hierarchy...
            $current = pop @{ $list };
        }
    );

    return $parser;
}

sub get_data {
    my $self = shift;
    return $self->{ data };
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

=over

=item * Ignores all namespaces

=item * Does not handle mixed content

=item * The SOAP header is ignored

=back

=head1 AUTHOR

Replace the whitespace by @ for E-Mail Address.

 Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=head1 COPYING

This module may be used under the same terms as perl itself.

=head1 Repository information

 $ID: $

 $LastChangedDate: $
 $LastChangedRevision: $
 $LastChangedBy: $

 $HeadURL: $

