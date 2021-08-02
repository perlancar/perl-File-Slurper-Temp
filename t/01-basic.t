#!perl

use strict;
use warnings;
use Test::Exception;
use Test::More 0.98;

use File::Slurper qw(
                        read_text
                );
use File::Slurper::Temp qw(
                              write_text
                              write_binary
                              write_text_to_tempfile
                              write_binary_to_tempfile
                      );
use File::Temp qw(tempdir);

my $tempdir = tempdir(CLEANUP => !$ENV{DEBUG});
note "Temporary directory for testing: $tempdir (not cleaned up)"
    if $ENV{DEBUG};
mkdir "$tempdir/dir1";

subtest "write_text" => sub {
    subtest "basics" => sub {
        lives_ok { write_text "$tempdir/1", "foo" };
        is(read_text("$tempdir/1"), "foo");
    };
    subtest "Setting \$FILE_TEMP_DIR" => sub {
        lives_ok {
            local $File::Slurper::Temp::FILE_TEMP_DIR = "$tempdir/dir1";
            write_text "$tempdir/2", "bar";
            is(read_text("$tempdir/2"), "bar");
        };
        dies_ok {
            local $File::Slurper::Temp::FILE_TEMP_DIR = "$tempdir/non-existent";
            write_text "$tempdir/3", "baz";
        };
    };
};

# XXX write_binary

subtest "write_text_to_tempfile" => sub {
    subtest "basics" => sub {
        my $path;
        lives_ok { $path = write_text_to_tempfile("foo") };
        ok($path);
    };
};

# XXX write_binary_to_tempfile

done_testing;
