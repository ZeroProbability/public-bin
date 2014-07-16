#!/usr/bin/perl -d  
#
use strict;

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

open (MYFILE, $commands_file);

my @commands=();
my $count=1;
while(my $line=<MYFILE>) {
    chomp $line;
    my $pos=index($line,':');
    next if($line=/^\s+#/); # ignore all lines starting with #

    my $tags=substr($line,0,$pos);
    my $description=substr($line,$pos+1); 
    my $pos_next=index($description, ':');
    my $command=substr($description,$pos_next+1); $command=~s/\s+(.*)/$1/;
    $description=substr($description, 0, $pos_next);
    next if($command eq "");

    my $match_found=0;
    foreach my $arg (@ARGV) {
        foreach my $tag (split(/,/, $tags)) {
            $tag =~ s/^\s+|\s+$//g;
            $match_found++ if ($arg eq $tag || "${arg}s" eq $tag  || 
                $arg eq "${tag}s" );
        }
    }
    if ($match_found==($#ARGV+1)) {
        print STDERR $count++, " : ", $command, "\n";
        print STDERR "\t\t - $description\n";
        push (@commands,$command);
    }
}

close (MYFILE);

if(scalar @commands==0) {
    print STDERR "No command found matching those tags\n";
    exit 0
} 

print STDERR "which one do you want to execute?\n";
my $option=<STDIN>;
chomp $option;
exit 0 if($option eq "");

print $commands[$option-1];
