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
    };
    bless $self, $class;
    return $self;
}

sub class_resolver {
    my $self = shift;
    $self->{ class_resolver } = shift;
}

sub _initialize {
    my ($self, $parser) = @_;
    $self->{ parser } = $parser;

    delete $self->{ data };
    
    my $characters = q{};
    my $current = undef;
    my $list = [];                      # node list
    my $path = [];                      # current path 
    my $current_part = q{};             # are we in header or body ?
    my $depth = 0;

    # use "globals" for speed
    my ($_prefix, $_method, 
        $_class) = ();

    my @check_sub_from = (
    );

    no strict qw(refs);     
    $parser->setHandlers(
        Start => sub {
            # my ($parser, $element, %_attrs) = @_;
            #return if $skip;               # skip inside __SKIP__
            return if exists $self->{ skip };

            $_[1] =~s{ \w+: }{}xms;

            if ($depth <=1) {
                if ($depth == 0) {
                    die "Bad top node $_[1]" if $_[1] ne 'Envelope';
#                    die "Bad namespace for SOAP envelope: " . $_[0]->recognized_string()
#                        if $_[0]->namespace($_[1]) ne 'http://schemas.xmlsoap.org/soap/envelope/';
                    $depth++;
                    return;           
                }
                else {
                    die "Bad node $_[1]. Expected (Header|Body)" if $_[1] !~ m{(:?Header|Body)}xms;
                    $depth++;
                    return;           
                }
            }
            
            push @{ $path }, $_[1];       # step down in path

            # resolve class of this element
            $_class = $self->{ class_resolver }->get_class( $path )
                or do {
                    die "Cannot resolve class for "
                    . join('/', @{ $path }) . " via " . $self->{ class_resolver };
                };

            return $self->{skip} = join('/', @{ $path }) if ($_class eq '__SKIP__');
             
            push @$list, $current;   # step down in tree ()remember current)
                
            # $characters = q();      # empty characters
   
            # Check whether we have a primitive - we implement them as classes
            # We could replace this with UNIVERSAL->isa() - but it's slow...
            # match is a bit faster if the string does not match, but WAY slower 
            # if $class matches...
                    
            if (index $_class, 'SOAP::WSDL::XSD::Typelib::Builtin', 0 < 0) {           
                # check wheter there is a non-empty ARRAY reference for $_class::ISA
                # or a "new" method
                # If not, require it - all classes required here MUST
                # define new() or inherit from something defining it.
                # This is not exactly the same as $class->can('new'), but it's way faster  
                defined *{ "$_class\::new" }{ CODE }
                  or scalar @{ *{ "$_class\::ISA" }{ ARRAY } }
                    or eval "require $_class"   ## no critic qw(ProhibitStringyEval)
                      or die $@;                        
            }

            # create new object and pass it all attributes - remember, we're 
            # called with
            # ($parser, $element, %attrs) = @_, so we can just give it 
            # everything from @_[2..$#_]... 
            $current = $_class->new({ @_[2..$#_] });   # set new current object
        
            # remember top level element
            defined $self->{ data } 
                or $self->{ data } =  $current; 

            $depth++;   # step down (once again)
        },
        
        Char => sub {
            return if exists $self->{skip};
            return if $_[1] =~ m{ \A \s* \z}xs;
            $characters .= $_[1];
        },
        
        End => sub {       
            pop @{ $path };                     # step up in path
       
            if (exists $self->{skip}) {
                return if $self->{skip} ne join '/', @{ $path }, $_[1];
                delete $self->{skip};
                return;
            }
      
            # This one easily handles ignores for us, too...
            return if not ref $list->[-1];
    
            # set characters in current if we are a simple type
            # we may have characters in complexTypes with simpleContent,
            # too - maybe we should rely on the presence of characters ?
            # may get a speedup by defining a ident method in anySimpleType 
            # and looking it up via exists &$class::ident;

            $current->set_value( $characters ) if (length $characters);
            $characters = q{};

            # set appropriate attribute in last element
            # multiple values must be implemented in base class
            #$_method = "add_$_localname";
            $_method = "add_$_[1]";
            $list->[-1]->$_method( $current );
            
            $current = pop @$list;           # step up in object hierarchy...
            $depth--;
            # print $self->{ data };
        }
    );
    return $parser;
}

sub parse {
    eval { 
        $_[0]->_initialize( XML::Parser::Expat->new() )->parse( $_[1] );
        $_[0]->{ parser }->release();
    };
    die $@ if $@;
    return $_[0]->{ data };     
}

sub parsefile {
    eval { 
        $_[0]->_initialize( XML::Parser::Expat->new() )->parsefile( $_[1] ); 
        $_[0]->{ parser }->release();
    };
    die $@, $_[1] if $@;
    return die $_[0]->{ data };     
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

 $LastChangedDate: 2007-09-19 13:05:07 +0200 (Mi, 19 Sep 2007) $
 $LastChangedRevision: 261 $
 $LastChangedBy: kutterma $

 $HeadURL: https://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL/Expat/MessageParser.pm $

