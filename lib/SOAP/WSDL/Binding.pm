package SOAP::WSDL::Binding;
use strict;
use warnings;
use Class::Std::Storable;
use List::Util qw(first);
use base qw(SOAP::WSDL::Base);

my %operation_of    :ATTR(:name<operation> :default<()>);
my %type_of         :ATTR(:name<type> :default<()>);
my %transport_of    :ATTR(:name<transport> :default<()>);
my %style_of        :ATTR(:name<style> :default<()>);

1;
