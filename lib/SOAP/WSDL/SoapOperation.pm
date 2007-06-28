package SOAP::WSDL::SoapOperation;
use Class::Std::Storable;
use base qw(SOAP::WSDL::Base);

my %input_of :ATTR(:name<input> :default<()>);
my %output_of :ATTR(:name<output> :default<()>);
my %fault_of :ATTR(:name<fault> :default<()>);
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
