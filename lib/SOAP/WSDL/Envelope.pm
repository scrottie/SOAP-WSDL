#!/usr/bin/perl -w
package SOAP::WSDL::Envelope;
use strict;
use base qw/SOAP::WSDL::Base/;

my $SOAP_NS = 'http://schemas.xmlsoap.org/soap/envelope/';
my $XML_INSTANCE_NS = 'http://www.w3.org/2001/XMLSchema-instance';

sub serialize {
    my ($self, $name, $data, $opt) = @_;

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
    $xml .= $self->serialize_header($name, $data, $opt);
    $xml .= $self->serialize_body($name, $data, $opt);
    $xml .= "\n" if ($opt->{ readable });
    $xml .= '</' . $soap_prefix .':Envelope>';
    $xml .= "\n" if ($opt->{ readable });
    return $xml;
}

sub serialize_header {
    my $xml = '';
    return $xml;
}

sub serialize_body {
    my $self = shift;
    my $name = shift;
    my $data = shift;
    my $opt = shift;

    my $soap_prefix = $opt->{ namespace }->{ $SOAP_NS };

    my $xml = '';
    $xml .= "\n" if ($opt->{ readable });
    $xml .= "<$soap_prefix\:Body>";
    $xml .= "\n" if ($opt->{ readable });

    # include parts
    $xml .= $data if ( defined($data) );

    $xml .= "</$soap_prefix\:Body>";
    return $xml;
}
