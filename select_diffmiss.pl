#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

main(@ARGV);

sub main{
      my $filename;
      my $count;
GetOptions('f|file:s' => \$filename);
	unless ($filename){
	  print "Please enter file name of your .missing file:\n";
	  print "--f name of file\n";				
	  exit;				
	}#end if
open IN, '<', $filename or die "Cannot open missing file \n";
open OUT, '>', "fail_diffmiss.txt";

while(<IN>){
	s/^\s+//;
	my @fields = split(/\s+/);
	unless($fields[0] eq 'CHR'){
		if($fields[4] < 0.00001){
			print OUT "$fields[1]\n";
			++$count;
		}
	}
}

print "$count snps failed!";
}#end main
