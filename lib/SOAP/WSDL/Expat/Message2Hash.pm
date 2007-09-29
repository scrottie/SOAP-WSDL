#!/usr/bin/perl
package SOAP::WSDL::Expat::Message2Hash;
use strict;
use warnings;
use XML::Parser::Expat;

sub new {
    my ($class, $args) = @_;
    my $self = {};
    bless $self, $class;
    return $self;
}

sub _initialize {
    my ($self, $parser) = @_;
    $self->{ parser } = $parser;
    delete $self->{ data };                     # remove potential old results
    
    my $characters;
    my $current = {};
    my $list = [];                      # node list
    my $current_part = q{};             # are we in header or body ?
    $self->{ data } = $current;
    
    # use "globals" for speed
    my ($_prefix, $_localname, $_element, $_method, 
        $_class, $_parser, %_attrs) = ();

    no strict qw(refs);     
    $parser->setHandlers(
        Start => sub {
            push @$list, $current;
 	        #If our element exists and is a list ref, add to it
            if ( exists $current->{ $_[1] } 
		      && ( ref ($current->{ $_[1] }) eq 'ARRAY') 
	        )  {
	            push @{ $current->{ $_[1] } }, {};
	            $current = $current->{ $_[1] }->[-1];
        	}
           	elsif ( exists $current->{ $_[1] } ) 
        	{
                $current->{ $_[1] } = [ $current->{ $_[1] }, {} ];
	            $current = $current->{ $_[1] }->[-1];
        	}    
            else {
                $current->{ $_[1] } = {};
                $current = $current->{ $_[1] };
            }
            return;
        },
        
        Char => sub {
            $characters .= $_[1] if $_[1] !~m{ \A \s* \z}xms;
            return;
        },
        
        End => sub {        
            $_element = $_[1];
            ($_prefix, $_localname) = split m{:}xms , $_element;          
            $_localname ||= $_element;          # for non-prefixed elements            

            # This one easily handles ignores for us, too...
            # return if not ref $$list[-1];
    
            if (length $characters) {
                if (ref $list->[-1]->{ $_element } eq 'ARRAY') {
                    $list->[-1]->{ $_element }->[-1] = $characters ;
                }
                else {
                    $list->[-1]->{ $_element } = $characters;
                }
            }
            $characters = q{};
            $current = pop @$list;           # step up in object hierarchy...
            return;
        }
    );
    return $parser;
}

sub parse {
    eval { 
        $_[0]->_initialize( XML::Parser::Expat->new( Namespaces => 1 ) )->parse( $_[1] );
        $_[0]->{ parser }->release();
    };
    die $@ if $@;
    return $_[0]->{ data };     
}

sub parsefile {
    eval { 
        $_[0]->_initialize( XML::Parser::Expat->new( Namespaces => 1 ) )->parsefile( $_[1] );
        $_[0]->{ parser }->release(); 
    };
    die $@, $_[1] if $@;
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

SOAP::WSDL::Expat::MessageParser - Convert SOAP messages to custom object trees

=head1 SYNOPSIS

 my $parser = SOAP::WSDL::Expat::MessageParser->new({
    class_resolver => 'My::Resolver'   
 });
 $parser->parse( $xml );
 my $obj = $parser->get_data();

=head1 DESCRIPTION

Real fast expat based SOAP message parser.

See L<SOAP::WSDL::Parser> for details.

=head2 Skipping unwanted items

Sometimes there's unneccessary information transported in SOAP messages.

To skip XML nodes (including all child nodes), just edit the type map for 
the message and set the type map entry to '__SKIP__'. 

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

 $LastChangedDate: 2007-09-10 18:19:23 +0200 (Mo, 10 Sep 2007) $
 $LastChangedRevision: 218 $
 $LastChangedBy: kutterma $

 $HeadURL: https://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL/Expat/MessageParser.pm $

