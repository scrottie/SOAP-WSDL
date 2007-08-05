package MyElements::string;
use strict;
use Class::Std::Storable;
use SOAP::WSDL::XSD::Typelib::Element;

#
# <element name="string" type="s:string"/> definition
#

use base qw(
    SOAP::WSDL::XSD::Typelib::Element
    SOAP::WSDL::XSD::Typelib::Builtin::string
);


sub get_xmlns { 'http://www.webserviceX.NET' }

__PACKAGE__->__set_name('string');
__PACKAGE__->__set_nillable(true);
__PACKAGE__->__set_minOccurs();
__PACKAGE__->__set_maxOccurs();
__PACKAGE__->__set_ref('');

1;


__END__

=pod

=head1 NAME MyElements::string

=head1 SYNOPSIS

=head1 DESCRIPTION

Type class for the XML element string. 

=head1 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY 
methods:


=head1 Object structure


Structure as perl hash: 

 The object structure is displayed as hash below though this is not correct.
 Complex hash elements actually are objects of their corresponding classes 
 (look for classes of the same name in your typleib).
 new() will accept a hash structure like this, but transform it to a object 
 tree.

 'string' => $someValue,


=cut

