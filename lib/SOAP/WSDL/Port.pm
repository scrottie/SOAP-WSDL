package SOAP::WSDL::Port;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::Base);

my %binding_of :ATTR(:name<binding> :default<()>);
my %location_of :ATTR(:name<location> :default<()>);

sub explain {
	my $self = shift;
	my $opt = shift;
	my $txt =
        "=head2 Port name: " . $self->get_name() . "\n\n"
        . "=over\n\n"
    	. "=item * Binding: " . $self->get_binding() ."\n\n"
	    . "=item * Location: " . $self->get_location() ."\n\n"
        . "=back\n\n";
#		if ( $self->location() );

	my %ns_map = reverse %{ $opt->{ namespace } };

	my ($prefix, $localname) = split /:/ , $self->get_binding();
	my $binding = $opt->{ wsdl }->find_binding(
		$ns_map{ $prefix }, $localname
	) or die "binding $prefix:$localname not found !";

	$txt .= $binding->explain($opt);

	return $txt;
}

sub to_typemap {

    my $self = shift;
    my $opt = shift;
    my %ns_map = reverse %{ $opt->{ wsdl }->get_xmlns() };

    my ($prefix, $localname) = split /:/ , $self->get_binding();
    my $binding = $opt->{ wsdl }->find_binding(
            $ns_map{ $prefix }, $localname
    ) or die "binding $prefix:$localname not found !";

    return $binding->to_typemap($opt);
}
1;
