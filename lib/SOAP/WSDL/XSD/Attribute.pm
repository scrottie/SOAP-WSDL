package SOAP::WSDL::XSD::Attribute;
use strict;
use warnings;
use Class::Std::Fast::Storable constructor => 'none';
use base qw(SOAP::WSDL::Base);

our $VERSION=q{2.00_29};

#<attribute
#  default = string
#  fixed = string
#  form = (qualified | unqualified)
#  id = ID
#  name = NCName
#  ref = QName
#  type = QName
#  use = (optional | prohibited | required) : optional
#  {any attributes with non-schema namespace . . .}>
#  Content: (annotation?, (simpleType?))
#</attribute>


my %default_of      :ATTR(:name<default>    :default<()>);
my %fixed_of        :ATTR(:name<fixed>      :default<()>);
my %form_of         :ATTR(:name<form>      :default<()>);
# id provided by Base
# name provided by Base
my %type_of         :ATTR(:name<type>       :default<()>);
my %use_of          :ATTR(:name<use>      :default<()>);

# may be defined as atomic simpleType
my %simpleType_of   :ATTR(:name<simpleType> :default<()>);

1;