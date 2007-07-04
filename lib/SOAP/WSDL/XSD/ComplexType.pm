package SOAP::WSDL::XSD::ComplexType;
use strict;
use warnings;
use Carp;
use Class::Std::Storable;
use Scalar::Util qw(blessed);
use base qw/SOAP::WSDL::Base/;
use Data::Dumper;

my %annotation_of   :ATTR(:name<annotation> :default<()>);
my %element_of      :ATTR(:name<element>    :default<()>);
my %flavor_of       :ATTR(:name<flavor>     :default<()>);
my %base_of         :ATTR(:name<base>       :default<()>);
my %itemType_of     :ATTR(:name<itemType>   :default<()>);
my %enumeration_of  :ATTR(:name<enumeration>   :default<()>);
my %abstract_of     :ATTR(:name<abstract>   :default<()>);
# is set to simpleContent/complexContent
my %content_Model_of    :ATTR(:name<contentModel>   :default<()>);

sub find_element {
    my ($self, @args) = @_;
    my @found_at = grep {
        $_->get_targetNamespace() eq $args[0] &&
        $_->get_name() eq $args[1]
    }
    @{ $element_of{ ident $self } };
    return $found_at[0];
}

sub push_element {
    my $self = shift;
    my $element = shift;
    if ($flavor_of{ ident $self } eq 'all')
    {
        $element->set_minOccurs(0) if not defined ($element->get_minOccurs);
        $element->set_maxOccurs(1) if not defined ($element->get_maxOccurs);
    }
    elsif ($flavor_of{ ident $self } eq 'sequence')
    {
        $element->set_minOccurs(1) if not defined ($element->get_minOccurs);
        $element->set_maxOccurs(1) if not defined ($element->get_maxOccurs);
    }
    push @{ $element_of{ ident $self } }, $element;
}

sub set_restriction {
    my $self = shift;
    my $element = shift;
    $flavor_of{ ident $self } = 'restriction';
    $base_of{ ident $self } = $element->{ Value };
}


sub init {
	my $self = shift;
	my @args = @_;
	$self->SUPER::init( @args );
}

sub serialize
{
    my ($self, $name, $value, $opt) = @_;

    $opt->{ indent } ||= q{};
    $opt->{ attributes } ||= [];
    my $flavor = $self->get_flavor();
    my $xml = ($opt->{ readable }) ? $opt->{ indent } : q{};    # add indentation


    if ( $opt->{ qualify } ) {
        $opt->{ attributes } = [ ' xmlns="' . $self->get_targetNamespace .'"' ];
        delete $opt->{ qualify };
    }      


    $xml .= join q{ } , "<$name" , @{ $opt->{ attributes } };
    delete $opt->{ attributes };                                        # don't propagate...
    
    if ( $opt->{ autotype }) {
      my $ns = $self->get_targetNamespace();
      my $prefix = $opt->{ namespace }->{ $ns }
        || die 'No prefix found for namespace '. $ns;
      $xml .= join q{}, " type=\"$prefix:", $self->get_name(), '" '
        if ($self->get_name() );
    }
    $xml .= '>';
    $xml .= "\n" if ( $opt->{ readable } );				# add linebreak
    if ( ($flavor eq "sequence") or ($flavor eq "all") )
    {
        $opt->{ indent } .= "\t";
        for my $element (@{ $self->get_element() }) {
            # might be list - listify
            $value = [ $value ] if not ref $value eq 'ARRAY';

            for my $single_value (@{ $value }) {
    		my $element_value;
	       	if (blessed $single_value) {
                    my $method = 'get_' . $element->get_name();
		    $element_value = $single_value->$method();
                }
    		else {
                    $element_value = $single_value->{ $element->get_name() };
                }
    		$element_value = [ $element_value ]
                    if not ref $element_value eq 'ARRAY';

    		$xml .= join q{}
                  , map { $element->serialize( undef, $_, $opt ) }
	              @{ $element_value };
            }
        }
      $opt->{ indent } =~s/\t$//;
    }
    else {
      die "sorry, we just handle all and sequence types yet...";
    }
    $xml .= $opt->{ indent } if ( $opt->{ readable } ); # add indentation
    $xml .= '</' . $name . '>';
    $xml .= "\n" if ($opt->{ readable } );              # add linebreak
    return $xml;
}

