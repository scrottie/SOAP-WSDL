use Test::More;
eval "use Test::Pod 1.00";
plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;

use Cwd;

my $dir = cwd;

if ( $dir =~ /t$/ )
{
	@directories = ('../lib/');
}
else
{
	@directories = ();
}

my @files = all_pod_files(
	@directories
);

plan tests => scalar(@files);

foreach my $module (@files)
{
	pod_file_ok( $module )
}