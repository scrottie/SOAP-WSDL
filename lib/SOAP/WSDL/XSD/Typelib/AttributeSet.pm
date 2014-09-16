package SOAP::WSDL::XSD::Typelib::AttributeSet;
use strict;
use warnings;
use base qw(SOAP::WSDL::XSD::Typelib::ComplexType);

use version; our $VERSION = qv('3.001');

sub serialize {
    # we work on @_ for performance.
    # $_[1] ||= {};                                   # $option_ref
    # TODO: What about namespaces?
    return ${ $_[0]->_serialize({ attr => 1 }) };
}


1;