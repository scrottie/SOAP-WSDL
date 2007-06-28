use Module::Build;
Module::Build->new(
	dist_abstract => 'SOAP with WSDL support',
	dist_name => 'SOAP-WSDL',
	dist_version => '2.00_01',
	module_name   => 'SOAP::WSDL',
	license       => 'artistic',
	requires      => {
		'SOAP::Lite' => 0,
		'XML::XPath' => 0,
		'XML::LibXML' => 0,
		'XML::SAX::Base' => 0,
		'XML::SAX::ParserFactory' => 0,
	},
	buildrequires => { 'Test::More' => 0,
        'SOAP::Lite' => 0,
		'XML::XPath' => 0,
		'XML::LibXML' => 0,
		'XML::SAX::Base' => 0,
		'XML::SAX::ParserFactory' => 0,
	},
)->create_build_script;
