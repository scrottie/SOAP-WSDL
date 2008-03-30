package SOAP::WSDL::Generator::PrefixResolver;
use strict; use warnings;

use Class::Std::Fast::Storable;

my %namespace_prefix_map_of :ATTR(:name<namespace_prefix_map>   :default<{}>);
my %namespace_map_of        :ATTR(:name<namespace_map>          :default<{}>);
my %prefix_of               :ATTR(:name<prefix> :default<{}>);

sub resolve_prefix {
    my ($self, $type, $namespace, $element) = @_;
    return $prefix_of{ $$self }->{ $type }
        if not defined($namespace);
    return $namespace_prefix_map_of{ $$self }->{ $namespace }
        || ( ($namespace_map_of{ $$self }->{ $namespace })
            ? join ('::', $prefix_of{ $$self }->{ $type }, $namespace_map_of{ $$self }->{ $namespace })
            : $prefix_of{ $$self }->{ $type }
        );

}

1;

__END__

=pod

=head1 NAME

SOAP::WSDL::Generator::PrefixResolver - prefixes for different classes

=head1 SYNOPSIS

If you want to create your custom prefix resolver:

 package MyPrefixResolver;
 use strict; use warnings;
 use base qw(SOAP::WSDL::Generator::PrefixResolver);

 sub resolve_prefix {
     my ($self, $type, $namespace, $node) = @_;
     # return something special
     return $self->SUPER::resolve_prefix($type, $namespace, $node);
 }

When generating code:

 use MyPrefixResolver;
 use SOAP::WSDL::Generator::XSD;
 my $generator = SOAP::WSDL::Generator::Template::XSD->new({
    prefix_resolver_class => 'MyPrefixResolver',
 });

=head1 DESCRIPTION

Prefix resolver class for SOAP::WSDL's code generator. You may subclass it to
apply some custom prefix resolving logic.

Subclasses must implement the following methods:

=over

=item * resolve_prefix

 sub resolve_prefix {
    my ($self, $namespace, $node) = @_;
    # ...
 }

resolve_prefix is expected to return a (perl class) prefis. It is called with
the following parameters:

 NAME       DESCRIPTION
 -----------------------------------------------------------------------------
 type       One of (server|interface|typemap|type|element|attribute)
 namespace  The targetNamespace of the node to generate a prefix for.
 node       The node to generate a prefix for

You usually just need type and namespace for prefix resolving. node is
provided for rather funky setups, where you have to choose different prefixes
based on type names or whatever.

Note that node may be of any of the following classes:

 SOAP::WSDL::Service
 SOAP::WSDL::XSD::Attribute
 SOAP::WSDL::XSD::Element
 SOAP::WSDL::XSD::Type

Note that both namespace and node may be undef - you should test for
definedness before doing anything fancy with them.

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2008 Martin Kutter.

This library is free software. You may distribute/modify it under
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=head1 REPOSITORY INFORMATION

 $Rev: 583 $
 $LastChangedBy: kutterma $
 $Id: $
 $HeadURL: $

=cut
