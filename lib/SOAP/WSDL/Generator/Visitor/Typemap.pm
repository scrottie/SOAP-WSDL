package SOAP::WSDL::Generator::Visitor::Typemap;
use strict;
use warnings;
use Class::Std::Fast::Storable;

use base qw(SOAP::WSDL::Generator::Visitor);

use version; our $VERSION = qv('2.00.01');

my %path_of             :ATTR(:name<path>           :default<[]>);
my %typemap_of          :ATTR(:name<typemap>        :default<()>);
my %resolver_of         :ATTR(:name<resolver>       :default<()>);

sub START {
    my ($self, $ident, $arg_ref) = @_;
    $resolver_of { $ident } = $arg_ref->{ resolver };
}

sub set_typemap_entry {
    my ($self, $value) = @_;
    # warn join( q{/}, @{ $path_of{ ident $self } }) . " => $value";
    $typemap_of{ ident $self }->{
        join( q{/}, @{ $path_of{ ident $self } } )
    } = $value;
}

sub add_element_path {
    my ($self, $element) = @_;

    # Swapping out this lines against the ones below generates
    # a namespace-sensitive typemap.
    # Well almost: Class names are not constructed in a namespace-sensitive
    # manner, yet - there should be some facility to allow binding a (perl)
    # prefix to a namespace...
    push @{ $path_of{ ident $self } }, $element->get_name();

    #    push @{ $path_of{ ident $self } },
    #        "{". $element->get_targetNamespace . "}"
    #        . $element->get_name();
}

sub process_referenced_type {
    my ( $self, $ns, $localname ) = @_;

    my $ident = ident $self;

    # get type's class name
    # Caveat: visits type if it's a referenced type from the
    # a ? b : c operation.
    my ($type, $typeclass);
    $type = $self->get_definitions()->first_types()->find_type( $ns, $localname );
    $typeclass = $self->get_resolver()->create_xsd_name($type);

    # set before to allow it to be used from inside _accept
    $self->set_typemap_entry($typeclass);

    $type->_accept($self) if ($ns ne 'http://www.w3.org/2001/XMLSchema');

    # set afterwards again (just to be sure...)
    $self->set_typemap_entry($typeclass);
    return $self;
}

sub process_atomic_type {
    my ( $self, $type, $callback ) = @_;
    return if not $type;

    $callback->( $self, $type );
    return $self;
}

sub visit_XSD_Element {
    my ( $self, $ident, $element ) = ( $_[0], ident $_[0], $_[1] );

    # warn "simpleType " . $element->get_name();
    my @path = @{ $path_of{ ${ $self } } };
    my $path = join '/', @path;
    my $parent = $typemap_of{ ${ $self } }->{ $path };

    # step down in tree
    $self->add_element_path( $element );

    # now call all possible variants.
    # They all just return if no argument is given,
    # and return $self on success.
    SWITCH: {
        if ($element->get_type) {
            $self->process_referenced_type( $element->expand( $element->get_type() ) )
                && last;
        }

        # atomic simpleType typemap rule:
        # if we have a parent, use parent's sub-package.
        # if not, use element package.
        if ($element->get_simpleType()) {
            # warn "simpleType " . $element->get_name();
            my @path = @{ $path_of{ ${ $self } } };
            my $typeclass = $self->get_resolver()->create_subpackage_name($element);
            $self->set_typemap_entry($typeclass);
            $typeclass =~s{\.}{::}g;
            $typeclass =~s{\-}{_}g;
            last SWITCH;
        }

        # for atomic and complex types , and ref elements
        my $typeclass = $self->get_resolver()->create_subpackage_name($element);
        $self->set_typemap_entry($typeclass);

        $self->process_atomic_type( $element->first_complexType()
            , sub { $_[1]->_accept($_[0]) } )
            && last SWITCH;

        # TODO: add element ref handling
    };

    # Safety measure. If someone defines a top-level element with
    # a normal (not atomic) type, we just override it here
    if (not defined($parent)) {
        # for atomic and complex types , and ref elements
        my $typeclass = $self->get_resolver()->create_xsd_name($element);
        $self->set_typemap_entry($typeclass);
    }

    # step up in hierarchy
    pop @{ $path_of{$ident} };
}

sub visit_XSD_ComplexType {
    my ($self, $ident, $type) = ($_[0], ident $_[0], $_[1] );
    my $variety = $type->get_variety();
    my $content_model = $type->get_contentModel;
    return if not $variety; # empty complexType
    return if ($content_model eq 'simpleContent');

    if ( grep { $_ eq $variety} qw(all sequence choice) )
    {
        # visit child elements
        for (@{ $type->get_element() || [] }) {
            $_->_accept( $self );
        }
        return;
    }

    if (grep { $_ eq $variety } qw(restriction extension) ) {
        # resolve base / get atomic type and run on elements
        if (my $type_name = $type->get_base()) {
            my $subtype = $self->get_definitions()
                ->first_types()->find_type( $type->expand($type_name) );
            # visit child elements
            for (@{ $subtype->get_element() || [] }) {
                $_->_accept( $self );
            }
            # that's all for restriction
            return if ($variety eq 'restriction');
        }
    }

    warn "unsupported content model $variety found in "
        . "complex type " . $type->get_name()
        . " - typemap may be incomplete";
}

1;
