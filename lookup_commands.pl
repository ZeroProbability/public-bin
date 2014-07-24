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

# - read contents from the file
open (MYFILE, $commands_file) || die "Unable to open file $commands_file";
my @records=<MYFILE>;
close(MYFILE);

my @commands=@{Lookup::extract_commands(\@records, \@lookup_tags)};

# - display menu
my $count=0;
if((scalar @commands) > 0) {
    print STDERR "Commands \n----------------------------------------------\n";
}
foreach my $command (@commands) {
    print STDERR (++$count).':'.$command->{'command'}."\n";
    print STDERR "\t\t - ".$command->{'description'}."\n";
}
if($count==0) {
    print STDERR "No command found for tags - @lookup_tags.\n";
    exit 1;
}

# - if there were more then one command prompt user
my $exec_command="";
if($count > 1) {
    print STDERR "which one do you want to execute?\n";
    my $option=<STDIN>;
    chomp $option;
    exit 0 if($option eq "");
    $exec_command=$commands[$option-1]->{'command'};
} else {
    $exec_command=$commands[0]->{'command'};
}

# - if there are place holders ask for values
while($exec_command =~/\${(.*?)(:(.*?))?}/) {
    my $var=$1;
    my $value=(defined $3)?$3:"";

    print STDERR "\nEnter value for '$var' (default: '$value')?\n";
    my $changed_value=<STDIN>;
    chomp $changed_value;
    $value=$changed_value if($changed_value ne "");

    $exec_command=~s/\${.*?}/$value/;
}

# - print chosen command - shell function should pick this up and execute
print $exec_command;
exit 0;

