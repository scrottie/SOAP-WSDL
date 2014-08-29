package SOAP::WSDL::Port;
use strict;
use warnings;
use Class::Std::Fast::Storable;
use base qw(SOAP::WSDL::Base);

use version; our $VERSION = qv('3.001');

my %binding_of :ATTR(:name<binding> :default<()>);
my %address_of :ATTR(:name<address> :default<()>);

1;
