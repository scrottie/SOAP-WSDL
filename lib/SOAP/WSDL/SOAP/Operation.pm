package SOAP::WSDL::SOAP::Operation;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::Base);

my %style_of :ATTR(:name<style> :default<()>);
my %soapAction_of :ATTR(:name<soapAction> :default<()>);

sub explain {
	my $self = shift;
	my $opt = shift;
	my $txt = '';
	$opt->{ indent } ||= '';

	$txt .= $opt->{ indent } . "soapAction: " . $self->soapAction() . "\n"
		if ( $self->soapAction() );

	return $txt;
}

1;
