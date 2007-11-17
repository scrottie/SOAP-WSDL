#!/usr/bin/perl
package SOAP::WSDL::Expat::MessageParser;
use strict;
use warnings;
use SOAP::WSDL::XSD::Typelib::Builtin;
use base qw(SOAP::WSDL::Expat::Base);

our $VERSION = '2.00_24';

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
    $self->{ class_resolver } = shift if @_;
    return $self->{ class_resolver };
}

sub _initialize {
    my ($self, $parser) = @_;
    $self->{ parser } = $parser;

    delete $self->{ data };                     # remove potential old results
    delete $self->{ header };

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
                    if ($_[1] eq 'Body') {
                        if (exists $self->{ data }) { # there was header data
                            $self->{ header } = $self->{ data };
                            delete $self->{ data };
                            $list = [];
                            $path = [];
                            undef $current;
                        }
                    }
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
                $_[0]->setHandlers( Char => undef );
                return;
            }

            push @$list, $current;   # step down in tree (remember current)

            $characters = q();      # empty characters

            # Check whether we have a builtin - we implement them as classes
            # We could replace this with UNIVERSAL->isa() - but it's slow...
            # match is a bit faster if the string does not match, but WAY slower
            # if $class matches. We hope to match often...
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
                $_[0]->setHandlers( Char => $char_handler );
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

sub get_header {
    return $_[0]->{ header };
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

See L<SOAP::WSDL::Manual::Parser> for details.

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

=head1 LICENSE AND COPYRIGHT

Copyright 2004-2007 Martin Kutter.

This file is part of SOAP-WSDL. You may distribute/modify it under
the same terms as perl itself.

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=head1 REPOSITORY INFORMATION

 $Rev: 391 $
 $LastChangedBy: kutterma $
 $Id: MessageParser.pm 391 2007-11-17 21:56:13Z kutterma $
 $HeadURL: http://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL/Expat/MessageParser.pm $

=cut