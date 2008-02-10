package SOAP::WSDL::TypeLookup;
use strict;
use warnings;

our $VERSION=q{2.00_31};

my %TYPES = (
    # wsdl:
    'http://schemas.xmlsoap.org/wsdl/' => {
        'import' => {
            type => 'HANDLER',
            method => 'wsdl_import',
        },
        binding => {
            type => 'CLASS',
            class => 'SOAP::WSDL::Binding',
        },
        definitions => {
            type => 'CLASS',
            class => 'SOAP::WSDL::Definitions',
        },
        portType => {
            type => 'CLASS',
            class => 'SOAP::WSDL::PortType',
        },
        message => {
            type => 'CLASS',
            class => 'SOAP::WSDL::Message',
        },
        part => {
            type => 'CLASS',
            class => 'SOAP::WSDL::Part',
        },
        service => {
            type => 'CLASS',
            class => 'SOAP::WSDL::Service',
        },
        port => {
            type => 'CLASS',
            class => 'SOAP::WSDL::Port',
        },
        operation => {
            type => 'CLASS',
            class => 'SOAP::WSDL::Operation',
        },
        input => {
            type => 'CLASS',
            class => 'SOAP::WSDL::OpMessage',
        },
        output => {
            type => 'CLASS',
            class => 'SOAP::WSDL::OpMessage',
        },
        fault => {
            type => 'CLASS',
            class => 'SOAP::WSDL::OpMessage',
        },
        types => {
            type => 'CLASS',
            class => 'SOAP::WSDL::Types',
        },
        documentation => {
            type => 'CONTENT',
            method => 'set_documentation',
        }
    },
    # soap:
    'http://schemas.xmlsoap.org/wsdl/soap/' => {
        operation => {
            type => 'CLASS',
            class => 'SOAP::WSDL::SOAP::Operation',
        },
        binding => {
            type => 'PARENT',
        },
        body => {
            type => 'CLASS',
            class => 'SOAP::WSDL::SOAP::Body',
        },
        header => {
            type => 'CLASS',
            class => 'SOAP::WSDL::SOAP::Header',
        },
        address => {
            type => 'CLASS',
            class => 'SOAP::WSDL::SOAP::Address',
        }
    },
    'http://www.w3.org/2001/XMLSchema' => {
        'import' => {
            type => 'HANDLER',
            method => 'xml_schema_import',
        },
        schema => {
            type => 'CLASS',
            class => 'SOAP::WSDL::XSD::Schema',
        },
        attribute => {
            type => 'CLASS',
            class => 'SOAP::WSDL::XSD::Attribute'      # not implemented yet
        },
        attributeGroup => {
            type => 'SKIP',     # not implemented yet
        },
        key => {
            type => 'SKIP',     # not implemented yet
        },
        keyref => {
            type => 'SKIP',     # not implemented yet
        },
        unique => {
            type => 'SKIP',     # not implemented yet
        },
        notation => {
            type => 'SKIP',     # not implemented yet
        },
        annotation => {
            type => 'SKIP',     # not implemented yet
        },
        appinfo => {
            type => 'SKIP',     # not implemented yet
        },
        description => {
            type => 'SKIP',     # not implemented yet
        },
        element => {
            type => 'CLASS',
            class => 'SOAP::WSDL::XSD::Element',
        },
        simpleType => {
            type => 'CLASS',
            class => 'SOAP::WSDL::XSD::SimpleType',
        },
        complexType => {
            type => 'CLASS',
            class => 'SOAP::WSDL::XSD::ComplexType',
        },
        simpleContent => {
            type => 'METHOD',
            method => 'set_contentModel',
            value => 'simpleContent'
        },
        complexContent => {
            type => 'METHOD',
            method => 'set_contentModel',
            value => 'complexContent'
        },
        restriction => {
            type => 'METHOD',
            method => 'set_restriction',
        },
        extension => {
            type => 'METHOD',
            method => 'set_extension',
        },
        list => {
            type => 'METHOD',
            method => 'set_list',
        },
        union => {
            type => 'METHOD',
            method => 'set_union',
        },
        enumeration => {
            type => 'SKIP',
            # method => 'push_enumeration',
        },
        group => {
            type => 'METHOD',
            method => 'set_flavor',
            value => 'group',
        },
        all => {
            type => 'METHOD',
            method => 'set_flavor',
            value => 'all',
        },
        choice => {
            type => 'METHOD',
            method => 'set_flavor',
            value => 'choice',
        },
        sequence => {
            type => 'METHOD',
            method => 'set_flavor',
            value => 'sequence',
        },
    },
);

sub lookup {
    my $self = shift;
    my $namespace = shift  || 'http://schemas.xmlsoap.org/wsdl/';
    my $name = shift;
    return $TYPES{ $namespace }->{ $name };
}

1;