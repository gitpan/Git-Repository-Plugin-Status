package Git::Repository::Status;
{
  $Git::Repository::Status::VERSION = '0.01';
}
#ABSTRACT: Class representing git status data

use strict;
use warnings;
use 5.006;

sub index { return $_[0]->[0] }
sub work  { return $_[0]->[1] }
sub path1 { return $_[0]->[2] }
sub path2 { return $_[0]->[3] }

sub ignored { return $_[0]->[0] eq '?' }
sub tracked { return $_[0]->[0] ne '!' }

# TODO:
# sub meaning { }
# sub unmerged

sub new {
    my $class = shift;
    bless [@_], $class;
}

1;

__END__

=pod

=head1 NAME

Git::Repository::Status - Class representing git status data

=head1 VERSION

version 0.01

=head1 SYNOPSIS

    # load the Status plugin
	use Git::Repository 'Status';
 
	# get the status of all files
	my @status = Git::Repository->status('--ignored');
 
	# print all ignored files
	for (@status) {
	    say $_->path if $_->ignored;
	}

=head1 DESCRIPTION

Instances of L<Git::Repository::Status> represent a path in a git working
tree with its status. The constructor should not be called directly but
by calling the C<status> method of L<Git::Repository>, provided by 
L<Git::Repository::Plugin::Status>.

=head1 ACCESSORS

=over 4

=item index

Returns the status code of the path in the index, or the status code of side 1
in a merge conflict.

=item work

Returns the status code of the path in the work tree, or the status code of 
side 2 in a merge conflict.

=item path1

Returns the path of the status.

=item path2

Returns the path that path1 was copied or renamed to.

=item ignored

Returns true if the path is being ignored.

=item tracked

Returns true if the path is being tracked.

=back

=head1 SEE ALSO

L<https://www.kernel.org/pub/software/scm/git/docs/git-status.html>

=encoding utf8

=cut

=head1 AUTHOR

Jakob Voß

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jakob Voß.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
