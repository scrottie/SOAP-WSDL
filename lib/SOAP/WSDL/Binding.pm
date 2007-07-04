package SOAP::WSDL::Binding;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::Base);

my %operation_of    :ATTR(:name<operation> :default<()>);
my %type_of         :ATTR(:name<type> :default<()>);
my %transport_of    :ATTR(:name<transport> :default<()>);
my %style_of        :ATTR(:name<style> :default<()>);

sub explain {
	my $self = shift;
	my $opt = shift;
    my $name = $self->get_name();

    my %ns_map = reverse %{ $opt->{ wsdl }->get_xmlns() };

    my ($prefix, $localname) = split /:/ , $self->get_type();
    my $portType = $opt->{ wsdl }->find_portType(
        $ns_map{ $prefix }, $localname
    ) or die "portType $prefix:$localname not found !";


	my $txt = <<"EOT";

=head2 Binding name:  $name

=over

=item * Style $style_of{ ident $self }

=item * Transport $transport_of{ ident $self }

=back

=head3 Operations

EOT

	foreach my $operation (@{ $self->get_operation() })
	{
        my $operation_name = $operation->get_name();
        my $operation_style = $operation->get_style() || q{};

        my $port_operation = $portType->find_operation( $ns_map{ $prefix },
              $operation->get_name() )
              or die "operation not found:" . $operation->get_name();

        # TODO rename lexical $input to "message"
        my $input_message = do {
            my $input = $port_operation->first_input();
            $input ? $input->explain($opt) : q{};
        };
        my $output_message = do {
            my $input = $port_operation->first_output();
            $input ? $input->explain($opt) : q{};
        };
        my $fault_message = do {
            my $input = $port_operation->first_fault();
            $input ? $input->explain($opt) : q{};
        };

        $txt .= <<"EOT";
        
=over

=item * $operation_name

=over 8

=item * Style: $operation_style

=item * Input Message:

$input_message

=item * Output Message:

$output_message

=item * Fault:

$fault_message

=back

=back

EOT
	}

	return $txt;
}

sub to_typemap {
    my ($self, $opt) = @_;
    my $name = $self->get_name();
    my %ns_map = reverse %{ $opt->{ wsdl }->get_xmlns() };
    my ($prefix, $localname) = split /:/ , $self->get_type();
    my $portType = $opt->{ wsdl }->find_portType(
        $ns_map{ $prefix }, $localname
    ) or die "portType $prefix:$localname not found !";
    my $txt = q{};
    foreach my $operation (@{ $self->get_operation() })
    {
        my $operation_name = $operation->get_name();
        my $operation_style = $operation->get_style() || q{};

        my $port_operation = $portType->find_operation( $ns_map{ $prefix },
              $operation->get_name() )
              or die "operation not found:" . $operation->get_name();

        # TODO rename lexical $input to "message"
        $txt .= do {
            my $input = $port_operation->first_input();
            $input ? $input->to_typemap($opt) : q{};
        };
        $txt .= do {
            my $input = $port_operation->first_output();
            $input ? $input->to_typemap($opt) : q{};
        };
        $txt .= do {
            my $input = $port_operation->first_fault();
            $input ? $input->to_typemap($opt) : q{};
        };
    }
    return $txt;
}

1;
