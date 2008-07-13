use Getopt::Long;
use Pod::Usage;
use File::Basename;
use POSIX;
use Data::Dumper;
use Path::Class;

use Devel::CoverX::Covered::Db;
my $db = Devel::CoverX::Covered::Db->new(
    dir => dir('./cover_db')->absolute(),
);

print( "* Covered *\nVersion: " . Devel::CoverX::Covered->VERSION . "\n" );

my @test_file_from = $db->test_files();
for my $test_file (sort @test_file_from) {
    print "$test_file\n";
    print( "\t", join("\n\t", $db->source_files_covered_by($test_file)) , "\n\n" );
}

