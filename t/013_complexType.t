#!/usr/bin/perl
use Test::More qw(no_plan);
use strict;
use lib 'lib/';
use lib '../lib/';
use lib 't/lib';
use Data::Dumper;

use_ok qw(SOAP::WSDL::XSD::Typelib::ComplexType);
use_ok qw( MyComplexType );
# simple type derived from builtin via restriction
my $obj = MyComplexType->new({ MyTestName => 'test' });
ok $obj->isa('SOAP::WSDL::XSD::Typelib::Builtin::anyType')
    , 'inherited class';
is $obj, '<MyElementName >test</MyElementName>', 'stringification';

$obj = MyComplexType->new({ MyTestName => [ 'test', 'test2' ] });
ok $obj->isa('SOAP::WSDL::XSD::Typelib::Builtin::anyType')
    , 'inherited class';
is $obj, '<MyElementName >test</MyElementName><MyElementName >test2</MyElementName>',
    'stringification';

# try on the fly factory
@MyComplexType2::ISA = ('SOAP::WSDL::XSD::Typelib::ComplexType');
{
    use Class::Std::Storable;
    my %MyTestName_of;

    MyComplexType2->_factory(
        [ qw(MyTestName) ],                # order
        { MyTestName => \%MyTestName_of },  # attribute lookup map
        { MyTestName => 'MyElement' }       # class name lookup map
    );
}

$obj = MyComplexType2->new({ MyTestName => [ 'test', 'test2' ] });
ok $obj->isa('SOAP::WSDL::XSD::Typelib::Builtin::anyType')
    , 'inherited class (on the fly-factory object)';
is $obj, '<MyElementName >test</MyElementName><MyElementName >test2</MyElementName>',
    'stringification (on the fly-factory object)';
# print Dumper $obj->get_MyTestName();


__END__

