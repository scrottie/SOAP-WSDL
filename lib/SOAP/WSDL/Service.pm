package SOAP::WSDL::Service;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::Base);

my %port_of    :ATTR(:name<port>   :default<()>);

sub explain {
	my $self = shift;
	my $opt = shift;
	my $txt ="=head1 Service name\n\n" . $self->get_name() . "\n\n";
	foreach my $port (@{ $self->get_port() } )
	{
		$txt .= $port->explain( $opt );
	}
	return $txt;
}

sub to_typemap {
    my $self = shift;
    my $opt = shift;
    return  join "\n",
        map { $_->to_typemap( $opt ) } @{ $port_of{ ident $self } };
}

1;
