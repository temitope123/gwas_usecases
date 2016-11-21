#!/bin/perl
#
# @File runpca-qc.pl
# @Author Damilare
# @Created Jul 18, 2015 12:21:11 PM
#

use strict;
use warnings;
use Getopt::Long;
use 5.010;

main(@ARGV);

sub main {
	my $filename;
	GetOptions( "fn|fname:s" => \$filename);
	unless($filename){
		say "Please enter filename:";
		say "perl runpca-qc.pl --f|fname filename";
		exit;
	}
	open (FH, '<', $filename) or error("Cannot open file");
	open (OUT, '>', "fail-pca.txt");
	open (OT, '>', "pass-pca.txt");
	my $count = 0;
	while(<FH>){
		#say "Outside unless" . $_;
		s/^\s+//;
		unless(m/^\#/){			
			#say "inside unless" .$_;
			my @list = split('\s+');
			if($list[2] <= 0.072){
			   my @res = split(':', $list[0]);
			     if($list[0] =~ m/^\d/){
			   	say OUT $res[0] . "\t" . $res[1];
				}#end unless
			   ++$count;
			}#end if
			else{
			   my @res = split(':', $list[0]);
			   say OT $res[0];			  
			}#end else

			#say $list[0] . $list[1] . $list[2] . $list[3];
		}#end unless
	}#end while
	say "$count failed";
	close FH;
	close OT;
	close OUT;
}#end main

sub error{
	my $e = shift | "Unknown error";
	say "$0: $e";
	exit;
}#end error
