#!/usr/bin/perl
package SOAP::WSDL::XSD::Typelib::ComplexType;
use strict;
use warnings;
use Carp;
use SOAP::WSDL::XSD::Typelib::Builtin;
use Scalar::Util qw(blessed refaddr);
use Class::Std::Storable;

use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anyType);

our $VERSION = '2.00_16';

my %ELEMENTS_FROM;
my %ATTRIBUTES_OF;
my %CLASSES_OF;

# STORABLE_ methods for supporting Class::Std::Storable.
# We could also handle them via AUTOMETHOD,
# but AUTOMETHOD should always croak...
# Do we really need this ?
# ... looks like we do...
sub STORABLE_freeze_pre {}
sub STORABLE_freeze_post {}
sub STORABLE_thaw_pre {}
sub STORABLE_thaw_post {}

# for error reporting. Eases working with data objects...
sub AUTOMETHOD {
    my ($self, $ident, @args_from) = @_;
    
    my $class = ref $self || $self;
    confess "Can't locate object method \"$_\" via package \"$class\". \n"
        . "Valid methods are: " 
        . join(', ', map { ("get_$_" , "set_$_") } keys %{ $ATTRIBUTES_OF{ $class } })
        . "\n"
}

# we store per-class elements.
# call as __PACKAGE__->_factory
sub _factory {
    my $class = shift;
    $ELEMENTS_FROM{ $class } = shift;
    $ATTRIBUTES_OF{ $class } = shift;
    $CLASSES_OF{ $class } = shift;

    no strict qw(refs);
    no warnings qw(redefine); 
    while (my ($name, $attribute_ref) = each %{ $ATTRIBUTES_OF{ $class } } ) {
        my $type = $CLASSES_OF{ $class }->{ $name }
            or croak "No class given for $name";

        # require all types here
        $type->isa('UNIVERSAL')
            or eval "require $type" 
                or croak $@;

        # check now, so we don't need to do it later.
        # $is_list is used in the methods created. Filling it now means 
        # we don't have to check it every time the method is called, but 
        # can just use $is_list, which will hold the value assigned to 
        # it when the method was created.
        my $is_list = $type->isa('SOAP::WSDL::XSD::Typelib::Builtin::list');
        
        #  The set_$name method below looks rather weird, 
        # but is optimized for performance.
        #
        #  We could use sub calls for sure, but these are much slower. And 
        # the logic is not that easy:
        #
        #  we accept:
        #  a) objects
        #  b) scalars            
        #  c) list refs
        #  d) hash refs
        #  e) mixed stuff of all of the above, so we have to set our child to 
        #    a) value if it's an object
        #    b) New object of expected class with value for simple values
        #    c 1) New object with value for list values and list type
        #    c 2) List ref of new objects with value for list values and 
        #         non-list type
        #    c + e 1) List ref of objects for list values (list of objects) 
        #             and non-list type
        #    c + e 2) List ref of new objects for list values (list of hashes) 
        #             and non-list type where the hash ref is passed to new as 
        #             argument        
        #    d) New object with values passed to new for HASH references
        #
        #  We throw an error on
        #  a) list refs of list refs - don't know what to do with this (maybe 
        #     use for lists of list types ?)
        #  b) wrong object types
        #  c) non-blessed non-ARRAY/HASH references - if you can define semantics 
        #     for GLOB or SCALAR references, feel free to add them.
        #  d) we should also die for non-blessed non-ARRAY/HASH references in 
        #     lists but don't do yet - oh my ! 
        
        *{ "$class\::set_$name" } = sub  {
            my $is_ref = ref $_[1];
            $attribute_ref->{ ident $_[0] } = ($is_ref) 
                ? $is_ref eq 'ARRAY' 
                    ? $is_list                             # remembered from outside closure 
                        ? $type->new({ value => $_[1] })   # list element - can take list ref as value
                        : [ map {                          
                            ref $_ 
                              ? ref $_ eq 'HASH'
                                  ? $type->new($_)
                                  : ref $_ eq $type
                                      ? $_
                                      : croak "cannot use " . ref($_) . " reference as value for $name - $type required"
                              : $type->new({ value => $_ })
                            } @{ $_[1] } 
                         ]
                    : $is_ref eq 'HASH' 
                        ?  $type->new( $_[1] )
                        :  $is_ref eq $type
                            ? $_[1]
                            : die croak "cannot use $is_ref reference as value for $name - $type required"
                : $type->new({ value => $_[1] });                     
        };

        *{ "$class\::add_$name" } = sub {
            my $ident = ident $_[0];
            warn "attempting to add empty value to " . ref $_[0] 
                if not defined $_[1];
            
            # first call
            return $attribute_ref->{ $ident } = $_[1]
                if not defined $attribute_ref->{ $ident };

            # second call: listify previous value if it's no list
            $attribute_ref->{ $ident } = [  $attribute_ref->{ $ident } ]
                if not ref $attribute_ref->{ $ident } eq 'ARRAY';

            # second and following: add to list
            return push @{ $attribute_ref->{ $ident } }, $_[1];                                          
        };
        
        *{ "$class\::$name" } = *{ "$class\::add_$name" };
    }

    # TODO Could be moved as normal method into base class, e.g. here.
    # Hmm. let's see...
    *{ "$class\::new" } = sub {
        my $self = bless \my ($o), $_[0];
        # We're working on @_ for speed.
        # Normally, the first line would look like this:
        # my ($self, $ident, $args_of) = @_;
        #
        # The hanging side comment show you what would be there, then.
        
        # iterate over keys of arguments 
        # and call set appropriate field in clase
        map { ($ATTRIBUTES_OF{ $class }->{ $_ }) 
            ? do {
                 my $method = "set_$_";
                 $self->$method( $_[1]->{ $_ } );               # ( $args_of->{ $_ } );
           }
           : $_ =~ m{ \A              # beginning of string
                      xmlns           # xmlns 
                }xms  
                ? do {}
                : do { use Data::Dumper; 
                     croak "unknown field $_ in $class. Valid fields are:\n" 
                     . join(', ', @{ $ELEMENTS_FROM{ $class } }) . "\n"
                     . "Structure given:\n" . Dumper @_ };
        } keys %{ $_[1] };                                      # %$args_of;
        return $self;
    };


    # this serialize method works fine for <all> and <sequence>
    # complextypes, as well as for <restriction><all> or
    # <restriction><sequence>.
    # But what about choice, extension ?
    *{ "$class\::_serialize" } = sub {
        my $ident = ident $_[0];
        # my $class = ref $_[0];
        # return concatenated return value of serialize call of all
        # elements retrieved from get_elements expanding list refs.
        # get_elements is inlined for performance.
        return join q{} , map {     
            my $element = $ATTRIBUTES_OF{ $class }->{ $_ }->{ $ident };

            # do we have some content
            if (defined $element) {
                $element = [ $element ]
                    if not ref $element eq 'ARRAY';
                my $name = $_;
            
                map {
                    # serialize element elements with their own serializer
                    # but name them like they're named here.
                    if ( $_->isa( 'SOAP::WSDL::XSD::Typelib::Element' ) ) {
                            $_->serialize( { name => $name } );
                    }
                    # serialize complextype elments (of other types) with their 
                    # serializer, but add element tags around.
                    else {
                        join q{}, $_->start_tag({ name => $name })
                            , $_->serialize()
                            , $_->end_tag({ name => $name });       
                    }
                } @{ $element }
            }
            else {
                 q{};
            }        
        } (@{ $ELEMENTS_FROM{ $class } });
    };

    *{ "$class\::serialize" } = sub {
            my ($self, $opt) = @_;
            $opt ||= {};
        
            # do we have a empty element ? 
            return $self->start_tag({ %$opt, empty => 1 })
                if not defined $ELEMENTS_FROM{ $class } or not @{ $ELEMENTS_FROM{ $class } };
            return join q{}, $self->start_tag($opt),
                    $self->_serialize(), $self->end_tag();
    }
    
}

