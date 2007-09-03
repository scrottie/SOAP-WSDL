use Test::More tests => 11;
use Data::Dumper;
use lib '../lib';

use_ok(qw/SOAP::WSDL::Expat::WSDLParser/);

my $filter;

my $parser;

ok($parser = SOAP::WSDL::Expat::WSDLParser->new() );

eval { $parser->parse_string( xml() ) };
if ($@)
{
	fail("parsing WSDL");
	die "Can't test without parsed WSDL";
}
else
{
	pass("parsing XML");
}

my $wsdl;
ok( $wsdl = $parser->get_data() , "get object tree");

my $schema = $wsdl->first_types();

my $opt = {
	readable => 0,
	autotype => 1,
    namespace => $wsdl->get_xmlns(),
	indent => "\t",
	typelib => $schema,
};

is( $schema->find_type( 'myNamespace', 'testSimpleType1' )->serialize(
	'test', 1 , $opt ),
	q{<test type="tns:testSimpleType1">1</test>} , "serialize simple type");

is( $schema->find_type( 'myNamespace', 'testSimpleList' )->serialize(
	'testList', [ 1, 2, 3 ] , $opt),
	q{<testList type="tns:testSimpleList">1 2 3</testList>},
	"serialize simple list type"
);

is( $schema->find_element( 'myNamespace', 'TestElement' )->serialize(
	undef, 1 , $opt),
	q{<TestElement type="xsd:int">1</TestElement>}, "Serialize element"
);

$opt->{ readable } = 0;

is( $schema->find_type( 'myNamespace', 'length3')->serialize(
	'TestComplex', { size => -13, unit => 'BLA' } ,
	$opt ),
	q{<TestComplex type="tns:length3" >}
	. q{<size type="xsd:non-positive-integer">-13</size>}
	. q{<unit type="xsd:NMTOKEN">BLA</unit></TestComplex>}
	, "serialize complex type" );

is( $schema->find_element( 'myNamespace', 'TestElementComplexType')->serialize(
	undef, { size => -13, unit => 'BLA' } ,
	$opt ),
	q{<TestElementComplexType type="tns:length3" >}
	. q{<size type="xsd:non-positive-integer">-13</size>}
	. q{<unit type="xsd:NMTOKEN">BLA</unit></TestElementComplexType>},
	"element with complex type"
);

is( $schema->find_type( 'myNamespace', 'complex')->serialize(
	'complexComplex',
	{ 'length' => {  size => -13, unit => 'BLA' }, 'int' => 1 },
	$opt ),
	q{<complexComplex type="tns:complex" >}
	. q{<length type="tns:length3" >}
	. q{<size type="xsd:non-positive-integer">-13</size>}
	. q{<unit type="xsd:NMTOKEN">BLA</unit></length>}
	. q{<int type="xsd:int">1</int></complexComplex>},
	"nested complex type"
);

is( $wsdl->find_message('myNamespace', 'testRequest')->first_part()->serialize(
	undef, { test => { length => {  size => -13, unit => 'BLA' } , int => 3 } },
	$opt ),
	q{<test type="tns:complex" >}
	. q{<length type="tns:length3" >}
	. q{<size type="xsd:non-positive-integer">-13</size>}
	. q{<unit type="xsd:NMTOKEN">BLA</unit>}
	. q{</length><int type="xsd:int">3</int></test>}
	, "Message part"
);


exit;

sub xml
{
	return q{<?xml version="1.0"?>
<definitions name="simpleType"
	targetNamespace="myNamespace"
	xmlns="http://schemas.xmlsoap.org/wsdl/"
	xmlns:tns="myNamespace"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
	xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
>
	<types>
		<xsd:schema targetNamespace="myNamespace">
		<xsd:complexType name="length3">
 			<xsd:sequence>
  				<xsd:element name="size" type="xsd:non-positive-integer"/>
  				<xsd:element name="unit" type="xsd:NMTOKEN"/>
 			</xsd:sequence>
		</xsd:complexType>

		<xsd:complexType name="complex">
			<xsd:sequence>
  				<xsd:element name="length" type="tns:length3"/>
  				<xsd:element name="int" type="xsd:int"/>
 			</xsd:sequence>
		</xsd:complexType>

		<xsd:element name="TestElement" type="xsd:int"/>
		<xsd:element name="TestElementComplexType" type="tns:length3"/>
		<xsd:simpleType name="testSimpleType1">
			<xsd:restriction base="int">
				<xsd:enumeration value="1"/>
				<xsd:enumeration value="2"/>
				<xsd:enumeration value="3"/>
			</xsd:restriction>
		</xsd:simpleType>

		<xsd:simpleType name="testSimpleList">
			<xsd:annotation>
				<xsd:documentation>
				SimpleType Test
				</xsd:documentation>
			</xsd:annotation>
			<xsd:list itemType="int">
			</xsd:list>
		</xsd:simpleType>
		<xsd:simpleType name="testSimpleUnion">
			<xsd:annotation>
				<xsd:documentation>
				SimpleType Union test
				</xsd:documentation>
			</xsd:annotation>
			<xsd:union memberTypes="int float">
			</xsd:union>
		</xsd:simpleType>
		</xsd:schema>
	</types>
	<message name="testRequest">
		<part name="test" type="tns:complex"/>
	</message>
	<message name="testResponse">
		<part name="test" type="tns:testSimpleType1"/>
	</message>
	<message name="testRequest2">
		<part name="test" type="tns:testSimpleType1"/>
	</message>
	<message name="testResponse2">
		<part name="test" type="tns:testSimpleType1"/>
	</message>
	<portType name="testPort">
		<operation name="test">
			<documentation>
				Test-Methode
			</documentation>

			<input message="testRequest"/>
			<output message="testResponse"/>
		</operation>
		<operation name="test2">
			<documentation>
				Test-Methode
			</documentation>

			<input message="testRequest2"/>
			<output message="testResponse2"/>
		</operation>
	</portType>
	<portType name="testPort2">
		<operation name="test">
			<documentation>
				Test-Methode
			</documentation>

			<input message="testRequest"/>
			<output message="testResponse"/>
		</operation>
	</portType>
	<portType name="testPort3">
		<operation name="test">
			<documentation>
				Test-Methode
			</documentation>
			<input message="testRequest"/>
			<output message="testResponse"/>
		</operation>
	</portType>

	<binding type="testPort" name="testBinding">
		<soap:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
		<soap:operation soapAction="test">
			<input>
				<soap:body use="literal"/>
			</input>
			<output>
				<soap:body use="literal"/>
			</output>
		</soap:operation>
	</binding>
	<binding type="testPort2" name="testBinding2">
		<soap:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
		<soap:operation soapAction="test">
			<input>
				<soap:body use="literal"/>
			</input>
			<output>
				<soap:body use="literal"/>
			</output>
		</soap:operation>
	</binding>
	<binding type="testPort3" name="testBinding3">
		<soap:binding style="document" transport="http://schemas.xmlsoap.org/soap/http"/>
		<soap:operation soapAction="test">
			<input>
				<soap:body use="literal"/>
			</input>
			<output>
				<soap:body use="literal"/>
			</output>
		</soap:operation>
	</binding>
	<service name="testService">
		<port name="testPort" binding="testBinding">
			<soap:address location="http://127.0.0.1/testPort" />
		</port>
		<port name="testPort2" binding="testBinding2">
			<soap:address location="http://127.0.0.1/testPort2" />
		</port>
		<port name="testPort3" binding="testBinding3">
			<soap:address location="http://127.0.0.1/testPort3" />
		</port>

	</service>
</definitions>
};

}