sub explain
{
	my ($self, $opt, $name ) = @_;
	my $flavor = $self->get_flavor();
	my $xml = '';
	$xml .= $opt->{ indent } if ($opt->{ readable });	# add indentation
	$xml .= q{'} . $name . q{' => };

	return q{} if not $flavor;	 						# empty complexType

	if ( ($flavor eq "sequence") or ($flavor eq "all") )
	{
		$xml .= "{\n";
		$opt->{ indent } .= "\t";
        $xml .= join q{}, map { $_->explain( $opt ) }
            @{ $self->get_element() };
		$opt->{ indent } =~s/\t$//;                     # step back
		$xml .= $opt->{ indent } . "},\n";
	}
	elsif ($flavor eq "complexContent")
	{

	}
	elsif ($flavor eq "simpleContent")
	{

	}
	else
	{
		warn "unknown complexType definition $flavor";
	}
	$xml .= "\n" if ($opt->{ readable } );				# add linebreak
	return $xml;
}

sub to_typemap {
    my ($self, $opt, $name ) = @_;
    my $flavor = $self->get_flavor();
    my $txt;
    return q{} if not $flavor;                                                         # empty complexType

    my %nsmap = reverse %{ $opt->{ wsdl }->get_xmlns() };

    if ( ($flavor eq "sequence") or ($flavor eq "all") )
    {
        for my $element (@{ $self->get_element() }) {
            $txt .= $element->to_typemap( $opt );
        }
    }
    return $txt;
}

sub toClass {
    my $self = shift;
    my $opt = shift;

my $template = <<'EOT';
package [% class_prefix %]::[% self.get_name %];
use strict;
use Class::Std::Storable;
use SOAP::WSDL::XSD::Typelib::ComplexType;
use base qw(
    SOAP::WSDL::XSD::Typelib::ComplexType
);

[% FOREACH element=self.get_element -%]
my %[% element.get_name %]_of :ATTR(:get<[% element.get_name %]>);
[% END %]

__PACKAGE__->_factory(
    [ qw([% FOREACH element=self.get_element -%] 
    [% element.get_name %] 
    [% END %]) ],
    { 
      [% FOREACH element=self.get_element %] [% element.get_name %] => \%[% element.get_name %]_of, 
      [% END %]  
    },
    {
      [%- FOREACH element=self.get_element;
        split_name = element.get_type.split(':');
        prefix = split_name.0;
        localname = split_name.1;
            IF nsmap.$prefix == 'http://www.w3.org/2001/XMLSchema' -%]
      [% element.get_name %] => 'SOAP::WSDL::XSD::Typelib::Builtin::[% localname %]',
      [%    ELSE %]
      [% element.get_name %] => '[% class_prefix %]::[% localname %]',
      [%-    END;
      END %]
    }
);

sub get_xmlns { '[% self.get_targetNamespace %]' }

1;
EOT

    $opt->{ base_path } ||= '.';

    require Template;
    my $tt = Template->new(
        RELATIVE => 1,
    );
    my $code = $tt->process( \$template, {
            class_prefix => $opt->{ prefix },
            self => $self, 
            nsmap => { reverse %{ $opt->{ wsdl }->get_xmlns() } }, 
        }, 
        $opt->{ output },       
    ) or die $tt->error();
}

sub _check_value {
	my $self = shift;
}
1;

=pod

=head1 Bugs and limitations

=over

=item * attribute definitions

Attribute definitions are ignored

=item * abstract, block, final, mixed

Handling of these attribute is not implemented yet.

=item * simpleContent, complexContent, extension, restriction, group, choice

Handling of these child elements is not implemented yet

=item * explain may produce erroneous results

=back

=cut
