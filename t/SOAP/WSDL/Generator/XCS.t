use strict;
use warnings;
use Test::More;
use File::Spec;
use File::Basename;
eval { require XML::Compile::WSDL11 }
    or plan skip_all => 'Cannot test without XML::Compile::WSDL11'; 

eval { require XML::LibXML }
    or plan skip_all => 'Cannot test without XML::LibXML'; 

plan skip_all => 'XML::Compile::WSDL11 is not functional yet';

plan tests => qw(no_plan);

my $path = File::Spec->rel2abs( dirname __FILE__ );

my $libxml = XML::LibXML->new();
my $xml = $libxml->parse_file("$path/../../../acceptance/wsdl/generator_test.wsdl");

my $wsdl    = XML::Compile::WSDL11->new($xml);
my $schemas = $wsdl->schemas;
my $operation = $wsdl->operation('testHeader');

my $client = $operation->prepareClient();
