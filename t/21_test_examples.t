#!perl

use strict;
use warnings;

use Test::More;
use Test::Differences;
use Cwd qw(getcwd chdir);

$ENV{TEST_EXAMPLE} or plan(
    skip_all => 'Set $ENV{TEST_EXAMPLE} to run this test.'
);

plan(tests => 2);

for my $test ( qw(01_eq_or_dump_diff.t 02_dumped_eq_dump_or_diff.t) ) {
    my $dir = getcwd();
    chdir("$dir/example");
    my $result = qx{prove -I../lib -T $test 2>&3};
    chdir($dir);
    like(
        $result,
        qr{\QFailed 2/3 subtests\E}xms,
        "prove example $test",
    );
}