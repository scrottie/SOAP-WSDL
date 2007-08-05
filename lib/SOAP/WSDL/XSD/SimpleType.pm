package SOAP::WSDL::XSD::SimpleType;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::Base);

my %base_of         :ATTR(:name<base>           :default<()>);
my %itemType_of     :ATTR(:name<itemType>       :default<()>);
my %enumeration_of  :ATTR(:name<enumeration>    :default<()>);
# is set to simpleContent/complexContent
my %content_Model_of    :ATTR(:name<contentModel>   :default<()>);

# set to restriction|list|union|enumeration
my %flavor_of       :ATTR(:name<flavor>         :default<()>);

sub set_restriction {
    my $self = shift;
    my @attributes = @_;
    $self->set_flavor( 'restriction' );
    for (@attributes) {
        next if (not $_->{ LocalName } eq 'base');
        $self->set_base( $_->{ Value } );
    }
}

sub set_list {
    my $self = shift;
    my @attributes = @_;
    $self->set_flavor( 'list' );
    for (@attributes) {
        next if (not $_->{ LocalName } eq 'type');
        $self->set_base( $_->{ Value } );
    }
}

sub set_union {
    my $self = shift;
    my @attributes = @_;
    $self->set_flavor( 'union' );
    for (@attributes) {
        next if (not $_->{ LocalName } eq 'memberTypes');
        $self->set_base( [ split /\s/, $_->{ Value } ] );
    }
}

sub push_enumeration {
	my $self = shift;
	my @attr = @_;
	my @attributes = @_;
	$self->set_flavor( 'enumeration' );
	for (@attributes) {
		next if (not $_->{ LocalName } eq 'value');
		push @{ $enumeration_of{ ident $self } }, $_->{ 'Value' };
	}
}

sub serialize {
    my $self = shift;
    my $name = shift;
    my $value = shift;
    my $opt = shift;
    my $ident = ident $self;
    
    $opt->{ attributes } ||= [];
    $opt->{ indent } ||= q{};
    
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

sub _serialize_single {
    my ($self, $name, $value, $opt) = @_;
    my $xml = '';
    $xml .= $opt->{ indent } if ($opt->{ readable });	# add indentation
    $xml .= '<' . join ' ', $name, @{ $opt->{ attributes } };
    if ( $opt->{ autotype }) {
        my $ns = $self->get_targetNamespace();
        my $prefix = $opt->{ namespace }->{ $ns }
           || die 'No prefix found for namespace '. $ns;
        $xml .= ' type="' . $prefix . ':' . $self->get_name() .'"';
    }
    
    # nillabel ?
    return $xml .'/>' if not defined $value;
    
    $xml .= join q{}, '>' , $value , '</' , $name , '>';
    $xml .= "\n" if ($opt->{ readable });
    return $xml;
}

sub explain {
	my ($self, $opt, $name ) = @_;
	$opt->{ indent } = q{} if not defined $opt->{ indent };
	return "$opt->{ indent }'$name' => \$someValue,\n"
}

sub _check_value {
	my $self = shift;
}

# TODO: implement to_class based on template...

sub to_class {
    my $self = shift;
    my $opt = shift;
    my $class_prefix = $opt->{ type_prefix };
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
