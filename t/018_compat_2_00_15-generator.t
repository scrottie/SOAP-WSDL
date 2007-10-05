use Test::More tests => 2;
use lib 't/lib';
use lib 'lib';

use_ok q(MyInterfaces::GlobalWeather);

ok MyInterfaces::GlobalWeather->new();