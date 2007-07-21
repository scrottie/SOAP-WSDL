package MyElements::GetSpecificCookie;
use strict;
use Class::Std::Storable;
use SOAP::WSDL::XSD::Typelib::Element;

# atomic complexType
# <element name="GetSpecificCookie"><complexType> definition
use SOAP::WSDL::XSD::Typelib::ComplexType;
use base qw(
    SOAP::WSDL::XSD::Typelib::Element
    SOAP::WSDL::XSD::Typelib::ComplexType
);


my %index_of :ATTR(:get<index>);


__PACKAGE__->_factory(
    [ qw( 
    index
    ) ],
    { 
       index => \%index_of, 
        
    },
    {
      
        index => 'SOAP::WSDL::XSD::Typelib::Builtin::int',        
         
      
    }
);



sub get_xmlns { 'http://www.fullerdata.com/FortuneCookie/FortuneCookie.asmx' }

__PACKAGE__->__set_name('GetSpecificCookie');
__PACKAGE__->__set_nillable();
__PACKAGE__->__set_minOccurs();
__PACKAGE__->__set_maxOccurs();
__PACKAGE__->__set_ref('');

1;


__END__

=pod

=head1 NAME MyElements::GetSpecificCookie

=head1 SYNOPSIS

=head1 DESCRIPTION

Type class for the XML element GetSpecificCookie. 

=head1 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY 
methods:

 index

=head1 Object structure

        index => 'SOAP::WSDL::XSD::Typelib::Builtin::int',        
        

Structure as perl hash: 

 The object structure is displayed as hash below though this is not correct.
 Complex hash elements actually are objects of their corresponding classes 
 (look for classes of the same name in your typleib).
 new() will accept a hash structure like this, but transform it to a object 
 tree.

    'GetSpecificCookie'=> {
     'index' => $someValue,
   },


=cut

