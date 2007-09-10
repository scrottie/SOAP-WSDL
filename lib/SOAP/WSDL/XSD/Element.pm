package SOAP::WSDL::XSD::Element;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::Base);
use Data::Dumper;

my %simpleType_of   :ATTR(:name<simpleType>  :default<()>);
my %complexType_of  :ATTR(:name<complexType> :default<()>);
my %facet_of        :ATTR(:name<facet>      :default<()>);
my %type_of         :ATTR(:name<type>       :default<()>);
my %abstract_of     :ATTR(:name<abstract>   :default<()>);
my %block_of        :ATTR(:name<block>      :default<()>);
my %default_of      :ATTR(:name<default>    :default<()>);
my %final_of        :ATTR(:name<final>      :default<()>);
my %fixed_of        :ATTR(:name<fixed>      :default<()>);
my %form_of         :ATTR(:name<form>       :default<()>);
my %maxOccurs_of    :ATTR(:name<maxOccurs>  :default<()>);
my %minOccurs_of    :ATTR(:name<minOccurs>  :default<()>);
my %nillable_of     :ATTR(:name<nillable>   :default<()>);
my %ref_of          :ATTR(:name<ref>        :default<()>);
my %substitutionGroup_of :ATTR(:name<substitutionGroup> :default<()>);

sub first_type {
    my $result_ref = $complexType_of{ ident shift };
    return if not $result_ref;
    return $result_ref if (not ref $result_ref eq 'ARRAY');
    return $result_ref->[0];
}

sub first_simpleType {
    my $result_ref = $simpleType_of{ ident shift };
    return if not $result_ref;
    return $result_ref if (not ref $result_ref eq 'ARRAY');
    return $result_ref->[0];
}

sub first_complexType {
    my $result_ref = $complexType_of{ ident shift };
    return if not $result_ref;
    return $result_ref if (not ref $result_ref eq 'ARRAY');
    return $result_ref->[0];
}

# serialize type instead...
sub serialize {
    my ($self, $name, $value, $opt) = @_;
    my $type;
    my $typelib = $opt->{ typelib };
    my %ns_map = reverse %{ $opt->{ namespace } };
    my $ident = ident $self;

    # abstract elements may only be serialized via ref - and then we have a
    # name...
    die "cannot serialize abstract element" if $abstract_of{ $ident }
        and not $name;

    # TODO: implement final and substitutionGroup - maybe never implement
    # substitutionGroup ?

    $name ||= $self->get_name();

    if ( $opt->{ qualify } ) {
        $opt->{ attributes } = [ ' xmlns="' . $self->get_targetNamespace .'"' ];
    }      


    # set default and fixed - fixed overrides everything,
    # default only empty (undefined) values
    if (not defined $value)     {
      $value = $default_of{ ident $self } if $default_of{ ident $self };
    }
    $value = $fixed_of{ ident $self } if $fixed_of{ ident $self };

    # TODO check nillable and serialize empty data correctly

    # return if minOccurs is 0 and we have no value
    if (defined $minOccurs_of{ ident $self }
        and $minOccurs_of{ ident $self } == 0) {
        return q{} if not defined $value;
    }

    # handle direct simpleType and complexType here
    if ($type = $self->first_simpleType() ) {             # simpleType
        return $type->serialize( $name, $value, $opt );
    }
    elsif ($type = $self->first_complexType() ) {           # complexType
        return $type->serialize( $name, $value, $opt );
    }
    elsif (my $ref_name = $ref_of{ $ident }) {              # ref
        my ($prefix, $localname) = split /:/ , $ref_name;
        my $ns = $ns_map{ $prefix };
        $type = $typelib->find_element( $ns, $localname );
        die "no element for ref $prefix:$localname" if (not $type);
        return $type->serialize( $name, $value, $opt );
    }

    # lookup type
    my ($prefix, $localname) = split /:/ , $self->get_type();
    my $ns = $ns_map{ $prefix };
	$type = $typelib->find_type(
		$ns, $localname
	);

    # safety check
    die "no type for $prefix:$localname $ns_map{$prefix}" if (not $type);

    return $type->serialize( $name, $value, $opt );
}

