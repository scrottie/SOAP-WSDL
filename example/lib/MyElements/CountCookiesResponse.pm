package MyElements::CountCookiesResponse;
use strict;
use Class::Std::Storable;
use SOAP::WSDL::XSD::Typelib::Element;

# atomic complexType
# <element name="CountCookiesResponse"><complexType> definition
use SOAP::WSDL::XSD::Typelib::ComplexType;
use base qw(
    SOAP::WSDL::XSD::Typelib::Element
    SOAP::WSDL::XSD::Typelib::ComplexType
);


my %CountCookiesResult_of :ATTR(:get<CountCookiesResult>);


__PACKAGE__->_factory(
    [ qw( 
    CountCookiesResult
    ) ],
    { 
       CountCookiesResult => \%CountCookiesResult_of, 
        
    },
    {
      
        CountCookiesResult => 'SOAP::WSDL::XSD::Typelib::Builtin::int',        
         
      
    }
);



sub get_xmlns { 'http://www.fullerdata.com/FortuneCookie/FortuneCookie.asmx' }

__PACKAGE__->__set_name('CountCookiesResponse');
__PACKAGE__->__set_nillable();
__PACKAGE__->__set_minOccurs();
__PACKAGE__->__set_maxOccurs();
__PACKAGE__->__set_ref('');

1;


__END__

=pod

=head1 NAME MyElements::CountCookiesResponse

=head1 SYNOPSIS

=head1 DESCRIPTION

Type class for the XML element CountCookiesResponse. 

=head1 PROPERTIES

The following properties may be accessed using get_PROPERTY / set_PROPERTY 
methods:

 CountCookiesResult

=head1 Object structure

        CountCookiesResult => 'SOAP::WSDL::XSD::Typelib::Builtin::int',        
        

Structure as perl hash: 

 The object structure is displayed as hash below though this is not correct.
 Complex hash elements actually are objects of their corresponding classes 
 (look for classes of the same name in your typleib).
 new() will accept a hash structure like this, but transform it to a object 
 tree.

    'CountCookiesResponse'=> {
     'CountCookiesResult' => $someValue,
   },


=cut

