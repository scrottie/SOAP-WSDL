package SOAP::WSDL::XSD::Typelib::Attribute;
use strict;
use warnings;

use base qw(SOAP::WSDL::XSD::Typelib::Element);

sub start_tag {
    # my ($self, $opt, $value) = @_;
    return q{} if (@_ < 3); 
    return qq{ $_[1]->{ name }="}
}

sub end_tag {
    return q{"};
}

1;