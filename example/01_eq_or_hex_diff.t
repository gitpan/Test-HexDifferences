#!perl -T

use strict;
use warnings;

use Test::More tests => 2 + 1;
use Test::NoWarnings;
use Test::HexDifferences;

# use default address and default format
eq_or_hex_diff(
    '12345678',              # got
    '1234567',               # expected
    'example with defaults', # test name
);

# use own format
# - 1 byte missing in "got".
# - 2nd word for "%2S<" can not filled, so filled with space.
# - End of format.
# - Last byte will be displayd in default format.
# - This is the default behaviour in case of errors with multibytes format items.
eq_or_hex_diff(
    '12345678',             # got
    '1234567',              # expected
    {
        address => 0x1000,  # set start address
        format  => <<"EOT", # set own format
%a %L<\n%1x%
%a %2S<\n%1x%
EOT
    },
    'example with customized address and format',
);

__END__

>prove -Ilib example\*.t
example\eq_or_hex_diff.t ..
example\eq_or_hex_diff.t .. 1/3 #   Failed test 'example with defaults'
#   at D:\build\Test-HexDifferences\lib/Test/HexDifferences.pm line 26.
# +---+--------------------------------+--------------------------------+
# | Ln|Got                             |Expected                        |
# +---+--------------------------------+--------------------------------+
# |  1|'0000 : 31 32 33 34 : \'1234\'  |'0000 : 31 32 33 34 : \'1234\'  |
# *  2|0004 : 35 36 37 38 : \'5678\'   |0004 : 35 36 37    : \'567\'    *
# |  3|'                               |'                               |
# +---+--------------------------------+--------------------------------+

#   Failed test 'example with customized address and format'
#   at D:\build\Test-HexDifferences\lib/Test/HexDifferences.pm line 26.
# +---+------------------+---+----------------------------+
# | Ln|Got               | Ln|Expected                    |
# +---+------------------+---+----------------------------+
# |  1|'1000 34333231    |  1|'1000 34333231              |
# *  2|1004 3635 3837\n  *  2|1004 3635\s\s\s\s\s\n       *
# |   |                  *  3|1006 : 37          : \'7\'  *
# |  3|'                 |  4|'                           |
# +---+------------------+---+----------------------------+
# Looks like you failed 2 tests of 3.
example\eq_or_hex_diff.t .. Dubious, test returned 2 (wstat 512, 0x200)
Failed 2/3 subtests

Test Summary Report
-------------------
example\eq_or_hex_diff.t (Wstat: 512 Tests: 3 Failed: 2)
  Failed tests:  1-2
  Non-zero exit status: 2
Files=1, Tests=3,  0 wallclock secs ( 0.03 usr +  0.01 sys =  0.05 CPU)
Result: FAIL
