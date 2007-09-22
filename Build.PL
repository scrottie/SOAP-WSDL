#!/usr/bin/perl -w
use Module::Build;

Module::Build->new(
	dist_abstract => 'WSDL support for SOAP::Lite',
	module_name   => 'SOAP::WSDL',
	license       => 'artistic',
	requires      => {
		'SOAP::Lite' => 0,
		'XML::XPath' => 0,
	},
	buildrequires => {
    'Test::More'    => 0,
    'SOAP::Lite'    => 0,
    'XML::XPath'    => 0,
    'Time::HiRes'   => 0,
    'File::Spec'    => 0,
    'File::Basename' => 0,
    'Cwd'           => 0,
  },

)->create_build_script;
