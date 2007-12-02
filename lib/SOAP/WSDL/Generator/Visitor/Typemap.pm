package SOAP::WSDL::Generator::Visitor::Typemap;
use strict;
use warnings;
use Class::Std::Fast::Storable;

use base qw(SOAP::WSDL::Generator::Visitor);

our $VERSION = q{2.00_25};

my %path_of             :ATTR(:name<path>           :default<[]>);
my %typemap_of          :ATTR(:name<typemap>        :default<()>);
my %type_prefix_of      :ATTR(:name<type_prefix>    :default<()>);
my %element_prefix_of   :ATTR(:name<element_prefix> :default<()>);

sub START {
    my ($self, $ident, $arg_ref) = @_;
    $type_prefix_of{ $ident } ||= 'MyTypes';
    $element_prefix_of{ $ident } ||= 'MyElements';
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

sub visit_Definitions {
    my ( $self, $ident, $definitions ) = ( $_[0], ident $_[0], $_[1] );

    $self->set_definitions( $definitions );

    for ( @{ $definitions->get_service() } ){
        $_->_accept($self);
    }
}

sub visit_Service {
    my ( $self, $service ) = ( $_[0], $_[1] );

    for ( @{ $service->get_port() } ) { $_->_accept($self); }
}

sub visit_Port {
    my ( $self, $ident, $port ) = ( $_[0], ident $_[0], $_[1] );

    # This is a false assumption - typemaps may be valid for non-soap
    # bindings as well.
    # TODO check and correct
    return if not $port->first_address();
    return if not $port->first_address()->isa('SOAP::WSDL::SOAP::Address');

    my $binding = $self->get_definitions()
      ->find_binding( $port->expand( $port->get_binding() ) )
      or die 'binding ' . $port->get_binding() . ' not found!';

    $binding->_accept($self);
}

sub visit_Binding {
    my ( $self, $ident, $binding ) = ( $_[0], ident $_[0], $_[1] );

    my $portType = $self->get_definitions()
      ->find_portType( $binding->expand( $binding->get_type ) )
      or die 'portType not found: ' . $binding->binding_type;

    for my $operation ( @{ $binding->get_operation() } ) {
        my $name = $operation->get_name();

        # get the equally named operation from the portType
        my ($op) = grep { $_->get_name eq $name }
            @{ $portType->get_operation() }
            or die "operation <$name> not found";

        # visit every input, output and fault message...
        for ( @{ $op->get_input }, @{ $op->get_output }, @{ $op->get_fault } ) {
            $_->_accept($self);
        }
    }
}

sub visit_OpMessage {
    my ( $self, $ident, $operation_message ) = ( $_[0], ident $_[0], $_[1] );
    return if not( $operation_message->get_message() );    # we're in binding

    # TODO maybe allow more messages && overloading by specifying name

    # find message referenced in operation
    my $message = $self->get_definitions()->find_message(
        $operation_message->expand( $operation_message->get_message() ) );

    for my $part ( @{ $message->get_part() } ) {
        $part->_accept($self);
    }
}

sub visit_Part {
    my ( $self, $ident, $part ) = ( $_[0], ident $_[0], $_[1] );

    my $types_ref = $self->get_definitions()->first_types()
      or warn "Empty part" . $part->get_name();

    # resolve type
    # If we have a type, this type is to be used in document/literal
    # as global type. However this is forbidden, at least by WS-I.
    # We should store the style/encoding somewhere, and regard it.
    # TODO: auto-generate element for RPC bindings
    if ( my $type_name = $part->get_type ) {
        # FIXME support RPC-style calls
        die "unsupported global type <$type_name> found in part";
    }

    # TODO factor out iterator or replace by lookup (probably better)
    if ( my $element_name = $part->get_element() ) {
        my $element = $types_ref->find_element(
          $part->expand($element_name) )
          || die "no element $element_name found for part " . $part->get_name();
        $element->_accept($self);
        return;
    }

    warn 'neither type nor element - do not know what to do for part '
          . $part->get_name();
    return;
}

sub process_referenced_type {
    my ( $self, $ns, $localname ) = @_;
    return if not $localname;
    my $ident = ident $self;

    # get type's class name
    # Caveat: visits type if it's a referenced type from the
    # a ? b : c operation.
    my ($type, $typeclass);
    if ( $ns eq 'http://www.w3.org/2001/XMLSchema' ) {
        $typeclass = "SOAP::WSDL::XSD::Typelib::Builtin::$localname";
    }
    else {
        $type = $self->get_definitions()->first_types()->find_type( $ns, $localname );
        $typeclass = join( q{::}, $type_prefix_of{$ident}, $type->get_name() );
    }

    # set before to allow it to be used from inside _accept
    $self->set_typemap_entry($typeclass);

    $type->_accept($self) if ($type);

    # set afterwards again (just to be sure...)
    $self->set_typemap_entry($typeclass);
    return $self;
}

sub process_atomic_type {
    my ( $self, $type, $callback ) = @_;
    return if not $type;

    my $ident = ident $self;
    $callback->( $self, $type ) if $callback;
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
            my $typeclass = defined ($parent)
                ? join '::_', $parent , $element->get_name()
                : join q{::}, $element_prefix_of{$ident}, $element->get_name();
            $self->set_typemap_entry($typeclass);
            last SWITCH;
        }

        # for atomic and complex types , and ref elements
        my $typeclass = join q{::}, $element_prefix_of{$ident}, $element->get_name();
        $self->set_typemap_entry($typeclass);

        $self->process_atomic_type( $element->first_complexType()
            , sub { $_[1]->_accept($_[0]) } )
            && last;

        # TODO: add element ref handling
    };

    # Safety measure. If someone defines a top-level element with
    # a normal (not atomic) type, we just override it here
    if (not defined($parent)) {
        # for atomic and complex types , and ref elements
        my $typeclass = join q{::}, $element_prefix_of{$ident}, $element->get_name();
        $self->set_typemap_entry($typeclass);
    }

    # step up in hierarchy
    pop @{ $path_of{$ident} };
}

sub visit_XSD_ComplexType {
    my ($self, $ident, $type) = ($_[0], ident $_[0], $_[1] );
    my $content_model = $type->get_flavor();
    # TODO is this allowed ? or should we better die ?
    return if not $content_model; # empty complexType

    if ( grep { $_ eq $content_model} qw(all sequence choice) )
    {
        # visit child elements
        for (@{ $type->get_element() }) {
            $_->_accept( $self );
        }
        return;
    }

    warn "unsupported content model $content_model found in "
        . "complex type " . $type->get_name()
        . " - typemap may be incomplete";
}

1;
