package SOAP::WSDL::Generator::Template;
use strict;
use Template;
use Class::Std::Storable;

our $VERSION='2.00_17';

my %tt_of               :ATTR(:get<tt>);
my %definitions_of      :ATTR(:name<definitions>    :default<()>);
my %interface_prefix_of :ATTR(:name<interface_prefix> :default<MyInterfaces>);
my %typemap_prefix_of   :ATTR(:name<typemap_prefix> :default<MyTypemaps>);
my %type_prefix_of      :ATTR(:name<type_prefix>    :default<MyTypes>);
my %element_prefix_of   :ATTR(:name<element_prefix> :default<MyElements>);
my %INCLUDE_PATH_of     :ATTR(:name<INCLUDE_PATH>   :default<()>);
my %EVAL_PERL_of        :ATTR(:name<EVAL_PERL>      :default<0>);
my %RECURSION_of        :ATTR(:name<RECURSION>      :default<0>);
my %OUTPUT_PATH_of      :ATTR(:name<OUTPUT_PATH>    :default<.>);

sub START {
    my ($self, $ident, $arg_ref) = @_;
    $tt_of{$ident} = Template->new( 
        DEBUG => 1,
        EVAL_PERL => $EVAL_PERL_of{ $ident },
        RECURSION => $RECURSION_of{ $ident },
        INCLUDE_PATH => $INCLUDE_PATH_of{ $ident },
        OUTPUT_PATH => $OUTPUT_PATH_of{ $ident },
    );
}

sub _process :PROTECTED {
    my ($self, $template, $arg_ref, $output) = @_;
    my $tt = $self->get_tt();
    $tt->process( $template, 
    { 
        definitions => $self->get_definitions,
        interface_prefix => $self->get_interface_prefix,
        type_prefix => $self->get_type_prefix,
        typemap_prefix => $self->get_typemap_prefix,
        TYPE_PREFIX => $self->get_type_prefix,
        element_prefix => $self->get_element_prefix,
        NO_POD => delete $arg_ref->{ NO_POD } ? 1 : 0 ,
        %{ $arg_ref }
    }, 
    $output)
        or die $tt->error();
    
}

1;