sub explain {
	my ($self, $opt, $name) = @_;
	my $type;
        my $text = q{};

	# if we have a simple / complexType, explain right here
	if ($type = $self->first_simpleType() )
	{
            if ($opt->{ anonymous }) {
                delete $opt->{ anonymous };
                return $type->explain( $opt, undef );
            }
            return $type->explain( $opt, $self->get_name() );
	}
	elsif ($type = $self->first_complexType() )
	{
            if ($opt->{ anonymous }) {
                delete $opt->{ anonymous };
                return $type->explain( $opt, undef );
            }
            return $type->explain( $opt, $self->get_name() );
	}
        elsif (my $element_name = $self->get_ref() ) {
            my $element = $opt->{ wsdl }->first_types()->find_element(
                $opt->{ wsdl }->_expand( $element_name )
            );
            return $element->explain( $opt, $self->get_name() );
        }

	# return if it's not a derived type - we don't handle
	# other stuff yet.
	return $text if (not $self->get_type() );

	# if we have a derived type, fetch type and explain
	my ($prefix, $localname) = split /:/ , $self->get_type();
	my %ns_map = reverse %{ $opt->{ wsdl }->get_xmlns };

	$type = $opt->{ wsdl }->first_types()->find_type(
		$ns_map{ $prefix }, $localname
	);

        use Data::Dumper;
	die "no type for $prefix:$localname ($ns_map{ $prefix })" 
	   . Dumper $opt->{ wsdl }->first_types()->first_schema()->_DUMP
            if (not $type);

        if ($opt->{ anonymous }) {
            delete $opt->{ anonymous };
            return $text .= $type->explain( $opt, undef );
        }
	return $text .= $type->explain( $opt, $name || $self->get_name() );
	return 'ERROR: '. $@;
}

