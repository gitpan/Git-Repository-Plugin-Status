package Git::Repository::Status;
{
  $Git::Repository::Status::VERSION = '0.02';
}
#ABSTRACT: Class representing git status data

use strict;
use warnings;
use 5.006;

sub index { return $_[0]->[0] }
sub work  { return $_[0]->[1] }
sub status { $_[0]->[0] . $_[0]->[1] }
sub path1 { return $_[0]->[2] }
sub path2 { return $_[0]->[3] }

sub ignored { return $_[0]->[0] eq '?' }
sub tracked { return $_[0]->[0] ne '!' }

our %MEANINGS = (
          ' M'  => 'not updated',
          ' D'  => 'not updated',
          'MM'  => 'updated in index',
          'MD'  => 'updated in index',
          'AM'  => 'added to index',
          'AD'  => 'added to index',
          'D '  => 'deleted from index',
          'DM'  => 'deleted from index',
          'R '  => 'renamed in index',
          'RM'  => 'renamed in index',
          'RD'  => 'renamed in index',
          'C '  => 'copied in index',
          'CM'  => 'copied in index',
          'CD'  => 'copied in index',
          'M '  => 'index and work tree matches',
          'A '  => 'index and work tree matches',
          'R '  => 'index and work tree matches',
          'C '  => 'index and work tree matches',
          ' M'   => 'work tree changed since index',
          'MM'   => 'work tree changed since index',
          'AM'   => 'work tree changed since index',
          'RM'   => 'work tree changed since index',
          'CM'   => 'work tree changed since index',
          ' D'   => 'deleted in work tree',
          'MD'   => 'deleted in work tree',
          'AD'   => 'deleted in work tree',
          'RD'   => 'deleted in work tree',
          'CD'   => 'deleted in work tree',
          'DD'  => 'unmerged, both deleted',
          'AU'  => 'unmerged, added by us',
          'UD'  => 'unmerged, deleted by them',
          'UA'  => 'unmerged, added by them',
          'DU'  => 'unmerged, deleted by us',
          'AA'  => 'unmerged, both added',
          'UU'  => 'unmerged, both modified',
          '??'  => 'untracked',
          '!!'  => 'ignored'
);

sub meaning { return $MEANINGS{$_[0]->status} }

sub unmerged {
	return $_[0]->status =~ /^(D[DU]|A[UA]|U[DAU])$/
}

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

version 0.02

=head1 SYNOPSIS

    # load the Status plugin
	use Git::Repository 'Status';
 
	# get the status of all files
	my @status = Git::Repository->status('--ignored');
 
	# print all ignored files
	for (@status) {
	    say $_->path1 if $_->ignored;
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

=item status

Returns the two character status code (index and work combined).

=item path1

Returns the path of the status.

=item path2

Returns the path that path1 was copied or renamed to.

=item unmerged

Returns true if the path is part of a merge conflict.

=item ignored

Returns true if the path is being ignored.

=item tracked

Returns true if the path is being tracked.

=item meaning

Returns the human readable status meaning as listed in the git manual.

=back

=head1 SEE ALSO

L<https://www.kernel.org/pub/software/scm/git/docs/git-status.html>

=encoding utf8

=head1 AUTHOR

Jakob Voß

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jakob Voß.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
