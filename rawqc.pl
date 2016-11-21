#!/bin/perl
#
# @File rawqc.pl
# @Author Damilare
# @Created Jul 18, 2015 12:21:11 PM
#

use strict;
use warnings;
use Getopt::Long;
use 5.010;

main(@ARGV);

sub main{
	my $filename;
	GetOptions('f|file:s' => \$filename);
	if(!defined($filename)){
		print "Please enter file name of your results file:\n";
		print "--f name of file\n";		
		exit;
	}#end if

	say "Checking $filename....";
	open (FH, $filename) || error("Cannot open file");
	open (OUT1, '>', "failed-raw-qc.txt");
	open (OUT2, '>', "failed-raw-qc-values.txt");
	print OUT2 "CEL_ID\tQCR\tCQC\n";
	my $count = 0;
	while (<FH>) {
		unless((m/^cel/) || (m/\#/)){
			 my @list = split('\s+');			 
			 if(($list[1] < 0.86) || ($list[7] < 0.4)){
			 	 ++$count;
			 	 print OUT2 "$list[0]\t$list[1]\t$list[7]\n";
			 	 print OUT1 "$list[0]\n";
			 	 #say $list[1];
			 }
			 #say $list[1];
		}#end if
	}#end while	
	say "Outputting analysis...";
	say ($count > 0 ? "$count cel file(s) failed this qc" : "Your data is perfect!!!");
	if($count > 0){
   	 say("Check failed-raw-qc.txt for list of cels");
	 say("failed-raw-qc-values.txt for full details on the cel files");
	}#end if
}#end main

sub error{
	my $e = shift || "unknown error!";
	say("$0: $e");
	exit 0;
}#end error
