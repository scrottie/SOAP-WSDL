package SOAP::WSDL::Part;
use strict;
use warnings;
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
	if ($item_name = $self->get_type() )
	{
		# resolve type
		my ($prefix, $localname) = split /:/ , $item_name, 2;
		my $type = $typelib->find_type(
			$ns_map{ $prefix },
			$localname
		);
		return $type->serialize( $self->get_name(), $data, $opt );
	}
	elsif ( $item_name = $self->get_element() )
	{
        my ($prefix, $localname) = split /:/ , $item_name, 2;
		my $element = $typelib->find_element(
			$ns_map{ $prefix },
			$localname
		);
		return $element->serialize( undef, $data, $opt );
	}
    die "Neither type nor element - don't know what to do";
}

sub explain {
	my ($self, $opt, $name ) = @_;
	my $typelib = $opt->{ wsdl }->first_types()
        || die "No typelib";

	my %ns_map = reverse %{ $opt->{ namespace } };
	my $element = $self->get_type() || $self->get_element();

	# resolve type
	my ($prefix, $localname) = split /:/ , $element;
	my $type = $typelib->find_type(
		$ns_map{ $prefix },
		$localname
	)
    || $typelib->find_element(
                $ns_map{ $prefix },
                $localname
    );

	if (not $type)
	{
		warn "no type/element $element ({ $ns_map{ $prefix } }$localname) found for part " . $self->get_name();
		return q{};
	}
	return $type->explain( $opt, $self->get_name() );
}

sub to_typemap {
    my ($self, $opt, $name ) = @_;
    my $txt = q{};
    my $typelib = $opt->{ wsdl }->first_types()
        || die "No typelib";

    my %ns_map = reverse %{ $opt->{ wsdl }->get_xmlns() };
    my $element = $self->get_type() || $self->get_element();

    # resolve type
    my ($prefix, $localname) = split /:/ , $element;
    my $type;
    if ($type = $typelib->find_type( $ns_map{ $prefix }, $localname ) ) {
        $txt .= "'/' => " . $type->get_name() . "\n";
    }
    else {
        $type = $typelib->find_element( $ns_map{ $prefix }, $localname );
    }

    if (not $type) {
       warn "no type/element $element ({ $ns_map{ $prefix } }$localname) found for part " . $self->get_name();
       return q{};
    }
    $opt->{ path } = [];
    $txt .= $type->to_typemap( $opt, $self->get_name() );
    return $txt;
}

1;
