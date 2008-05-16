package SOAP::WSDL::Generator::Template::XSD;
use strict;
use Template;
use Class::Std::Fast::Storable;
use File::Basename;
use File::Spec;

use version; our $VERSION = qv('2.00.02');

use SOAP::WSDL::Generator::Visitor::Typemap;
use SOAP::WSDL::Generator::Visitor::Typelib;
use SOAP::WSDL::Generator::Template::Plugin::XSD;
use base qw(SOAP::WSDL::Generator::Template);

my %output_of                   :ATTR(:name<output>         :default<()>);
my %typemap_of                  :ATTR(:name<typemap>        :default<({})>);

sub BUILD {
    my ($self, $ident, $arg_ref) = @_;
    $self->set_EVAL_PERL(1);
    $self->set_RECURSION(1);
    $self->set_INCLUDE_PATH( exists $arg_ref->{INCLUDE_PATH}
        ? $arg_ref->{INCLUDE_PATH}
        : do {
            # ignore uninitialized warnings - File::Spec warns about
            # uninitialized values, probably because we have no filename
            local $SIG{__WARN__} = sub {
                return if ($_[0]=~m{\buninitialized\b});
                CORE::warn @_;
            };

            # makeup path for the OS we're running on
            my ($volume, $dir, $file) = File::Spec->splitpath(
                File::Spec->rel2abs( dirname __FILE__  )
            );
            $dir = File::Spec->catdir($dir, $file, 'XSD');
            # return path put together...
            my $path = File::Spec->catpath( $volume, $dir , q{});

            # Fixup path for windows - / works fine, \ does
            # not...
            if ( eval { &Win32::BuildNumber } ) {
                $path =~s{\\}{/}g;
            }
            $path;
        }
    );
}

# construct object on call to allow late binding of prefix_resolver class
# and namespace maps (not used yet)
sub get_name_resolver {
    my $self = shift;
    return SOAP::WSDL::Generator::Template::Plugin::XSD->new({
        prefix_resolver => $self->get_prefix_resolver_class()->new({
            namespace_prefix_map => {
                'http://www.w3.org/2001/XMLSchema' => 'SOAP::WSDL::XSD::Typelib::Builtin',
            },
            namespace_map => {
            },
            prefix => {
                attribute   =>  $self->get_attribute_prefix,
                interface   =>  $self->get_interface_prefix,
                element     =>  $self->get_element_prefix,
                server      =>  $self->get_server_prefix,
                type        =>  $self->get_type_prefix,
                typemap     =>  $self->get_typemap_prefix,
            }
        })
    });
}

sub generate {
    my $self = shift;
    my $opt = shift;
    $self->generate_typelib( $opt );
    $self->generate_typemap( $opt );
}

