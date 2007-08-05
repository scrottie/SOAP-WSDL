use Test::More;
eval "use Test::Pod 1.00";
plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;

# perl Build test or make test run from top-level dir. 
if ( -d '../t/' ) {
	@directories = ('../lib/');
}
else {
	@directories = (); # empty - will work automatically
}

my @files = all_pod_files(@directories);

plan tests => scalar(@files);

foreach my $module (@files){
	pod_file_ok( $module )
}