package SOAP::WSDL::XSD::Typelib::AttributeSet;
use strict;
use warnings;
use base qw(SOAP::WSDL::XSD::Typelib::ComplexType);

our $VERSION=q{2.00_29};

sub serialize {
    # we work on @_ for performance.
    $_[1] ||= {};                                   # $option_ref

    return ${ $_[0]->_serialize({ attr => 1 }) };
}


1;