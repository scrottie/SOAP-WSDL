#!/usr/bin/perl -w
package SOAP::WSDL::Serializer::SOAP11;
use strict;
use warnings;
use Class::Std::Storable;

our $VERSION='2.00_13';

my $SOAP_NS = 'http://schemas.xmlsoap.org/soap/envelope/';
my $XML_INSTANCE_NS = 'http://www.w3.org/2001/XMLSchema-instance';

sub serialize {
    my ($self, $args_of_ref) = @_;
    
    my $opt = $args_of_ref->{ options };   

    if (not $opt->{ namespace }->{ $SOAP_NS })
    {
        $opt->{ namespace }->{ $SOAP_NS } = 'SOAP-ENV';
    }

    if (not $opt->{ namespace }->{ $XML_INSTANCE_NS })
    {
        $opt->{ namespace }->{ $XML_INSTANCE_NS } = 'xsi';
    }

    my $soap_prefix = $opt->{ namespace }->{ $SOAP_NS };

    # envelope start with namespaces
    my $xml = "<$soap_prefix\:Envelope ";

    while (my ($uri, $prefix) = each %{ $opt->{ namespace } })
    {
        $xml .= "\n\t" if ($opt->{'readable'});
        $xml .= "xmlns:$prefix=\"$uri\" ";
    }

    # TODO insert encoding
    $xml.='>';
    $xml .= $self->serialize_header($args_of_ref->{ method }, $args_of_ref->{ header }, $opt);
    $xml .= "\n" if ($opt->{ readable });
    $xml .= $self->serialize_body($args_of_ref->{ method }, $args_of_ref->{ body }, $opt);
    $xml .= "\n" if ($opt->{ readable });
    $xml .= '</' . $soap_prefix .':Envelope>';
    $xml .= "\n" if ($opt->{ readable });
    return $xml;
}

sub serialize_header {
    my ($self, $name, $data, $opt) = @_;
    
    # header is optional. Leave out if there's no header data
    return q{} if not $data;
    return join ( ($opt->{ readable }) ? "\n" : q{}, 
        "<$opt->{ namespace }->{ $SOAP_NS }\:Header>",
        "$data",
        "</$opt->{ namespace }->{ $SOAP_NS }\:Header>",
    );
}

sub serialize_body {
    my ($self, $name, $data, $opt) = @_;

    # Body is NOT optional. Serialize to empty body 
    # if we have no data.
    return join ( ($opt->{ readable }) ? "\n" : q{}, 
        "<$opt->{ namespace }->{ $SOAP_NS }\:Body>",
        defined $data ? "$data" : (),
        "</$opt->{ namespace }->{ $SOAP_NS }\:Body>",
    );
}
