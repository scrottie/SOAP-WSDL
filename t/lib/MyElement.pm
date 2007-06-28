#!/usr/bin/perl
package MyElement;
use strict;
use Class::Std::Storable;
use SOAP::WSDL::XSD::Typelib::Element;
use SOAP::WSDL::XSD::Typelib::Builtin;
use base (
   'SOAP::WSDL::XSD::Typelib::Element',
   'SOAP::WSDL::XSD::Typelib::Builtin::string',
);

sub START {
   my ($self, $ident, $args_of) =@_;
   $self->__set_name('MyElementName');
}

sub get_xmlns { 'urn:Test' };

package MyTestElement;
use strict;
use Class::Std::Storable;
use SOAP::WSDL::XSD::Typelib::Element;
use SOAP::WSDL::XSD::Typelib::Builtin;
use base (
   'SOAP::WSDL::XSD::Typelib::Element',
   'SOAP::WSDL::XSD::Typelib::Builtin::string',
);

sub START {
   my ($self, $ident, $args_of) =@_;
   $self->__set_name('MyTestElement');
}

sub get_xmlns { 'urn:Test' };

package MyTestElement2;
use strict;
use Class::Std::Storable;
use SOAP::WSDL::XSD::Typelib::Element;
use SOAP::WSDL::XSD::Typelib::Builtin;
use base (
   'SOAP::WSDL::XSD::Typelib::Element',
   'SOAP::WSDL::XSD::Typelib::Builtin::string',
);

sub START {
   my ($self, $ident, $args_of) =@_;
   $self->__set_name('MyTestElement2');
}
sub get_xmlns { 'urn:Test' };
;


package MyAtomicComplexTypeElement;

use strict;
use Class::Std::Storable;
use SOAP::WSDL::XSD::Typelib::Element;
use SOAP::WSDL::XSD::Typelib::ComplexType;
use SOAP::WSDL::XSD::Typelib::Builtin;
use base (
   'SOAP::WSDL::XSD::Typelib::Element',
   'SOAP::WSDL::XSD::Typelib::ComplexType',
);

my %test_of :ATTR(:get<test>);
my %test2_of :ATTR(:get<test2>);

sub get_xmlns { 'urn:Test' };

__PACKAGE__->_factory( 
    [ qw(test test2) ], 
    {
        test => \%test_of,
        test2 => \%test2_of,
    },
    {
        test =>  'MyTestElement',
        test2 => 'MyTestElement2',
    },
);

__PACKAGE__->__set_name('MyAtomicComplexTypeElement');


1;
