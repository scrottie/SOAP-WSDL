use Test::More;


if ( not $ENV{TEST_AUTHOR} ) {
    my $msg = 'Author test.  Set $ENV{TEST_AUTHOR} to a true value to run.';
    plan( skip_all => $msg );
}

eval "use Test::Pod::Coverage 1.00";
plan skip_all => "Test::Pod::Coverage 1.00 required for testing POD" if $@;

my @dirs = ( 'lib' );
if (-d '../t/') {       # we are inside t/
    @dirs = ('../lib');
} 
else {                  # we are outside t/
    # add ./lib to include path if blib/lib is not there (e.g. we're not 
    # run from Build test or the like) 
    push @INC, './lib' if not grep { $_ eq 'blib/lib' } @INC; 
}

# Don't test Builtin XSD types - they're undocumented on purpose
# Don't test WSDL datatypes - they're undocumented on purpose.
@files = grep { $_ !~m{ (SOAP::WSDL::XSD::Typelib::Builtin::.+
    |SOAP::WSDL::OpMessage
    |SOAP::WSDL::Types
    |SOAP::WSDL::PortType
    |SOAP::WSDL::Port
    |SOAP::WSDL::Service
    |SOAP::WSDL::Binding
    |SOAP::WSDL::Message
    |SOAP::WSDL::TypeLookup
    |SOAP::WSDL::Base
    |SOAP::WSDL::Part
    |SOAP::WSDL::Operation
    |SOAP::WSDL::SOAP::[^:]+
    |SOAP::WSDL::XSD::SimpleType
    |SOAP::WSDL::XSD::Element
    |SOAP::WSDL::XSD::ComplexType
    |SOAP::WSDL::XSD::Builtin
    |SOAP::WSDL::XSD::Schema
    
    ) \z }xms; } all_modules( @dirs );

plan tests => scalar @files;
foreach (@files) {
    pod_coverage_ok( $_ , 
	{ 
	    private => [ 
	       qr/^_/, 
	       qr/^BUILD$/, 
	       qr/^START$/, 
	       qr/^STORABLE/, 
	       qr/^AUTOMETHOD$/,
	       qr/^DEMOLISH$/
	       ]
	});
}