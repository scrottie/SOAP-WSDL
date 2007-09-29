#!/usr/bin/perl
package SOAP::WSDL::Expat::MessageParser;
use strict;
use warnings;
use SOAP::WSDL::XSD::Typelib::Builtin;
use XML::Parser::Expat;

sub new {
    my ($class, $args) = @_;
    my $self = {
        class_resolver => $args->{ class_resolver },
        strict => exists $args->{ strict } ? $args->{ strict } : 1,   
    };
    bless $self, $class;
    return $self;
}

sub class_resolver {
    my $self = shift;
    $self->{ class_resolver } = shift;
    return;
}

sub _initialize {
    my ($self, $parser) = @_;
    $self->{ parser } = $parser;

    delete $self->{ data };                     # remove potential old results
    
    my $characters;
    #my @characters_from = ();
    my $current = undef;
    my $list = [];                      # node list
    my $path = [];                      # current path 
    my $skip = 0;                       # skip elements
    my $current_part = q{};             # are we in header or body ?

    my $depth = 0;

    my %content_check = $self->{strict} 
        ? (
            0 => sub {
                    die "Bad top node $_[1]" if $_[1] ne 'Envelope';
                    die "Bad namespace for SOAP envelope: " . $_[0]->recognized_string()
                        if $_[0]->namespace($_[1]) ne 'http://schemas.xmlsoap.org/soap/envelope/';
                    $depth++;
                    return;            
            },
            1 => sub {
                    $depth++;
                    return;            
            }
        ) 
        : ();

    my $char_handler = sub {
            # push @characters_from, $_[1] if $_[1] =~m{ [^s] }xms;
            $characters .= $_[1] if $_[1] =~m{ [^\s] }xms;
             
            return;
    };

    # use "globals" for speed
    my ($_prefix, $_method, 
        $_class) = ();

    no strict qw(refs);     
    $parser->setHandlers(
        Start => sub {          
            # my ($parser, $element, %_attrs) = @_;
            # $depth = $parser->depth();

            # call methods without using their parameter stack
            # That's slightly faster than $content_check{ $depth }->()
            # and we don't have to pass $_[1] to the method.
            # Yup, that's dirty. 
            return &{$content_check{ $depth }} if exists $content_check{ $depth }; 

            push @{ $path }, $_[1];       # step down in path
            return if $skip;               # skip inside __SKIP__
            
            # resolve class of this element
            $_class = $self->{ class_resolver }->get_class( $path )
                or die "Cannot resolve class for "
                    . join('/', @{ $path }) . " via " . $self->{ class_resolver };

            if ($_class eq '__SKIP__') {
                $skip = join('/', @{ $path });
                $self->setHandlers( Char => undef );
                return;
            } 
             
            push @$list, $current;   # step down in tree ()remember current)
                
            $characters = q();      # empty characters
            #@characters_from = ();
   
            # Check whether we have a builtin - we implement them as classes
            # We could replace this with UNIVERSAL->isa() - but it's slow...
            # match is a bit faster if the string does not match, but WAY slower 
            # if $class matches...              
            if (index $_class, 'SOAP::WSDL::XSD::Typelib::Builtin', 0 < 0) {           
                # check wheter there is a non-empty ARRAY reference for $_class::ISA
                # or a "new" method
                # If not, require it - all classes required here MUST
                # define new()
                # This is not exactly the same as $class->can('new'), but it's way faster  
                defined *{ "$_class\::new" }{ CODE }
                  or scalar @{ *{ "$_class\::ISA" }{ ARRAY } }
                    or eval "require $_class"   ## no critic qw(ProhibitStringyEval)
                      or die $@;                        
            }
            
            $current = $_class->new({ @_[2..$#_] });   # set new current object
        
            # remember top level element
            exists $self->{ data } 
                or ($self->{ data } = $current); 
            $depth++;
            return;
        },
        
        Char => $char_handler,
        
        End => sub {
        
            pop @{ $path };                     # step up in path
       
            if ($skip) {
                return if $skip ne join '/', @{ $path }, $_[1];
                $skip = 0;
                $_[0]->setHandler( Char => $char_handler );
                return;
            }

            $depth--;
      
            # This one easily handles ignores for us, too...
            return if not ref $list->[-1];
    
            # set characters in current if we are a simple type
            # we may have characters in complexTypes with simpleContent,
            # too - maybe we should rely on the presence of characters ?
            # may get a speedup by defining a ident method in anySimpleType 
            # and looking it up via exists &$class::ident;
#            if ( $current->isa('SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType') ) {
#                $current->set_value( $characters );
#            }
            # currently doesn't work, as anyType does not implement value - 
            # maybe change ?
            $current->set_value( $characters ) if (length $characters);
            #$current->set_value( join @characters_from ) if (@characters_from);
            $characters = q{};
#            undef @characters_from;
            # set appropriate attribute in last element
            # multiple values must be implemented in base class
            #$_method = "add_$_localname";
            $_method = "add_$_[1]";
            $list->[-1]->$_method( $current );
            
            $current = pop @$list;           # step up in object hierarchy...
            return;
        }
    );
    return $parser;
}

sub parse {
    eval { 
        $_[0]->_initialize( 
            XML::Parser::Expat->new(
                Namespaces => 1
                )
            )->parse( $_[1] );
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

 $LastChangedDate: 2007-09-27 21:06:29 +0200 (Don, 27 Sep 2007) $
 $LastChangedRevision: 283 $
 $LastChangedBy: kutterma $

 $HeadURL: http://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL/Expat/MessageParser.pm $

