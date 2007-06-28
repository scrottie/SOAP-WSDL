package SOAP::WSDL::Definitions;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::Base);

my %types_of    :ATTR(:name<types>      :default<[]>);
my %message_of  :ATTR(:name<message>    :default<()>);
my %portType_of :ATTR(:name<portType>   :default<()>);
my %binding_of  :ATTR(:name<binding>    :default<()>);
my %service_of  :ATTR(:name<service>    :default<()>);

my %namespace_of    :ATTR(:name<namespace>      :default<()>);

my %attributes_of :ATTR();

%attributes_of = (
    binding => \%binding_of,
    message => \%message_of,
    portType => \%portType_of,
    service => \%service_of,
);

# Function factory - we could be writing this method for all %attribute
# keys, too, but that's just C&P (eehm, Copy & Paste...)
foreach my $method(keys %attributes_of ) {
    no strict qw/refs/;

    # ... btw, we mean this method here...
    *{ "find_$method" } = sub {
        my ($self, @args) = @_;
        my @found_at = grep {
            $_->get_targetNamespace() eq $args[0] &&
            $_->get_name() eq $args[1]
        }
        @{ $attributes_of{ $method }->{ ident $self } };
        return $found_at[0];
    };
}

sub explain {
	my $self = shift;
	my $opt = shift;
	my $txt = '';
	foreach my $service (@{ $self->get_service() })
	{
		$txt .= $service->explain( $opt );
		$txt .= "\n";
	}
	return $txt;
}

sub to_typemap {
    my $self = shift;
    my $opt = shift;
    $opt->{ wsdl } ||= $self;
    $opt->{ prefix } ||= q{};
    return  join "\n",
        map { $_->to_typemap( $opt ) } @{ $service_of{ ident $self } };
}

1;
