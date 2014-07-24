#!/usr/bin/perl
use strict;
use warnings;
#
#
package Lookup;

sub tags_match {
    my ($sr,$br)=@_;
    my @small_array=@{$sr};
    my @big_array=@{$br};

    my %big_array_hash=();
    @big_array_hash{@big_array}=();

    for my $v (@small_array) {
        return 0 unless(exists $big_array_hash{$v});
    }
    return 1;
}

sub decompose {
    my $line=shift;
    chomp $line;

    my %record=();
    my $pos=index($line,':');
    my $tags=substr($line, 0, $pos);

    my $description=substr($line,$pos+1); 
    my $pos_next=index($description, ':');

    my $command=substr($description,$pos_next+1); $command=~s/\s+(.*)/$1/;
    $description=substr($description, 0, $pos_next);

    my @tempAry=split(/\s*,\s*/,$tags);
    my @tmpAry=();
    foreach my $s (@tempAry) {
        $s=~s/^\s*(.*)\s*$/$1/;
        push(@tmpAry, $s);
    }
    $record{'tags'}=\@tmpAry;
    $record{'description'}=$description;
    $record{'command'}=$command;

    return %record;
}

1;
