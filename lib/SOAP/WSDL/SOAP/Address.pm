package SOAP::WSDL::SOAP::Address;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::Base);


my %location   :ATTR(:name<location> :default<()>);
1;