sub to_typemap {
    
    my ($self, $opt) = @_;
    my $txt = q{};

    my %nsmap = reverse %{ $opt->{ wsdl }->get_xmlns() };
    my $type;

    push @{ $opt->{path} }, $self->get_name();

    if ( my $typename = $self->get_type() ) {
        my ($prefix, $localname) = split /:/, $self->get_type();
        my $ns = $nsmap{ $prefix };
        my $typeclass;

        # builtin type
        if ( $nsmap{ $prefix } eq 'http://www.w3.org/2001/XMLSchema') {
              $typeclass = "SOAP::WSDL::XSD::Typelib::Builtin::$localname";
        }
        else
        {
            $type = $opt->{ wsdl }->first_types()->find_type( $ns, $localname );

            # referenced types need type_prefix (may be globally unique)
            $typeclass = $opt->{ type_prefix } . $type->get_name();
            $txt .= $type->to_typemap($opt);
        }
        $txt .= q{'} . join( q{/}, @{ $opt->{path} } ) . "' => '$typeclass',\n";
    }

    # atomic types need element prefix
    elsif ($type = $self->first_simpleType() ) {
        # atomic types need element prefix (may be locally unique)
        # TODO fix simpletype Typemap
        my $typeclass = $opt->{ element_prefix } . $self->get_name();        
        $txt .= q{'} . join( q{/}, @{ $opt->{path} } ) . "' => '$typeclass',\n";

        my $flavor = $type->get_flavor(); 
        if ( $flavor eq 'sequence' ) {
            $txt .= "# atomic simple type (sequence)\n";
            $txt .= $type->to_typemap($opt). "\n";
            $txt .= "# end atomic simple type (sequence)\n";
        }
        elsif ( $flavor eq 'all' ) {
            $txt .= "# atomic simple type (all)\n";
            $txt .= $type->to_typemap($opt). "\n";
            $txt .= "# end atomic simple type (all)\n";
        }
        
    }
    elsif ($type = $self->first_complexType() ) {
        my $typeclass = $opt->{ element_prefix } . $self->get_name();        
        $txt .= q{'} . join( q{/}, @{ $opt->{path} } ) . "' => '$typeclass',\n";
        my $flavor = $type->get_flavor()
            || 'UNKNOWN'; 
        if ( $flavor eq 'sequence' ) {
            $txt .= "# atomic complex type (sequence)\n";
            $txt .= $type->to_typemap($opt). "\n";;
            $txt .= "# end atomic complex type (sequence)\n";
        }
        elsif ( $flavor eq 'all' ) {
            $txt .= "# atomic complex type (all)\n";
            $txt .= $type->to_typemap($opt). "\n";
            $txt .= "# end atomic complex type (all)\n";
        }
        else {
            warn "flavor $flavor in element " . $self->get_name() . "\n";
        }
    }
    pop @{ $opt->{ path } };

    return $txt;
}


sub to_class {
    my $self = shift;
    my $opt = shift;

my $template = <<'EOT';
package [% element_prefix %][% self.get_name %];
use strict;

use SOAP::WSDL::XSD::Typelib::Element;

[% IF (type = self.first_simpleType) %]
# <element name="[% self.get_name %]"><simpleType> definition
use SOAP::WSDL::XSD::Typelib::SimpleType;
use base qw(
    SOAP::WSDL::XSD::Typelib::Element
    SOAP::WSDL::XSD::Typelib::SimpleType
    [% type.flavor_class %]
    [% type.base_class($type_prefix) %]
);
[% ELSIF (ref_name = self.get_ref);
    split_name = ref_name.split(':');
    prefix = split_name.0;
    localname = split_name.1;
    ref_class = element_prefix _ localname;
%]    
# <element name="[% self.get_name %]" ref="[% ref_name %]"> definition
# use [% ref_class %];
use base qw(
    [% ref_class %]
);
[% ELSIF (type = self.first_complexType) %]
# atomic complexType
# <element name="[% self.get_name %]"><complexType> definition
use SOAP::WSDL::XSD::Typelib::ComplexType;
use base qw(
    SOAP::WSDL::XSD::Typelib::Element
    SOAP::WSDL::XSD::Typelib::ComplexType
);

[%      FOREACH element = type.get_element %]
my %[% element.get_name %]_of :ATTR(:get<[% element.get_name %]>);
[%      END %]

__PACKAGE__->_factory(
    [ qw([% FOREACH element = type.get_element %]
    [% element.get_name %]
    [% END %]) ],
    { 
      [% FOREACH element = type.get_element %] [% element.get_name %] => \%[% element.get_name %]_of, 
      [% END %]  
    },
    {
      [% FOREACH element = type.get_element;
        split_name = element.get_type.split(':');
        prefix = split_name.0;
        localname = split_name.1;
        IF nsmap.$prefix == 'http://www.w3.org/2001/XMLSchema' %]
        [% element.get_name %] => 'SOAP::WSDL::XSD::Typelib::Builtin::[% localname %]',
        [% ELSE %]
        [% element.get_name %] => '[% type_prefix %][% localname %]',
        [% END %]
      [% END %]
    }
);
[%# END complexType %]
[% ELSIF (type = self.get_type) %]
#
# <element name="[% self.get_name %]" type="[% self.get_type %]"/> definition
#
[%  split_name = self.get_type.split(':');
    prefix = split_name.0;
    localname = split_name.1;
    
    IF (nsmap.$prefix == 'http://www.w3.org/2001/XMLSchema');
        base_class = 'SOAP::WSDL::XSD::Typelib::Builtin::' _ localname ;
    ELSE;
        base_class = type_prefix _ localname;
    -%]

use [% base_class %];
[%  END  %]
use base qw(
    SOAP::WSDL::XSD::Typelib::Element
    [% base_class %]
);
[% END %]

sub get_xmlns { '[% self.get_targetNamespace %]' }

__PACKAGE__->__set_name('[% self.get_name %]');
__PACKAGE__->__set_nillable([% self.get_nillable %]);
__PACKAGE__->__set_minOccurs([% self.get_minOccurs %]);
__PACKAGE__->__set_maxOccurs([% self.get_maxOccurs %]);
__PACKAGE__->__set_ref('[% self.get_ref %]');

1;


__END__

[% MACRO pod BLOCK %]=pod[% END %]
[% MACRO cut BLOCK %]=cut[% END %]
[% MACRO head1 BLOCK %]=head1[% END %]
[% MACRO head2 BLOCK %]=head2[% END %]

[% pod %]

[% head1 %] NAME 

[% element_prefix %][% self.get_name %]

[% head1 %] SYNOPSIS

[% head1 %] DESCRIPTION

Type class for the XML element [% self.get_name %]. 

[% head1 %] PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY 
methods:

[%- IF (type = self.first_complexType);
      FOREACH element = type.get_element %]
 [% element.get_name -%]
[%      END;
END %]

[% head1 %] Object structure

[%- IF (type = self.first_complexType);
      FOREACH element = type.get_element;
        split_name = element.get_type.split(':');
        prefix = split_name.0;
        localname = split_name.1;
        IF nsmap.$prefix == 'http://www.w3.org/2001/XMLSchema' %]
        [% element.get_name %] => 'SOAP::WSDL::XSD::Typelib::Builtin::[% localname %]',        
        [% ELSE %]
        [% element.get_name %] => '[% type_prefix %]::[% localname %]',
        [% END; 
      END;
END %]

Structure as perl hash: 

 The object structure is displayed as hash below though this is not correct.
 Complex hash elements actually are objects of their corresponding classes 
 (look for classes of the same name in your typleib).
 new() will accept a hash structure like this, but transform it to a object 
 tree.

 [% structure %]

[% cut %]

EOT
    
    $self->SUPER::to_class($opt, $template);
}

1;


