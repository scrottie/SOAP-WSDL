package SOAP::WSDL::PortType;
use strict;
use warnings;
use Class::Std::Fast::Storable;
use base qw(SOAP::WSDL::Base);

use version; our $VERSION = qv('2.00.01');

my %operation_of :ATTR(:name<operation> :default<()>);

my %attributes_of :ATTR();

%attributes_of = (
    operation => \%operation_of,
);

# Function factory - we could be writing this method for all %attribute
# keys, too, but that's just C&P (eehm, Copy & Paste...)
foreach my $method(keys %attributes_of ) {
    no strict qw(refs);             ## no critic ProhibitNoStrict

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

1;
