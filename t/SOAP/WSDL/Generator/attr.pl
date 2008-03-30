use Test::More qw(no_plan);
use lib 'testlib';
#ok eval { require MyTypes::testComplexTypeSequenceWithAttribute; }
#    , 'load MyTypes::testComplexTypeSequenceWithAttribute';
#
#my $obj = MyTypes::testComplexTypeSequenceWithAttribute->new({
#    Test1 => 'foo',
#    Test2 => 'bar',
#});
#$obj->attr({ testAttr => 'foobar' });
#
#print $obj->attr();
#

use_ok qw(MyElements::testElementComplexTypeSequenceWithAttribute);

my $obj = MyElements::testElementComplexTypeSequenceWithAttribute->new({
    Test1 => 'foo',
    Test2 => 'bar',
});
$obj->attr({ testAttr => 'foobar' });

print $obj;
