package testCodeFirst;
use strict; use warnings;
our $VERSION = 0.1;
use lib '../lib';
use base q{CodeFirst};

sub test :WebMethod(
		action => "test",
		returns => "bar",
		header => "bam",
		body => "baz"
	) {

}

sub test2 :WebMethod(
		action => "test2",
		returns => "bar",
		header => "bam",
		body => "baz"
	) {
}

package main;
use Data::Dumper;
my $test = testCodeFirst->new();
# print Dumper $test->_action_map;

print Dumper $test->get_transport()->get_action_map_ref();
1;