#!/usr/bin/perl
package SOAP::WSDL::XSD::Typelib::ComplexType;
use strict;
use Carp;
use SOAP::WSDL::XSD::Typelib::Builtin;
use Scalar::Util qw(blessed);
use Class::Std::Storable;

use Data::Dumper;

use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anyType);

my %ELEMENTS_FROM;
my %ATTRIBUTES_OF;
my %CLASSES_OF;

# we store per-class elements.
# call as __PACKAGE__->_factory
sub _factory {
    my $class = shift;
    $ELEMENTS_FROM{ $class } = shift;
    $ATTRIBUTES_OF{ $class } = shift;
    $CLASSES_OF{ $class } = shift;

    no strict qw(refs);
    while (my ($name, $attribute_ref) = each %{ $ATTRIBUTES_OF{ $class } } )
    {
        my $type = $CLASSES_OF{ $class }->{ $name }
            or die "No class given for $name";
        eval "require $type" if not eval { $type->isa('UNIVERSAL') };
        croak $@ if $@;

        *{ "$class\::set_$name" } = sub  {
            my ($self, $value) = @_;
            # set to a) value if it's an object
            # b) New object with value for simple vlues
            # c) New object with value for list values and list type
            # d) List ref of new objects with value for list values and non-list type
            $attribute_ref->{ ident $self } = (blessed $value)
                ? $value
                : (ref $value && ref $value eq 'ARRAY')
                    ?  $type->isa('SOAP::WSDL::XSD::Typelib::Builtin::list')
                        ? $type->new({ value => $value })
                        : [ map { $type->new({ value => $_ }) } @{ $value } ]
                    : $type->new({ value => $value });
        };

        *{ "$class\::add_$name" } = sub {
            my ($self, $value) = @_;
            my $ident = ident $self;
            if (not defined $value) {
                warn "attempting to add empty value to " . ref $self;
            }
            
            return $attribute_ref->{ $ident } = $value
                if not defined $attribute_ref->{ $ident };

            # listify previous value if it's no list
            $attribute_ref->{ $ident } = [  $attribute_ref->{ $ident } ]
                if not ref $attribute_ref->{ $ident } eq 'ARRAY';

            # add to list
            return push @{ $attribute_ref->{ $ident } }, $value;                                          
        };
    }

    # we need our own destructor - on the fly generated classes
    # don't necessarily go through Clas::Std::Storable's DEMOLISH
    # calls.
#    my $destructor_ref = *{ "$class\::DESTROY" };
#    no warnings qw(redefine);
#    *{ "$class\::DESTROY" } = sub {
#        my $self = shift;
#        my $class = shift;
#        for (@{ $ELEMENTS_FROM{ $class } }) {
#            delete $_->{ ident $self };
#        }
        # call original destructor.
#        $destructor_ref->( $self, @_) if ref ($destructor_ref);
#    };
#
}

sub START {
    my ($self, $ident, $args_of) = @_;
    my $class = ref $self;
    for my $name (keys %{ $ATTRIBUTES_OF{ $class } } ) {
        my $method = "set_$name";
        $self->$method( $args_of->{ $name } )
            if $args_of->{ $name };
    }
}

sub _get_elements  {
    my $self = shift;
    my $class = ref $self;
    my $ident = ident $self;
    return map { $_->{ $ident } } @{ $ELEMENTS_FROM{ $class } };
}

# this serialize method works fine for <all> and <sequence>
# complextypes, as well as for <restriction><all> or
# <restriction><sequence>.
# But what about choice, group, extension ?
#
sub _serialize  {
    my $self = shift;
    my $ident = ident $self;
    my $class = ref $self;

    # return concatenated return value of serialize call of all
    # elements retrieved from get_elements expanding list refs.
    # get_elements is inlined for performance.
    return join q{} , map {     
        my $element = $ATTRIBUTES_OF{ $class }->{ $_ }->{$ident };
        $element = [ $element ]
            if not ref $element eq 'ARRAY';
        my $name = $_;
            
        map {
            # skip empty elements - complexTypes may have empty elements 
            # (minOccurs 0).
            if (not $_) {
                q{}
            }
            # serialize element elements with their own serializer
            # but name them like they're named here.
            elsif ( $_->isa( 'SOAP::WSDL::XSD::Typelib::Element' ) ) {
                    $_->serialize( { name => $_ } );
            }
            # serialize complextype elments (of other types) with their 
            # serializer, but add element tags around.
            else {
                join q{}, $_->start_tag({ name => $name })
                    , $_->serialize()
                    , $_->end_tag({ name => $name });       
            }
        } @{ $element }        
    } (@{ $ELEMENTS_FROM{ $class } });
}

sub serialize {
    my ($self, $opt) = @_;
    my $class = ref $self;
    $opt ||= {};
    # do we have a empty element ? 
    return $self->start_tag({ %$opt, empty => 1 })
        if not @{ $ELEMENTS_FROM{ $class } };
    return join q{}, $self->start_tag($opt),
            $self->_serialize(), $self->end_tag();
}

1;

=pod

=head1 Bugs and limitations

=over

=item * Thread safety

SOAP::WSDL::XSD::Typelib::Builtin uses Class::Std::Storable which uses
Class::Std. Class::Std is not thread safe, so
SOAP::WSDL::XSD::Typelib::Builtin is neither.

=item * XML Schema facets

No facets are implemented yet.

=back

=head1 AUTHOR

Replace whitespace by @ in e-mail address.

 Martin Kutter E<gt>martin.kutter fen-net.deE<lt>

=head1 COPYING

This library is free software, you may distribute/modify it under the
same terms as perl itself

=cut
