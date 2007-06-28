#!/usr/bin/perl
package MyComplexType;
use strict;
use Class::Std::Storable;
use lib '../../lib';
use SOAP::WSDL::XSD::Typelib::ComplexType;
use base ('SOAP::WSDL::XSD::Typelib::ComplexType');

my %MyTestName_of;                      # no :ATTR - _factory takes care of

__PACKAGE__->_factory(
    [ qw(MyTestName) ],                # order
    { MyTestName => \%MyTestName_of },  # attribute lookup map
    { MyTestName => 'MyElement' }       # class name lookup map
);

sub get_xmlns { 'urn:Test' };

1;
