package SOAP::WSDL::Part;
use strict;
use warnings;
use Carp qw(croak);
use Class::Std::Storable;

use base qw(SOAP::WSDL::Base);

my %element_of  :ATTR(:name<element>    :default<()>);
my %type_of     :ATTR(:name<type>       :default<()>);

sub serialize
{
    my $self = shift;
    my $name = shift;
    my $data = shift;
    my $opt = shift;
    my $typelib = $opt->{ typelib } || die "No typelib";
    my %ns_map = reverse %{ $opt->{ namespace } };

    my $item_name;
    if ($item_name = $self->get_type() ) {
        # resolve type
        my ($prefix, $localname) = split /:/ , $item_name, 2;
        my $type = $typelib->find_type( $ns_map{ $prefix }, $localname	)
          or die "type $item_name , $ns_map{ $prefix } not found";
          
        my $name = $self->get_name();
	   return $type->serialize( $name, $data->{ $name }, $opt );
    }
    elsif ( $item_name = $self->get_element() ) {
        my ($prefix, $localname) = split /:/ , $item_name, 2;
        my $element = $typelib->find_element(
            $ns_map{ $prefix },
            $localname
        )
            or die "element $item_name , $ns_map{ $prefix } not found";
        $opt->{ qualify } = 1;
        return $element->serialize( undef, $data->{ $element->get_name() }, $opt );
    }
    die "Neither type nor element - don't know what to do";
}

sub explain {
    my ($self, $opt, $name ) = @_;
    my $typelib = $opt->{ wsdl }->first_types() || die "No typelib";
    my $element = $self->get_type() || $self->get_element();

    # resolve type
    my $type = $typelib->find_type( $opt->{ wsdl }->_expand( $element ) )
        || $typelib->find_element( $opt->{ wsdl }->_expand( $element ) );

    if (not $type)
    {
        warn "no type/element $element found for part " . $self->get_name();
        return q{};
    }
    return " {\n" .  $type->explain( $opt, $self->get_name() ) . " }\n";
}

sub to_typemap {
    my ($self, $opt, $name ) = @_;
    my $txt = q{};
    my $wsdl = $opt->{ wsdl };
    my $typelib = $opt->{ wsdl }->first_types()
        || die "No typelib";

    # resolve type
    my $type;
    if (my $type_name = $self->get_type()) {
        $type = $typelib->find_type( $wsdl->_expand( $type_name ) )
            || croak "no type/element $type_name found for part " . $self->get_name();
        $txt .= "q{} => " . $type->get_name() . "\n";
    }
    elsif ( my $element_name = $self->get_element() ) {         
        $type = $typelib->find_element( $wsdl->_expand( $element_name ) )
          || croak "no type/element $element_name found for part " . $self->get_name();
    }
    else {
        warn 'neither type nor element - do not know what to do for part ' 
          . $self->get_name();
        return q{};
    }
    $opt->{ path } = [];
    $txt .= $type->to_typemap( $opt, $self->get_name() );
    return $txt;
}

1;
