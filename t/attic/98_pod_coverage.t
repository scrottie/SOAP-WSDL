use Test::More;
eval "use Test::Pod::Coverage 1.00";
plan skip_all => "Test::Pod::Coverage 1.00 required for testing POD" if $@;



BEGIN
{
	if (-d 't')			# chdir into test directory if we 
	{					# are not there (make test)
		chdir 't';
		@dirs = '../blib/lib';
	}
	else
	{
		@dirs = ('../lib');
		use lib '../lib';	# use our lib if we are in t/ (if we are, we're)
							# not run from "make test" / "Build test"
	}
}

@files = all_modules( @dirs );
plan tests => scalar @files;
foreach (@files)
{
	s/^\.\.::blib::lib:://;
	s/^\.\.::lib:://;
	pod_coverage_ok( $_ );
}