package SOAP::WSDL::SOAP::Operation;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::Base);

our $VERSION='2.00_17';

my %style_of :ATTR(:name<style> :default<()>);
my %soapAction_of :ATTR(:name<soapAction> :default<()>);

1;
