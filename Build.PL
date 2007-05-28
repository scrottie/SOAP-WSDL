use Module::Build;
   Module::Build->new(
   		dist_abstract => 'WSDL support for SOAP::Lite',
       module_name => 'SOAP::WSDL',
       license => 'artistic',
       requires => { 'SOAP::Lite' => 0.55, 'XML::XPath' => 0 }
   )->create_build_script;