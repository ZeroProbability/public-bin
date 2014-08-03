#!/usr/bin/perl 

use strict;
use warnings;

use FindBin;
use lib $FindBin::Bin;

use Lookup;

use Test::More qw(no_plan);

my %decomposed=Lookup::decompose("  tag1,    tag2   , tag3:description of the command: some command here");

# ---- testing 'decompose' method -----------
is(3,scalar @{$decomposed{'tags'}}, 'Count of commands match');
my @expected=('tag1', 'tag2', 'tag3');
is_deeply(\@expected, \@{$decomposed{'tags'}}, 'arrays match');
is("description of the command",$decomposed{'description'}, 'description test');
is("some command here",$decomposed{'command'}, 'command test');

# ---- testing 'tags_match' method -----------
my @small_1=qw/tag1/;
my @big=qw/tag1 tag2 tag3/;
ok(Lookup::tags_match(\@small_1,\@big), 'simple case 1');
@small_1=qw/tagx/;
ok(!Lookup::tags_match(\@small_1,\@big), 'simple case 2');
@small_1=qw/tag1 tag2/;
ok(Lookup::tags_match(\@small_1,\@big), 'simple case 3');
@small_1=qw/tag1 tagx/;
ok(!Lookup::tags_match(\@small_1,\@big), 'simple case 4');
# --- additional test
my %decomposed=Lookup::decompose("groovy, env : import groovy environment: . $(locate ~/*/groovy*env*.sh)");

is(3,scalar @{$decomposed{'tags'}}, 'Count of commands match');
my @expected=('tag1', 'tag2', 'tag3');
is_deeply(\@expected, \@{$decomposed{'tags'}}, 'arrays match');
i
