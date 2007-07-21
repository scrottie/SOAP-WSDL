package MyElements::readNodeCountResponse;
use strict;
use Class::Std::Storable;
use SOAP::WSDL::XSD::Typelib::Element;

# atomic complexType
# <element name="readNodeCountResponse"><complexType> definition
use SOAP::WSDL::XSD::Typelib::ComplexType;
use base qw(
    SOAP::WSDL::XSD::Typelib::Element
    SOAP::WSDL::XSD::Typelib::ComplexType
);


my %readNodeCountResult_of :ATTR(:get<readNodeCountResult>);


__PACKAGE__->_factory(
    [ qw( 
    readNodeCountResult
    ) ],
    { 
       readNodeCountResult => \%readNodeCountResult_of, 
        
    },
    {
      
        readNodeCountResult => 'SOAP::WSDL::XSD::Typelib::Builtin::int',        
         
      
    }
);



sub get_xmlns { 'http://www.fullerdata.com/FortuneCookie/FortuneCookie.asmx' }

__PACKAGE__->__set_name('readNodeCountResponse');
__PACKAGE__->__set_nillable();
__PACKAGE__->__set_minOccurs();
__PACKAGE__->__set_maxOccurs();
__PACKAGE__->__set_ref('');

1;


__END__

=pod

=head1 NAME MyElements::readNodeCountResponse

=head1 SYNOPSIS

=head1 DESCRIPTION

Type class for the XML element readNodeCountResponse. 

=head1 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY 
methods:

 readNodeCountResult

=head1 Object structure

        readNodeCountResult => 'SOAP::WSDL::XSD::Typelib::Builtin::int',        
        

Structure as perl hash: 

 The object structure is displayed as hash below though this is not correct.
 Complex hash elements actually are objects of their corresponding classes 
 (look for classes of the same name in your typleib).
 new() will accept a hash structure like this, but transform it to a object 
 tree.

    'readNodeCountResponse'=> {
     'readNodeCountResult' => $someValue,
   },


=cut

