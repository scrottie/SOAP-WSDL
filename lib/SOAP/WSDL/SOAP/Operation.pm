package SOAP::WSDL::SOAP::Operation;
use strict;
use warnings;
use Class::Std::Fast::Storable;
use base qw(SOAP::WSDL::Base);

our $VERSION = $SOAP::WSDL::VERSION;

my %style_of :ATTR(:name<style> :default<()>);
my %soapAction_of :ATTR(:name<soapAction> :default<()>);

1;
