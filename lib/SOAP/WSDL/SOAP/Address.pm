package SOAP::WSDL::SOAP::Address;
use strict;
use warnings;
use base qw(SOAP::WSDL::Base);
use Class::Std::Fast::Storable;
my %location   :ATTR(:name<location> :default<()>);
1;