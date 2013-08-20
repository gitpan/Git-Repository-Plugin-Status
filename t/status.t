use strict;
use warnings;
use Test::More;
use File::Spec;
use Test::Git;
use Git::Repository;

# clean up the environment
delete @ENV{qw(GIT_DIR GIT_WORK_TREE)};
$ENV{LC_ALL}              = 'C';
$ENV{GIT_AUTHOR_NAME}     = 'Test Author';
$ENV{GIT_AUTHOR_EMAIL}    = 'test.author@example.com';
$ENV{GIT_COMMITTER_NAME}  = 'Test Committer';
$ENV{GIT_COMMITTER_EMAIL} = 'test.committer@example.com';

# first create a new empty repository
my $r      = test_repository;
my $dir    = $r->work_tree;
my $gitdir = $r->git_dir;


# test rename
my $file = File::Spec->catfile( $dir, 'foo' );
do { open my $fh, '>', $file };
$r->run( add => 'foo' );
$r->run( commit => '-m', '1st' );
$r->run( mv => 'foo', 'bar' );
$file = File::Spec->catfile( $dir, 'file2' );
do { open my $fh, '>', $file };
$r->run( add => 'file2' );

ok( !eval { $r->status }, 'no status() method' );
use_ok 'Git::Repository', 'Status';
my @s = eval { $r->status };
ok( scalar @s, 'status() method exists now' );

ok($s[0]->index eq 'R' && $s[0]->work eq ' ', 'renamed');
is $s[0]->status, 'R ';
is $s[0]->path1, 'foo';
is $s[0]->path2, 'bar';

ok($s[1]->index eq 'A' && $s[1]->work eq ' ', 'added');
is $s[1]->status, 'A ';
is $s[1]->path1, 'file2';
is $s[1]->path2, undef;


# test options
my @badopts = (qw(-b -s --short --long --column=always));
for my $badopt (@badopts) {
    ok( !eval { $r->status($badopt) }, "bad options: $badopt" );
    like( $@, qr/^status\(\) cannot parse $badopt/, '.. expected error' );
}

done_testing;