sub generate_typelib {
    my ($self, $arg_ref) = @_;
    my @schema = exists $arg_ref->{ schema }
        ? @{ $arg_ref->{schema} }
        : @{ $self->get_definitions()->first_types()->get_schema() };
    for my $type (map {
            @{ $_->get_type() } ,
            @{ $_->get_element() },
            @{ $_->get_attribute() }
        } @schema[1..$#schema] ) {
        $type->_accept( $self );
    }
    return;
}

sub _generate_interface {
    my $self = shift;
    my $arg_ref = shift;
    my $template_name = delete $arg_ref->{ template_name };
    my $name_method = delete $arg_ref->{ name_method };
    for my $service (@{ $self->get_definitions->get_service }) {
        for my $port (@{ $service->get_port() }) {
            # Skip ports without (known) address
            next if not $port->first_address;
            next if not $port->first_address->isa('SOAP::WSDL::SOAP::Address');

            my $port_name = $port->get_name;
            $port_name =~s{ \A .+\. }{}xms;
            my $output = $arg_ref->{ output }
                ? $arg_ref->{ output }
                : $self->_generate_filename(
                    $self->get_name_resolver()->can($name_method)->(
                        $self->get_name_resolver(),
                        $service,
                        $port,
                ));
            print "Creating interface class $output\n";

            $self->_process($template_name,
            {
                service => $service,
                port => $port,
                NO_POD => $arg_ref->{ NO_POD } ? 1 : 0 ,
             },
            $output, binmode => ':utf8');
        }
    }
}

sub generate_server {
    my ($self, $arg_ref) = @_;
    $arg_ref->{ template_name } = 'Server.tt';
    $arg_ref->{ name_method } = 'create_server_name';
    $self->_generate_interface($arg_ref);
}

sub generate_client {
    my ($self, $arg_ref) = @_;
    $arg_ref->{ template_name } = 'Interface.tt';
    $arg_ref->{ name_method } = 'create_interface_name';
    $self->_generate_interface($arg_ref);
}
sub generate_interface;
*generate_interface = \&generate_client;

sub generate_typemap {
    my ($self, $arg_ref) = @_;

    my $visitor = SOAP::WSDL::Generator::Visitor::Typemap->new({
        type_prefix => $self->get_type_prefix(),
        element_prefix => $self->get_element_prefix(),
        definitions => $self->get_definitions(),
        typemap => {
            'Fault' => 'SOAP::WSDL::SOAP::Typelib::Fault11',
            'Fault/faultcode' => 'SOAP::WSDL::XSD::Typelib::Builtin::anyURI',
            'Fault/faultactor' => 'SOAP::WSDL::XSD::Typelib::Builtin::token',
            'Fault/faultstring' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
            'Fault/detail' => 'SOAP::WSDL::XSD::Typelib::Builtin::string',
            %{ $typemap_of{ident $self }},
        },
        resolver => $self->get_name_resolver(),
    });

    use SOAP::WSDL::Generator::Iterator::WSDL11;
    my $iterator  = SOAP::WSDL::Generator::Iterator::WSDL11->new({
        definitions => $self->get_definitions });

    for my $service (@{ $self->get_definitions->get_service }) {
            $iterator->init({ node => $service });
            while (my $node = $iterator->get_next()) {
                $node->_accept( $visitor );
            }

            my $output = $arg_ref->{ output }
                ? $arg_ref->{ output }
                : $self->_generate_filename( $self->get_name_resolver()->create_typemap_name($service) );
            print "Creating typemap class $output\n";
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
    my ($self, $name) = @_;
    $name =~s{ \. }{::}xmsg;
    $name =~s{ \- }{_}xmsg;
    $name =~s{ :: }{/}xmsg;
    return "$name.pm";
}

sub visit_XSD_Attribute {
    my ($self, $attribute) = @_;
    my $output = defined $output_of{ ident $self }
        ? $output_of{ ident $self }
        : $self->_generate_filename( $self->get_name_resolver()->create_xsd_name($attribute) );
    $self->_process('attribute.tt', { attribute => $attribute } , $output);
}

sub visit_XSD_Element {
    my ($self, $element) = @_;
    my $output = defined $output_of{ ident $self }
        ? $output_of{ ident $self }
        : $self->_generate_filename( $self->get_name_resolver()->create_xsd_name($element) );
    $self->_process('element.tt', { element => $element } , $output);
}

sub visit_XSD_SimpleType {
    my ($self, $type) = @_;
    my $output = defined $output_of{ ident $self }
        ? $output_of{ ident $self }
        : $self->_generate_filename( $self->get_name_resolver()->create_xsd_name($type) );
    $self->_process('simpleType.tt', { simpleType => $type } , $output);
}

sub visit_XSD_ComplexType {
    my ($self, $type) = @_;
    my $output = defined $output_of{ ident $self }
        ? $output_of{ ident $self }
        : $self->_generate_filename( $self->get_name_resolver()->create_xsd_name($type) );
    $self->_process('complexType.tt', { complexType => $type } , $output);
}

1;
