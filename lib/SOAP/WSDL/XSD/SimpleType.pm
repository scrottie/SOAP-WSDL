package SOAP::WSDL::XSD::SimpleType;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::Base);

my %base_of         :ATTR(:name<base>           :default<()>);
my %flavor_of       :ATTR(:name<flavor>         :default<()>);
my %itemType_of     :ATTR(:name<itemType>       :default<()>);
my %enumeration_of  :ATTR(:name<enumeration>    :default<()>);
# is set to simpleContent/complexContent
my %content_Model_of    :ATTR(:name<contentModel>   :default<()>);

sub set_restriction {
	my $self = shift;
	my @attributes = @_;
	$self->set_flavor( 'restriction' );
	foreach my $attr (@attributes)
	{
		next if (not $attr->{ LocalName } eq 'restriction');
		$self->base( $attr->{ Value } );
	}
}

sub set_list {
	my $self = shift;
	my @attributes = @_;
	$self->set_flavor( 'list' );
	foreach my $attr (@attributes)
	{
		next if (not $attr->{ LocalName } eq 'list');
		$self->set_base( $attr->{ Value } );
	}
}

sub set_union {
	my $self = shift;
	my @attributes = @_;
	$self->set_flavor( 'union' );
	foreach my $attr (@attributes)
	{
		next if (not $attr->{ LocalName } eq 'memberTypes');
		$self->set_base( [ split /\s/, $attr->{ Value } ] );
	}
}

sub push_enumeration
{
	my $self = shift;
	my @attr = @_;
	my @attributes = @_;
	$self->set_flavor( 'enumeration' );
	foreach my $attr (@attributes)
	{
		next if (not $attr->{ LocalName } eq 'value');
		push @{ $enumeration_of{ ident $self } }, $attr->{ 'Value' };
	}
}

sub serialize
{
	my $self = shift;
	my $name = shift;
	my $value = shift;
	my $opt = shift;
    my $ident = ident $self;
	$self->_check_value( $value );

	return $self->_serialize_single($name, $value , $opt)
		if ( $flavor_of{ $ident } eq 'restriction'
            or $flavor_of{ $ident } eq 'union'
            or $flavor_of{ $ident } eq 'enumeration');

	if ($flavor_of{ $ident } eq 'list' )
	{
		$value ||= [];
		$value = [ $value ] if ( ref( $value) ne 'ARRAY' );
		return $self->_serialize_single($name, join( q{ }, @{ $value } ), $opt);
	}
}

sub _serialize_single
{
	my ($self, $name, $value, $opt) = @_;
	my $xml = '';
	$xml .= $opt->{ indent } if ($opt->{ readable });	# add indentation
	$xml .= '<' . $name;
	if ( $opt->{ autotype })
	{
		my $ns = $self->get_targetNamespace();
        my $prefix = $opt->{ namespace }->{ $ns }
            || die 'No prefix found for namespace '. $ns;
        $xml .= ' type="' . $prefix . ':'
            . $self->get_name() .'"';
	}
	$xml .= '>';
	$xml .= $value;
	$xml .= '</' . $name . '>' ;
	$xml .= "\n" if ($opt->{ readable });
	return $xml;
}

sub explain
{
	my ($self, $opt, $name) = @_;
	my $perl;
	$opt->{ indent } ||= "";
	$perl .= $opt->{ indent } if ($opt->{ readable });
	$perl .= q{'} . $name . q{' => $someValue };
	$perl .= "\n" if ($opt->{ readable });
	return $perl;
}

sub _check_value {
	my $self = shift;
}

sub toClass {
    my $self = shift;
    my $opt = shift;
    my $class_prefix = $opt->{ prefix };
    my $name = $opt->{name} || $self->get_name();
    my $flavor = $self->get_flavor() eq 'list' 
        ? 'SOAP::WSDL::XSD::Typelib::Builtin::list'
        : $self->get_flavor() eq 'restriction' 
            ? 'SOAP::WSDL::XSD::Typelib::SimpleType::restriction'
            : q{};
    my $base = $self->get_base();
    my $targetNamespace = $self->get_targetNamespace;
    my ($prefix, $localname) = split /:/, $base;
    my %ns_map = reverse %{ $opt->{ wsdl }->get_xmlns() };
    $base = ($ns_map{ $prefix} eq 'http://www.w3.org/2001/XMLSchema') 
        ? "SOAP::WSDL::XSD::Typelib::Builtin::$localname"
        : "$opt->{prefix}::$localname";
    
    my $code =<<"EOT";
package $class_prefix::$name;
use strict;
use Class::Std::Storable;
use SOAP::WSDL::XSD::Typelib::Builtin;
use SOAP::WSDL::XSD::Typelib::SimpleType;
use base qw(
    SOAP::WSDL::XSD::Typelib::SimpleType
    $flavor
    $base
);

1;

sub get_xmlns { '$targetNamespace' }

EOT

    return $code;
}


1;

=pod

=head1 Bugs and limitations

=over

=item * simpleContent, complexContent

These child elements are not implemented yet

=item * union

union simpleType definitions probalbly serialize wrong

=item * explain may produce erroneous results

=over

=cut