1;

__END__

=pod

=head1 NAME

SOAP::WSDL::XSD::Typelib::ComplexType - Base class for complexType node classes

=head1 Subclassing

To subclass, write a package like this:

 package MyComplexType;
 use Class::Std::Storable
 use base qw(SOAP::WSDL::XSD::Typelib::ComplexType);
 
 # we only need the :get attribute qualifier.
 # set and init_arg are automatically created by 
 # SOAP::WSDL::XSD::Typelib::ComplexType
 my %first_attr_of   :ATTR(:get<first_attr>  :default<()>);
 my %second_attr_of  :ATTR(:get<second_attr> :default<()>);
 my %third_attr_of   :ATTR(:get<third_attr>  :default<()>);
 
 # the order of elements in a complexType
 my @elements_from = qw(first_attr second_attr third_attr);
 
 # references to the private hashes
 my %attribute_of = (
    first_attr  => \%first_attr_of,
    second_attr => \%second_attr_of,
    third_attr  => \%third_attr_of,
 );
 
 # classes_of: Classes the child elements should be of
 my %classes_of = (
    first_attr  => 'My::FirstElement',
    second_attr => 'My::SecondElement',
    third_attr  => 'My::ThirdElement',
 );
 
 # call _factory 
 __PACKAGE__->_factory(
    \@elements_from,
    \%attributes_of,
    \%classes_of 
 );

 1;

