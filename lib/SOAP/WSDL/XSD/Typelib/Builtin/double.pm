package SOAP::WSDL::XSD::Typelib::Builtin::double;
use strict;
use warnings;
use Class::Std::Storable;
use base qw(SOAP::WSDL::XSD::Typelib::Builtin::anySimpleType);

sub as_num :NUMERIFY {
    return $_[0]->get_value();
}

Class::Std::initialize();   # make :NUMERIFY overloading serializable

1;

__END__

=pod

=head1 NAME

SOAP::WSDL::XSD::Typelib::Builtin::double - double precision float objects

=head1 DESCRIPTION

The double datatype corresponds to IEEE double-precision 64-bit floating point type. 
The basic �value space� of double consists of the values m � 2^e, where m is an 
integer whose absolute value is less than 2^53, and e is an integer between 
-1075 and 970, inclusive. 

In addition to the basic �value space� described above, the �value space� of double 
also contains the following special values: positive and negative zero, positive and 
negative infinity and not-a-number. The �order-relation� on double is: 

 x < y iff y - x is positive. 
 
Positive zero is greater than negative zero. 

Not-a-number equals itself and is greater than all double values including 
positive infinity.

=head1 BUGS AND LIMITATIONS

None of the "special" behaviours and values are implemented yet.

=head1 LICENSE

Copyright 2004-2007 Martin Kutter.

This file is part of SOAP-WSDL. You may distribute/modify it under 
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=cut