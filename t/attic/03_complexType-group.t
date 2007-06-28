BEGIN 
{
	chdir 't/' if (-d 't/');
	use Test::More tests => 7;;
	use lib '../lib';
	use lib 't/lib';
	use lib 'lib';
	use Cwd;
	use File::Basename;

	our $SKIP;
	eval "use Test::SOAPMessage";
	if ($@)
	{
		$SKIP = "Test::Differences required for testing. $@";
	}
}

use_ok qw/SOAP::WSDL/;