When subclassing, the following methods are created in the subclass:

=head2 new

Constructor. For your convenience, new will accept data for the object's 
properties in the following forms:

 hash refs
 1) of scalars
 2) of list refs
 3) of hash refs
 4) of objects
 5) mixed stuff of all of the above 

new() will set the data via the set_FOO methods to the object's element 
properties. 

Data passed to new must comply to the object's structure or new() will 
complain. Objects passed must be of the expected type, or new() will 
complain, too.

Examples:

 my $obj = MyClass->new({ MyName => $value });  
 
 my $obj = MyClass->new({
     MyName => { 
         DeepName => $value 
     },
     MySecondName => $value,
 });
 
 my $obj = MyClass->new({
     MyName => [
        { DeepName => $value },
        { DeepName => $other_value },
     ],
     MySecondName => $object,
     MyThirdName => [ $object1, $object2 ],
 });

The new() method from Class::Std will be overridden, so you should not rely 
on it's behaviour. 

Your START and BUILD methods are called, but the class' inheritance tree is 
not traversed.

=head2 set_FOO

A mutator method for every element property. 

For your convenience, the set_FOO methods will accept all kind of data you 
can think of (and all combinations of them) as input - with the exception 
of GLOBS and filehandles.

This means you may set element properties by passing 

 a) objects
 b) scalars            
 c) list refs
 d) hash refs
 e) mixed stuff of all of the above 

Examples are similar to the examples provided for new() above.

=head1 Bugs and limitations

=over

=item * Incomplete API

Not all variants of XML Schema ComplexType definitions are supported yet.

Variants known to work are:

 sequence
 all
 complexContent containing sequence/all definitions
 
=item * Thread safety

SOAP::WSDL::XSD::Typelib::Builtin uses Class::Std::Storable which uses
Class::Std. Class::Std is not thread safe, so
SOAP::WSDL::XSD::Typelib::Builtin is neither.

=item * XML Schema facets

No facets are implemented yet.

=back

=head1 LICENSE

Copyright 2004-2007 Martin Kutter.

This file is part of SOAP-WSDL. You may distribute/modify it under 
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=head1 REPOSITORY INFORMATION

 $Rev: 323 $
 $LastChangedBy: kutterma $
 $Id: ComplexType.pm 323 2007-10-17 15:23:05Z kutterma $
 $HeadURL: https://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL/XSD/Typelib/ComplexType.pm $
 
=cut

