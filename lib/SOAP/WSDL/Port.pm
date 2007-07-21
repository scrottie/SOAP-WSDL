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
    $opt->{ wsdl } || die 'required attribute wsdl missing'; 

    my $binding = $opt->{ wsdl }->find_binding(
        $opt->{ wsdl }->_expand( $self->get_binding() )
    ) or die 'binding ' . $self->get_binding()  . ' not found !';


    my $txt = "=head2 Service information:\n\n"
        . " Port name: " . $self->get_name() . "\n"
        . " Binding: " . $self->get_binding() ."\n"
        . " Location: " . $self->get_location() ."\n"
        . $binding->explain($opt);

    return $txt;
}

sub to_typemap {
    my $self = shift;
    my $opt = shift;

    # skip non-SOAP ports (could be http, email or whatever...)
    return q{} if not $location_of{ ident $self };

    my $binding = $opt->{ wsdl }->find_binding(
        $opt->{wsdl}->_expand( $binding_of{ ident $self } )
    ) or die 'binding ' . $binding_of{ ident $self } .' not found!';

    return $binding->to_typemap($opt);
}
1;
