package Git::Repository::Plugin::Status;
{
  $Git::Repository::Plugin::Status::VERSION = '0.02';
}
#ABSTRACT: Show the working tree status

use strict;
use warnings;
use 5.006;
use Carp;
use Scalar::Util qw(blessed);

use Git::Repository::Plugin;
our @ISA = qw(Git::Repository::Plugin);

use Git::Repository::Command;
use Git::Repository::Status;

sub _keywords { return qw(status); }

our $FORMAT = qr{^([ MARCDU?!])([ MARCDU?!]) ([^\0]+)\0$};

sub status {
	my ($r,@cmd) = @_;

    # pick up unsupported status options
    my @badopts = do {
        my $options = 1;
        grep {/^(--short|-s|--long|--column=.*|-b)$/}
        grep { $options = 0 if $_ eq '--'; $options } @cmd;
    };
    croak "status() cannot parse @badopts. "
        . 'Use run( status => ... ) to parse the output yourself'
        if @badopts;

	# TODO: -b shows branch and tracking - maybe interesting (?)

	@cmd = (qw(status -z --porcelain), @cmd);
	my $cmd = Git::Repository::Command->new($r, @cmd);

	my $fh = $cmd->stdout;
	local $/ = "\0";

	my @files;

	while(1) {
		my $line1 = <$fh>;
		NEXT: last unless defined $line1;

		croak "error parsing output of `git @cmd`"
		    unless $line1 =~ $FORMAT;
		my @args = ($1,$2,$3);

		my $line2 = <$fh>;
		if (defined $line2 && $line2 !~ $FORMAT) { # PATH2
			chomp $line2;
			push @files, Git::Repository::Status->new(
			  @args[0..1], $line2, $args[2]);
		} else {
			push @files, Git::Repository::Status->new(@args);
			$line1 = $line2;
			goto NEXT;
		}
	}

	return @files;
}

1;

__END__

=pod

=head1 NAME

Git::Repository::Plugin::Status - Show the working tree status

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

This module adds the C<status> method to L<Git::Repository> to get the status
of a git working tree in form of L<Git::Repository::Status> objects.

=encoding utf8

=cut

=head1 AUTHOR

Jakob Voß

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Jakob Voß.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
