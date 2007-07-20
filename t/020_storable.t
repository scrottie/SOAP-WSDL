use Test::More tests => 1;
use lib '../lib';
eval "require SOAP::WSDL::XSD::Typelib::Builtin";
use Storable;

my $long = SOAP::WSDL::XSD::Typelib::Builtin::long->new();
$long->set_value( 9 );
my $clone = Storable::thaw( Storable::freeze( $long ) );

is $clone->serialize, 9 , 'clone via freeze/thaw';