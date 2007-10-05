package SOAP::WSDL::Generator::Template::XSD;
use strict;
use Template;
use Class::Std::Storable;
use File::Basename;
use File::Spec;

use SOAP::WSDL::Generator::Visitor::Typemap;
use SOAP::WSDL::Generator::Visitor::Typelib;
use base qw(SOAP::WSDL::Generator::Template);

my %output_of :ATTR(:name<output> :default<()>);

sub BUILD {
    my ($self, $ident, $arg_ref) = @_;
    $self->set_EVAL_PERL(1);
    $self->set_RECURSION(1);
    $self->set_INCLUDE_PATH( exists $arg_ref->{INCLUDE_PATH}
        ? $arg_ref->{INCLUDE_PATH}
        : File::Spec->rel2abs( dirname __FILE__  ). '/XSD/'
    );
}

sub generate_typelib {
    my ($self) = @_;
    
    # $output_of{ ident $self } = "";
    
    my @schema = @{ $self->get_definitions()->first_types()->get_schema() };
    for my $type (map { @{ $_->get_type() } , @{ $_->get_element() } } @schema[1..$#schema] ) {
        $type->_accept( $self );
    }
    
    # return $output_of{ ident $self };
    
}

sub generate_interface {
    my $self = shift;
    my $ident = ident $self;
    my $arg_ref = shift;
    my $tt = $self->get_tt();
    for my $service (@{ $self->get_definitions->get_service }) {
        for my $port (@{ $service->get_port() }) { 
            # Skip ports without (known) address
            next if not $port->first_address;
            next if not $port->first_address->isa('SOAP::WSDL::SOAP::Address');

            my $output = $arg_ref->{ output } 
                ? $arg_ref->{ output } 
                : $self->_generate_filename( $self->get_interface_prefix(), $service->get_name(), $port->get_name ); 

            $self->_process('Interface.tt', 
            {
                service => $service,
                port => $port,
                NO_POD => $arg_ref->{ NO_POD } ? 1 : 0 ,
            },
            $output);
        }
    }
}

sub generate_typemap {
    my ($self, $arg_ref) = @_;
    
    my $visitor = SOAP::WSDL::Generator::Visitor::Typemap->new({
        type_prefix => $self->get_type_prefix(),
        element_prefix => $self->get_element_prefix(),
        definitions => $self->get_definitions(),
        typemap => {
            'Fault' => 'SOAP::WSDL::SOAP::Typelib::Fault11',
            'Fault/faultcode' => 'SOAP::WSDL::XSD::Typelib::Builtin::anyURI',
            'Fault/faultactor' => 'SOAP::WSDL::XSD::Typelib::Builtin::TOKEN',
            'Fault/faultstring' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
            'Fault/detail' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',           
        }
    });
    for my $service (@{ $self->get_definitions->get_service }) {
            $visitor->visit_Service( $service );
            my $output = $arg_ref->{ output } 
                ? $arg_ref->{ output } 
                : $self->_generate_filename( $self->get_typemap_prefix(), $service->get_name() ); 
            $self->_process('Typemap.tt', 
            {
                service => $service,
                typemap => $visitor->get_typemap(),
                NO_POD => $arg_ref->{ NO_POD } ? 1 : 0 ,
            },
            $output);
    }
}

sub _generate_filename :PRIVATE {
    my ($self, @parts) = @_;
    my $name = join '::', @parts;
    $name =~s{ \. }{::}xmsg;
    $name =~s{ :: }{/}xmsg;
    return "$name.pm";
}

sub visit_XSD_Element {
    my ($self, $element) = @_;
    my $output = defined $output_of{ ident $self } 
        ? $output_of{ ident $self }
        : $self->_generate_filename( $self->get_element_prefix(), $element->get_name() );
    $self->_process('element.tt', { element => $element } , $output);
}

sub visit_XSD_SimpleType {
    my ($self, $type) = @_;
    my $output = defined $output_of{ ident $self } 
        ? $output_of{ ident $self }
        : $self->_generate_filename( $self->get_type_prefix(), $type->get_name() );
    $self->_process('simpleType.tt', { simpleType => $type } , $output);
}

sub visit_XSD_ComplexType {
    my ($self, $type) = @_;
    my $output = defined $output_of{ ident $self } 
        ? $output_of{ ident $self }
        : $self->_generate_filename( $self->get_type_prefix(), $type->get_name() );
    $self->_process('complexType.tt', { complexType => $type } , $output);
}

1;