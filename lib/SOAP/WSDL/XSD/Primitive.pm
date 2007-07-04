package SOAP::WSDL::XSD::Primitive;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::Base);
use Data::Dumper;

sub serialize
{
	my ($self, $name, $value, $opt) = @_;
	my $xml;
	$opt->{ indent } ||= "";
        $opt->{ attributes } ||= [];
        
	$xml .= $opt->{ indent } if ($opt->{ readable });
	$xml .= '<' . join ' ', $name, @{ $opt->{ attributes } };
	if ( $opt->{ autotype })
	{
		my $ns = $self->get_targetNamespace();
		my $prefix = $opt->{ namespace }->{ $ns }
			|| die 'No prefix found for namespace '. $ns;
		$xml .= ' type="' . $prefix . ':'
			. $self->get_name() . '"' if ($self->get_name() );
	}

	if (defined $value)
	{
		$xml .= '>';
		$xml .= "$value";
		$xml .= '</' . $name . '>' ;
	}
	else
	{
		$xml .= '/>';
	}
	$xml .= "\n" if ($opt->{ readable });
	return $xml;
}

sub explain
{
	my ($self, $opt, $name ) = @_;
	my $perl;
	$opt->{ indent } ||= "";
	$perl .= $opt->{ indent } if ($opt->{ readable });

	$perl .= q{'} . $name . q{' => $someValue };
	$perl .= "\n" if ($opt->{ readable });
	return $perl;
}

sub toClass {
    warn "# primitive";
}
1;
