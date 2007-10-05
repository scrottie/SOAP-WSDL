use Test::More tests => 11;
use lib '../../../lib';
use_ok qw(SOAP::WSDL::Deserializer::Hash);

# Try all instanciation variants
ok my $deserializer = SOAP::WSDL::Deserializer::Hash->new();
ok $deserializer = SOAP::WSDL::Deserializer::Hash->new({
    class_resolver => 'SomeFunkyClass',
});

ok my $data = $deserializer->deserialize(q{<a><b>1</b><b>2</b><c>3</c></a>});
is $data->{a}->{b}->[0], 1;
is $data->{a}->{b}->[1], 2;
is $data->{a}->{c}, 3;

ok $data = $deserializer->deserialize(q{<a><b><c>1</c></b><b><c>2</c></b></a>});
is $data->{a}->{b}->[0]->{c}, 1;
is $data->{a}->{b}->[1]->{c}, 2;

eval { $deserializer->deserialize('grzlmpfh') };
ok $@->isa('SOAP::WSDL::SOAP::Typelib::Fault11');