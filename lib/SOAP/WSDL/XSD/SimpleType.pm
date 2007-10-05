package SOAP::WSDL::XSD::SimpleType;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::Base);

our $VERSION='2.00_17';

my %annotation_of   :ATTR(:name<annotation>     :default<()>);
my %base_of         :ATTR(:name<base>           :default<()>);
my %itemType_of     :ATTR(:name<itemType>       :default<()>);
# is set to simpleContent/complexContent
# my %content_model_of    :ATTR(:name<contentModel>   :default<()>);

# TODO rename flavor to content_model to be consistent with the XML Schema
# specs - though flavor is the cooler name..
# set to restriction|list|union|enumeration
my %flavor_of       :ATTR(:name<flavor>         :default<()>);

# for simpleType containing atomic simple types
my %type_of         :ATTR(:name<type>           :default<()>);

sub get_simpleType; *get_simpleType = \&get_type;
sub set_simpleType; *set_simpleType = \&set_type;

sub get_variety; *get_variety = \&get_flavor;

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
        next if (not $_->{ LocalName } eq 'itemType');
        $self->set_itemType( $_->{ Value } );
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

sub serialize {
    my $self = shift;
    my $name = shift;
    my $value = shift;
    my $opt = shift;
    my $ident = ident $self;
    
    $opt->{ attributes } ||= [];
    $opt->{ indent } ||= q{};
      
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

1;
