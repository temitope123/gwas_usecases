#!/usr/bin/perl -w
#
# @File select_het_miss.pl
# @Author User
# @Created Aug 5, 2015 12:21:11 PM
#

use strict;
use warnings;
use Getopt::Long;
use 5.010;

main(@ARGV);

sub main{
	my $cut_het_high;
	my $cut_het_low;
	my $cut_miss;
	my $imissfile;
	my $hetfile;

	GetOptions('im|imiss:s' => \$imissfile,
				'het:s' => \$hetfile,
				 'cm:s' => \$cut_miss,
				 'chl:s' => \$cut_het_low,
				 'chh:s' => \$cut_het_high);
	unless($cut_het_high && $cut_het_low && $cut_miss && $imissfile && $hetfile){
		say "To execute script run:";
		say("perl select_het_miss.pl -–im [.miss file] 
			–het [.het file] –cm [cut miss value] 
			 –chl [cut het low value] –chh [cut het high value]");
		exit;
	}

	open(MISSFILE,$imissfile) || error("Cannot open file");
	open(HETFILE, $hetfile) || error("Cannot open file");
	my @all=<HETFILE>;
	chomp(@all);
	open(OUT,">fail-miss_het.txt") || error("Cannot open file");
	#print OUT "FID\t
	open(OT,">fail_miss_het_more.txt") || error("Cannot open file");
	print OT "FID\tIID\tMissingness\tMean Het\n";
	my $line=0;
	while(<MISSFILE>){
		chomp($_);

		if($line>=1){
			#chomp($_);
			$_ =~ s/^\s+//;
			my @parts_miss=split(/\s+/,$_);
			my $missing=$parts_miss[5];

			$all[$line] =~ s/^\s+//;
			my @parts_het=split(/\s+/,$all[$line]);
			my $meanHet=sprintf("%.3f", ($parts_het[4]-$parts_het[2])/$parts_het[4]);

			if(($missing>$cut_miss) or ($meanHet>$cut_het_high) or ($meanHet<$cut_het_low)){
				print OUT $parts_miss[0], "\t",$parts_miss[1], "\n";
				print OT $parts_miss[0],"\t",$parts_miss[1],"\t",$missing,"\t",$meanHet,"\n";
			}#end if missing
		}#end if line
	++$line;
 }#end while
}#end main

sub error{
	my $e = shift || 'Unknown Error';
	say "$0: $e";
	exit;
}
