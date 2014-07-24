#!/usr/bin/perl
#
use strict;
use warnings;

use FindBin;
use lib $FindBin::Bin; 

use Lookup;

my $commands_file=$ENV{"HOME"} . "/commands.txt";
if (exists $ENV{'LOOKUP_COMMAND_FILE'}) {
   $commands_file=$ENV{'LOOKUP_COMMAND_FILE'}
}

if( ! -e $commands_file) {
    print STDERR "Commands file '${commands_file}' does not exist","\n";
    exit 1;
}

if(scalar @ARGV==0) {
    print STDERR "No arguments passed.","\n";
    exit 1;
}
my @lookup_tags=@ARGV;

open (MYFILE, $commands_file) || die "Unable to open file $commands_file";
my @records=<MYFILE>;
close(MYFILE);

@records=grep(!/^\s*#/, @records);   # remove comments
@records=grep(!/^\s*$/, @records);   # remove empty lines

my @commands=();
foreach my $line (@records) {
    my %record=Lookup::decompose($line);
    my $matched=Lookup::tags_match(\@lookup_tags, \@{$record{'tags'}});

    if ($matched) {
        push (@commands,\%record);
    }
}

my $count=1;
foreach my $record (@commands) {
    print STDERR $count++.':'.$record->{'command'}."\n";
    print STDERR "\t\t - ".$record->{'description'}."\n";
}

print STDERR "which one do you want to execute?\n";
my $option=<STDIN>;
chomp $option;
exit 0 if($option eq "");

print $commands[$option-1]->{'command'};

