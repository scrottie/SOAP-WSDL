package SOAP::WSDL::Service;
use strict;
use warnings;
use Class::Std::Fast::Storable;
use base qw(SOAP::WSDL::Base);

our $VERSION = $SOAP::WSDL::VERSION;

my %port_of    :ATTR(:name<port>   :default<[]>);

1;
