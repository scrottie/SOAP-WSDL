use Module::Build;
Module::Build->new(
	dist_abstract => 'SOAP with WSDL support',
	dist_name => 'SOAP-WSDL',
	dist_version => '2.00_04',
	module_name   => 'SOAP::WSDL',
	license       => 'artistic',
	requires      => {
	    'Class::Std' => q/v0.0.8/,
	    'Class::Std::Storable' => 0,
		'SOAP::Lite' => 0,
		'XML::XPath' => 0,
		'XML::LibXML' => 0,
		'XML::SAX::Base' => 0,
		'XML::SAX::ParserFactory' => 0,
	},
	buildrequires => {	
	    'Benchmark' => 0, 
	    'Cwd' => 0,    
	    'Test::More' => 0,
        'SOAP::Lite' => 0,
	    'Class::Std' => 0.0.8,
	    'Class::Std::Storable' => 0,        
		'XML::XPath' => 0,
		'XML::Simple' => 0,
		'XML::LibXML' => 0,
		'XML::SAX::Base' => 0,
		'XML::SAX::ParserFactory' => 0,
		'Pod::Simple::Text' => 0,
		'XML::SAX::ParserFactory' => 0,
		
	},
)->create_build_script;
