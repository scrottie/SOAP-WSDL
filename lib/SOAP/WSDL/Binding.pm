package SOAP::WSDL::Binding;
use strict;
use warnings;
use Class::Std::Storable;
use List::Util qw(first);
use base qw(SOAP::WSDL::Base);

my %operation_of    :ATTR(:name<operation> :default<()>);
my %type_of         :ATTR(:name<type> :default<()>);
my %transport_of    :ATTR(:name<transport> :default<()>);
my %style_of        :ATTR(:name<style> :default<()>);


sub explain {
    my $self = shift;
    my $opt = shift;
    my $name = $self->get_name();

    die 'required atribute wsdl missing' if not $opt->{ wsdl };

    my $portType = $opt->{ wsdl }->find_portType(
        $opt->{ wsdl }->_expand( $self->get_type() )
    ) or die 'portType not found: ' . $self->get_type();

    my $txt = <<"EOT";

=head2 SOAP Operations 

B<Note:>

 Input, output and fault messages are stated as perl hash refs. 
 
 These are only for informational purposes - the actual implementation 
 normally uses object trees, not hash refs, though the input messages 
 may be passed to the respective methods as hash refs and will be 
 converted to object trees automatically.

EOT

    foreach my $operation (@{ $self->get_operation() }) {

        my $operation_name = $operation->get_name();
        my $operation_style = $operation->get_style() || q{};

        my $port_operation = first { $_->get_name eq $operation_name } 
            @{ $portType->get_operation() }             
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

=head3 $operation_name

B<Input Message:>

$input_message

B<Output Message:>

$output_message

B<Fault:>

$fault_message

EOT
    }

    return $txt;
}

sub to_typemap {
    my ($self, $opt) = @_;
    my $name = $self->get_name();

    my $portType = $opt->{ wsdl }->find_portType(
        $opt->{ wsdl }->_expand( $self->get_type )
    ) or die 'portType not found: ' . $self->get_type;

    my $txt = q{};
    foreach my $operation (@{ $self->get_operation() })
    {
        my $operation_name = $operation->get_name();
        my $operation_style = $operation->get_style() || q{};

        my ($port_operation) = grep { $_->get_name eq $operation_name } 
            @{ $portType->get_operation() }             
                or die "operation not found:" . $operation->get_name();

        no strict qw(refs);
        $txt .= join q{},
            map { 
                my $message = $port_operation->$_;
                $message 
                    ? $message->to_typemap($opt) 
                    : q{}
            } qw(first_input first_output first_fault);
    }
    return $txt;
}

1;
