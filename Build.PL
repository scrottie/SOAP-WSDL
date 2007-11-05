use Module::Build;

$build = Module::Build->new(
	create_makefile_pl => 'passthrough',
	dist_abstract      => 'SOAP with WSDL support',
	dist_name          => 'SOAP-WSDL',
	dist_version       => '2.00_23',
	module_name        => 'SOAP::WSDL',
	license            => 'artistic',
	requires           => {
        # 5.6.x is way too buggy and has no unicode support 
        # for us. SOAP-WSDL relies on unicode (WS-I demands it)
        # and triggers several 5.6 bugs...
		'perl'                    => '5.8.0',
        'Class::Std'              => q/v0.0.8/,
		'Class::Std::Storable'    => 0,
        'Data::Dumper'            => 0,
		'Date::Parse'             => 0,
		'Date::Format'            => 0,
		'File::Basename'          => 0,
		'File::Path'              => 0,
		'Getopt::Long'            => 0,
		'List::Util'              => 0,
		'LWP::UserAgent'          => 0,
		'Template'                => 0,
		'Term::ReadKey'           => 0,
		'XML::Parser::Expat'      => 0,
	},
	buildrequires => {
		'Class::Std'              => q/v0.0.8/,
		'Class::Std::Storable'    => 0,
		'Cwd'         			  => 0,
		'Date::Parse'             => 0,
		'Date::Format'            => 0,
		'Getopt::Long'            => 0,
		'List::Util'              => 0,
		'LWP::UserAgent'          => 0,
		'File::Basename'          => 0,
		'File::Path'              => 0,
        'File::Spec'              => 0,
		'Storable'                => 0,
		'Test::More'              => 0,
		'Template'                => 0,	
		'XML::Parser::Expat'      => 0,
	},
	recursive_test_files => 1,
	meta_add => {
	    no_index => {
	        directory => 'lib/SOAP/WSDL/Generator/Template/XSD/',
	    },
	}
);
$build->add_build_element('tt');
$build->create_build_script;
