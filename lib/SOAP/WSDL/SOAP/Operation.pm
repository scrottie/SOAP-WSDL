package SOAP::WSDL::SOAP::Operation;
use strict;
use warnings;
use Class::Std::Fast::Storable;
use base qw(SOAP::WSDL::Base);

our $VERSION=q{2.00_25};

my %style_of :ATTR(:name<style> :default<()>);
my %soapAction_of :ATTR(:name<soapAction> :default<()>);

1;
