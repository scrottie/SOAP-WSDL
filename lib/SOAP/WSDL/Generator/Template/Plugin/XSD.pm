package SOAP::WSDL::Generator::Template::Plugin::XSD;
use strict;
use warnings;
use Carp qw(confess);
use Class::Std::Fast::Storable constructor => 'none';

my %namespace_prefix_map_of :ATTR(:name<namespace_prefix_map>   :default<{}>);
my %namespace_map_of        :ATTR(:name<namespace_map>          :default<{}>);
my %prefix_of               :ATTR(:name<prefix>                 :default<()>);
my %prefix_resolver_of      :ATTR(:name<prefix_resolver>        :default<()>);

# create a singleton
sub load {               # called as MyPlugin->load($context)
    my ($class, $context, @arg_from) = @_;
    my $stash = $context->stash();
    my $self = bless \do { my $o = Class::Std::Fast::ID() }, $class;
#    $self->set_namespace_map( $stash->{ context }->{ namespace_map });
#    $self->set_namespace_prefix_map( $stash->{ context }->{ namespace_prefix_map });
#    $self->set_prefix( $stash->{ context }->{ prefix });
    $self->set_prefix_resolver( $stash->{ context }->{ prefix_resolver });
    return $self;       # returns 'MyPlugin'
}

sub new {
    return shift if ref $_[0];

    my ($class, $arg_ref) = @_;

    my $self = bless \do { my $o = Class::Std::Fast::ID() }, $class;
#    $self->set_namespace_map( $arg_ref->{ namespace_map });
#    $self->set_namespace_prefix_map( $arg_ref->{ namespace_prefix_map });
#    $self->set_prefix( $arg_ref->{ prefix });
    $self->set_prefix_resolver( $arg_ref->{ prefix_resolver });
    return $self;       # returns 'MyPlugin'
}

sub _get_prefix {
    my ($self, $type, $node) = @_;
    my $namespace = defined ($node)
        ? ref($node)
            ? $node->get_targetNamespace
            : $node
        : undef;
    return $self->get_prefix_resolver->resolve_prefix(
        $type,
        $namespace,
        ref($node)
            ? $node
            : undef
     );
}

#sub _get_prefix {
#    my ($self, $type, $namespace) = @_;
#    return $prefix_of{ $$self }->{ $type }
#        if not defined($namespace);
#    return $namespace_prefix_map_of{ $$self }->{ $namespace }
#        || ( ($namespace_map_of{ $$self }->{ $namespace })
#            ? join ('::', $prefix_of{ $$self }->{ $type }, $namespace_map_of{ $$self }->{ $namespace })
#            : $prefix_of{ $$self }->{ $type }
#        );
#}

sub create_xsd_name {
    my ($self,$element) = @_;
    my $name = $self->_resolve_prefix($element) . '::'
        . $element->get_name();
    return $self->perl_name( $name );
}

sub create_typemap_name {
    my ($self, $node) = @_;
    my $name = $self->_get_prefix('typemap') . '::'
        . $node->get_name();
    return $self->perl_name( $name );
}

sub create_server_name {
    my ($self, $server, $port) = @_;
    my $port_name = $port->get_name();
    $port_name =~s{\A (?:.+)\. ([^\.]+) \z}{$1}x;
    my $name = join('::',
        $self->_get_prefix('server', $server),
        $server->get_name(),
        $port_name
    );
    return $self->perl_name( $name );
}

sub create_interface_name {
    my ($self, $server, $port) = @_;
    my $port_name = $port->get_name();
    $port_name =~s{\A (?:.+)\. ([^\.]+) \z}{$1}x;
    my $name = join('::',
        $self->_get_prefix('interface', $server),
        $server->get_name(),
        $port_name
    );
    return $self->perl_name( $name );
}

sub _resolve_prefix {
    my ($self, $node) = @_;
    confess "no node" if not $node;
    if ($node->isa('SOAP::WSDL::XSD::Builtin')) {
        return $self->_get_prefix('type', $node)
    }
    if ( $node->isa('SOAP::WSDL::XSD::SimpleType')
        or $node->isa('SOAP::WSDL::XSD::ComplexType')
    ) {
        return $self->_get_prefix('type', $node);
    }
    if ( $node->isa('SOAP::WSDL::XSD::Element') ) {
        return $self->_get_prefix('element', $node);
    }
    if ( $node->isa('SOAP::WSDL::XSD::Attribute') ) {
        return $self->_get_prefix('attribute', $node);
    }
}

sub perl_name {
    my $self = shift;
    my $name = shift;
    $name =~s{[\-]}{_}xmsg;
    $name =~s{[\.]}{::}xmsg;
    return $name;
}

sub create_subpackage_name {
    my $self        = shift;
    my $arg_ref     = shift;
    my $type        = ref $arg_ref eq 'HASH' ? $arg_ref->{ value } : $arg_ref;

    my @name_from = $type->get_name() || (); ;
    my $parent = $type;
    my $top_node = $parent;
    if (! $parent->get_parent()->isa('SOAP::WSDL::XSD::Schema') ) {
        NAMES: while ($parent = $parent->get_parent()) {
            $top_node = $parent;
            last NAMES if $parent->get_parent()->isa('SOAP::WSDL::XSD::Schema');
            # skip empty names - atomic types have no name...
            unshift @name_from, $parent->get_name()
                if $parent->get_name();
        }
    }
    # create name for top node
    my $top_node_name = $self->create_xsd_name($top_node);
    my $package_name = join('::_', $top_node_name , (@name_from) ? join('::', @name_from) : () );
    return $package_name;
}

sub create_xmlattr_name {
    return join '::', shift->create_subpackage_name(shift), 'XmlAttr';
}

1;

=pod

=head1 NAME

SOAP::WSDL::Generator::Template::Plugin::XSD - Template plugin for the XSD generator

=head1 METHODS

=head2 perl_name

 XSD.perl_name(element.get_name);

Converts a XML name into a valid perl name (valid for subroutines, variables
or the like).

perl_name takes a crude approach by just replacing . and - (dot and dash)
with a underscore. This may or may not be sufficient, and may or may not
provoke collisions in your XML names.

=head1 LICENSE AND COPYRIGHT

Copyright 2008 Martin Kutter.

This file is part of SOAP-WSDL. You may distribute/modify it under the same
terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=head1 REPOSITORY INFORMATION

 $Rev: 564 $
 $LastChangedBy: kutterma $
 $Id: ComplexType.pm 564 2008-02-23 13:31:39Z kutterma $
 $HeadURL: http://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL/XSD/Typelib/ComplexType.pm $

=cut

