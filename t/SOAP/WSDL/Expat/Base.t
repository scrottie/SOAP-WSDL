use strict;
use warnings;
use Test::More tests => 3;
use_ok qw(SOAP::WSDL::Expat::Base);

my $parser = SOAP::WSDL::Expat::Base->new();

eval { $parser->parse('Foobar')};
ok $@;

eval { $parser->parsefile('Foobar')};
ok $@;