#!/usr/bin/perl
package SOAP::WSDL::XSD::Typelib::Element;
use strict;

my %NAME;
my %NILLABLE;
my %REF;
my %MIN_OCCURS;
my %MAX_OCCURS;

# Class data - remember, we're the base class for a class factory or for
# generated code...
# use BLOCK: for scoping
BLOCK: {
    my %method_lookup = (
        _name => \%NAME,
        _nillable => \%NILLABLE,
        _ref => \%REF,
        _minOccurs => \%MIN_OCCURS,
        _maxOccurs => \%MAX_OCCURS,
    );

    no strict qw(refs);
    while (my ($name, $value) = each %method_lookup ) {
        *{ "__set$name" } = sub {
            my $class = ref $_[0] || $_[0];
            $value->{ $class } = $_[1];
        };
        *{ "__get$name" } = sub {
            my $class = ref $_[0] || $_[0];
            return $value->{ $class };
        };
    }
};

sub start_tag {
    my ($self, $opt, $value) = @_;
    my $class = ref $self;
    my $ending = '>';
    my @attr_from = ();
    my $name = $opt->{ name } || $NAME{$class};
    $ending = '/>' if ($opt->{ empty });
    
    if ($opt->{qualified}) {
        push @attr_from, 'xmlns="' . $self->get_xmlns . '"';
    }
    if ($opt->{ nil }) {
        return q{} if not $NILLABLE{ $class };
        push @attr_from, 'xsi:nil="true"';
        $ending = '/>';
    }
    return join q{ }, "<$name" , @attr_from , $ending;
}

sub end_tag {
    my ($class, $opt) = (ref $_[0], $_[1]);
    my $name = $opt->{ name } || $NAME{$class};
    return "</$name>";
}

1;

=pod

=head1 NAME

SOAP::WSDL::XSD::Typelib::Element - element base clase

=head1 SYNOPSIS

This example creates a class for this XML schema definition:

 <element name="MyElement" type="xsd:string" nillable="1"
   minOccurs="1" maxOccurs="1"/>

 package MyElement;
 use strict;
 use Class::Std::Storable;
 use base (
    'SOAP::WSDL::XSD::Typelib::Element',
    'SOAP::WSDL::XSD::Typelib::Builtin::string',
 );

 __PACKAGE__->__set_name('MyElementName');
 __PACKAGE__->__set_nillable(1);
 __PACKAGE__->__set_minOccurs(1);
 __PACKAGE__->__set_maxOccurs(1);
 __PACKAGE__->__set_ref(0);

Now we create this XML schema definition type class:

 <element name="MyElement2" ref="tns:MyElement"/>
 
 package MyElement2;
 use strict;
 use Class::Std::Storable;
 use base (
    'SOAP::WSDL::XSD::Typelib::Element',
    'MyElement'
 );

 __PACKAGE__->__set_name('MyElementName');
 __PACKAGE__->__set_nillable(0);
 __PACKAGE__->__set_ref(1);
 
=head1 NOTES

=over 

=item * type="Foo"

Implemented via inheritance.

=item * ref="Foo"

Implemented via inheritance, too. Calling 

__PACKAGE__->__set_ref(1) is highly encouraged, though it has no 
effect yet - it will probably be needed for serialization to XML 
Schema definitions some day.

=back
 
=head1 BUGS AND LIMITATIONS

=over

=item * minOccurs maxOccurs not implemented

These attributes are not yet supported, though they may be set as class
properties via __PACKAGE__->__set_FOO methods.

=item * 'http://www.w3.org/2001/XMLSchema-instance prefix is hardcoded

The prefix for 'http://www.w3.org/2001/XMLSchema-instance (used as namespace
for the {http://www.w3.org/2001/XMLSchema-instance}nil="true" attribute
is hardcoded as 'xsi'.

You should definitly provide your XML envelope generator with the same prefix
namespace combination (Default for SOAP::WSDL::Envelope).

=back

=cut
