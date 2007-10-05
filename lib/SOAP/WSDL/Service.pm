package SOAP::WSDL::Service;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::Base);

my %port_of    :ATTR(:name<port>   :default<()>);

1;
