#!/bin/perl
#
# @File checksex.pl
# @Author Damilare
# @Created Jul 18, 2015 12:21:11 PM
#

use strict;
use warnings;
use Getopt::Long;
use 5.010;

main(@ARGV);

sub main {
    my $filename;# = "result.txt";
    GetOptions( 'f|file:s' => \$filename );
    unless($filename) {
        print "Please enter file name of your results file:\n";
        print "--f name of file\n";
        exit;
    }    #end if

    say "Checking $filename....";
    open( FH, $filename ) || error("Cannot open file");
    open( OUT1, '>', "failed-sexcheck-qc.txt" ) || error("Cannot open file");;
    open( OUT2, '>', "failed-sexcheck.probes" ) || error("Cannot open file");;
    print OUT2 "FAM_ID\tIID\tPEDSEX\tSNPSEX\tSTATUS\tF\n";
    my $count = 0;
    while (<FH>) {
        if ( !m/^FID/ ) {

            # s/\s+/\t/;
	    s/^\s+//; #remove preceding white spaces
            my @list = split('\s+');
#	    say $list[0];
            if ( $list[4] eq "PROBLEM" ) {
                ++$count;
                print OUT2 "$list[0]\t$list[1]\t$list[2]\t$list[3]\t$list[4]\t$list[5]\n";
                print OUT1 "$list[1]\n";
		#say $list[4];
            }
		#say $list[4];
            #say "$list[0]\t$list[1]\t$list[2]\t$list[3]\t$list[4]\t$list[5]";
            #say "$list[1]\t$list[2]\t$list[3]\t$list[4]\t$list[5]";
        }    #end if
    }    #end while
    say "Outputting analysis...";
    say( $count > 0
        ? "$count individual(s) failed this qc"
        : "There were no individuals with sex problems!"
    );
close OUT1;
close OUT2;
close FH;
}    #end main

sub error {
    my $e = shift || "unknown error!";
    say("$0: $e");
    exit 0;
}    #end error

