package SOAP::WSDL::Service;
use strict;
use warnings;
use Class::Std::Fast::Storable;
use base qw(SOAP::WSDL::Base);

use version; our $VERSION = qv('3.00.0_1');

my %port_of    :ATTR(:name<port>   :default<[]>);

1;
