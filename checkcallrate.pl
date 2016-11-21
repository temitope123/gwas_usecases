#!/bin/perl
#
# @File checkcallrate.pl
# @Author User
# @Created Jul 18, 2015 12:21:11 PM
#

use strict;
use warnings;
use Getopt::Long;
use 5.010;

main(@ARGV);

sub main{
		#Get command line argument		
		my $filename;
			GetOptions('f|file:s' => \$filename);
			unless ($filename){
				print "Please enter file name of your report file:\n";
				print "--f name of file\n";		
				exit;
			}#end if
		
		#open the file for reading
		open(FH, $filename) or error("Cannot open file");
		open(OT, '>', "birdseed_callrate_failed.txt") or error("Cannot open file for writing");
		open(OT1, '>', "birdseed_crf_more.txt") or error("Cannot open file for writing");
		my @list;
		my $count = 0;
		my $tt = 0;
		while(<FH>){
		   if(!(m /^\#/) and !(m/^cel_files/)){
			@list = split('\t');
			++$tt;
#			say $tt . " " . substr ($list[0], 0,15) . "\t$list[1]\t$list[2]\t$list[3]\t$list[4]";
			unless($list[2] > 97){
				say OT "$list[0]";
				say OT1 "$list[0]\t$list[1]\t$list[2]\t$list[3]\t$list[4]";
				++$count;
			}#end unless
		}
		}#end while
		if($count > 0){
		  say "$count cels files were below 97% call rate";
		  say "cel ids written to birdseed_callrate_failed.txt";
		  say "Check birdseed_crf_more.txt for details on the cel ids";
		}#end if
		else{
		  say ("Your datasets are perfect!");
		}
	}#end main
	
sub error{
	my $e = shift || 'unknown error';
	say "$0: $e";
	exit;
}#end error
