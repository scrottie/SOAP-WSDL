
use Date::Format;
use Date::Parse;
use Date::Language;
my $date_string='2007-12-13T00:00:00.12345+0300';

my $time = str2time( $date_string );
print $time,"\n";

$date_string='2007-12-13T00:00:00.12345+0200';
my $time = str2time( $date_string );


print time2str('%d. %B %Y %H %M %S', $time, '+0200' );

