package SOAP::WSDL::Generator::Template::Plugin::XSD;
use strict;
use warnings;

use Class::Std::Fast::Storable constructor => 'none';

my %namespace_prefix_map_of    :ATTR(:name<namespace_prefix_map>  :default<{}>);
my %namespace_map_of            :ATTR(:name<namespace_map>  :default<{}>);
my %prefix_of                   :ATTR(:name<prefix> :default<()>);

# create a singleton
sub load {               # called as MyPlugin->load($context)
    my ($class, $context, @arg_from) = @_;
    my $stash = $context->stash();
    my $self = bless \do { my $o = Class::Std::Fast::ID() }, $class;
    use Data::Dumper;
    # die Data::Dumper::Dumper $stash->{ context };
    $self->set_namespace_map( $stash->{ context }->{ namespace_map });
    $self->set_namespace_prefix_map( $stash->{ context }->{ namespace_prefix_map });
    $self->set_prefix( $stash->{ context }->{ prefix });
    return $self;       # returns 'MyPlugin'
}

sub new {
    return shift;
}

sub _get_prefix {
    my ($self, $type, $namespace) = @_;
    return $namespace_prefix_map_of{ $$self }->{ $namespace }
        || ( ($namespace_map_of{ $$self }->{ $namespace })
            ? join ('::', $prefix_of{ $$self }->{ $type }, $namespace_map_of{ $$self }->{ $namespace })
            : $prefix_of{ $$self }->{ $type }
        )
        || $prefix_of{ $$self }->{ $type };
}

sub get_element_prefix {
    shift->_get_prefix( 'element', shift );
}

sub get_interface_prefix {
    shift->_get_prefix( 'interface', shift );
}

sub get_server_prefix {
    shift->_get_prefix( 'server', shift );
}

sub get_type_prefix {
    # die "WIX";
    shift->_get_prefix( 'type', shift );
}

sub get_typemap_prefix {
    shift->_get_prefix( 'typemap', shift );
}

sub error {}
1;

