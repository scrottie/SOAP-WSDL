package SOAP::WSDL::SOAP::Address;
use strict;
use warnings;
use base qw(SOAP::WSDL::Base);
use Class::Std::Fast::Storable;

use version; our $VERSION = qv('3.001');

my %location   :ATTR(:name<location> :default<()>);
1;