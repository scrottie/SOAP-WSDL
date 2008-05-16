use Benchmark qw(cmpthese);
use POSIX ();
use Date::Format ();

my @time_from = localtime;

print "Comparing POSIX::strftime and Date::Format::strftime '%Y-%m-%dT%H:%M:%S%z'\n\n";
print 'POSIX: ', POSIX::strftime('%Y-%m-%dT%H:%M:%S%z', @time_from), "\n";
print 'Date::Format: ', Date::Format::strftime('%Y-%m-%dT%H:%M:%S%z', @time_from), "\n";


cmpthese 100000, {
    POSIX => sub { POSIX::strftime('%Y-%m-%dT%H:%M:%S%z', @time_from) },
    'Date::Format' => sub { Date::Format::strftime('%Y-%m-%dT%H:%M:%S%z', @time_from) },
};

__END__

results with perl-5.8.8 on Ubuntu 8.04 on a Thinkpad T42 (1.7GHz Dothan):

                 Rate Date::Format        POSIX
Date::Format  10684/s           --         -93%
POSIX        153846/s        1340%           --

