package File::Slurper::Temp;

# DATE
# VERSION

use strict;
use warnings;

use Carp 'croak';
use File::Slurper ();
use File::Temp ();

use Exporter qw(import);
our @EXPORT_OK = qw(write_text write_binary);

sub write_text {
    my $filename = shift;

    my ($tempname, $tempfh) = File::Temp::tempfile();
    File::Slurper::write_text($tempname, @_);
    rename $tempname, $filename
        or croak "Couldn't rename $tempname to $filename: $!";
    return;
}

sub write_binary {
    return write_text(@_[0,1], 'latin-1');
}

1;
# ABSTRACT: File::Slurper + File::Temp

=head1 DESCRIPTION

This module is a simple combination of L<File::Slurper> and L<File::Temp>. It
provides C<write_text> and C<write_binary>. The functions are the same as their
original in File::Slurper but they will first write to a temporary file created
by L<File::Temp>'s C<tempfile>, then rename the temporary file to the originally
specified name. If the filename is originally a symlink, it will be replaced
with a regular file. This can avoid symlink attack.

the L<File::RsyBak> distribution because it has fewer dependencies.


=head1 FUNCTIONS

=head2 write_text

=head2 write_binary


=head1 SEE ALSO

L<File::Slurper>

L<File::Temp>
