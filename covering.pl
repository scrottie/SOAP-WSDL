use strict;
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

sub covered_subs {
    my $db = shift;
    my ($covered_file_name, $calling_file_name) = @_;

    my %sub_covered;
    map { push @{ $sub_covered{ $_->[1] } }, $_->[0] } $db->db->query(
        qq{
        SELECT ccm.covered_row, ccm.covered_sub_name
            FROM covered_calling_metric ccm, file f_covered, file f_calling
            WHERE
                    f_covered.name = ?
                AND f_calling.name = ?
                AND ccm.calling_file_id = f_calling.file_id
                AND ccm.covered_file_id = f_covered.file_id
                AND ccm.metric_type_id = ?
            GROUP BY ccm.covered_row
            ORDER by ccm.covered_sub_name
        },
        $covered_file_name,
        $calling_file_name,
        $db->get_metric_type_id("subroutine"),
    )->arrays;

    return \%sub_covered;
}

print( "* Covered *\nVersion: " . Devel::CoverX::Covered->VERSION . "\n" );

my @covered_files = sort { $a cmp $b } $db->covered_files();
for my $covered_file (sort @covered_files) {
    next if $covered_file =~m{\.t$}x;
    print "$covered_file\n";
#   print( "\t", join("\n\t", $db->test_files_covering($covered_file)) , "\n\n" );

    my @test_files = $db->test_files_covering($covered_file);
    for my $test_file (@test_files) {
        print "\t$test_file\n";

        my $covered_subs_of_ref = covered_subs($db, $covered_file, $test_file);
        for my $covered_sub (sort keys %{ $covered_subs_of_ref }) {
            print "\t\t$covered_sub (line ", join(q{, }, @{ $covered_subs_of_ref->{ $covered_sub } }), ")\n";
        }
    }
}

