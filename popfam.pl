#!/bin/perl
#
# @File popfam.pl
# @Author User
# @Created Jul 18, 2015 12:21:11 PM
#

use strict;
use warnings;
use 5.010;
use Data::Dumper qw(Dumper);

main(@ARGV);

sub main{
	my $home='/home/darefalola';
	
	#fam files
	open(OT, '>', "$home/hapmap/hmap1.fam") || error("Cannot open file");
	open(FH, "$home/hapmap/hmap.fam") || error("Cannot open file");
	
	#pop files
	open(OT1, "$home/hapmap/pops/asw.txt") || error("Cannot open file");
	open(OT2, "$home/hapmap/pops/ceu.txt") || error("Cannot open file");
	open(OT3, "$home/hapmap/pops/chb.txt") || error("Cannot open file");
	open(OT4, "$home/hapmap/pops/chd.txt") || error("Cannot open file");
	open(OT5, "$home/hapmap/pops/gih.txt") || error("Cannot open file");
        open(OT6, "$home/hapmap/pops/jpt.txt") || error("Cannot open file");
        open(OT7, "$home/hapmap/pops/lwk.txt") || error("Cannot open file");
        open(OT8, "$home/hapmap/pops/mex.txt") || error("Cannot open file");
        open(OT9, "$home/hapmap/pops/mkk.txt") || error("Cannot open file");
        open(OT10, "$home/hapmap/pops/tsi.txt") || error("Cannot open file");
        open(OT11, "$home/hapmap/pops/yri.txt") || error("Cannot open file");

	my @pop1 = <OT1>;
	chomp(@pop1);
	my @pop2 = <OT2>;
	chomp(@pop2);
	my @pop3 = <OT3>;
	chomp(@pop3);
	my @pop4 = <OT4>;
	chomp(@pop4);
	my @pop5 = <OT5>;
	chomp(@pop5);
	my @pop6 = <OT6>;
	chomp(@pop6);
	my @pop7 = <OT7>;
	chomp(@pop7);
	my @pop8 = <OT8>;
	chomp(@pop8);
	my @pop9 = <OT9>;
	chomp(@pop9);
	my @pop10 = <OT10>;
	chomp(@pop10);
	my @pop11 = <OT11>;
	chomp(@pop11);

	#merge all files and put population ids
        my @pp = map { $_ .  "\tASW\n"} @pop1;
	my @pp2 = map { $_ .  "\tCEU\n"} @pop2;
	my @pp3 = map { $_ .  "\tCHB\n"} @pop3;
	my @pp4 = map { $_ .  "\tCHD\n"} @pop4;
        my @pp5 = map { $_ .  "\tGIH\n"} @pop5;
	my @pp6 = map { $_ .  "\tJPT\n"} @pop6;
	my @pp7 = map { $_ .  "\tLWK\n"} @pop7;
	my @pp8 = map { $_ .  "\tMEX\n"} @pop8;
	my @pp9 = map { $_ .  "\tMKK\n"} @pop9;
	my @pp10 = map { $_ .  "\tTSI\n"} @pop10;
	my @pp11 = map { $_ .  "\tYRI\n"} @pop11;


	push @pp, @pp2;
       	push @pp, @pp3;
	push @pp, @pp4;
	push @pp, @pp5;
	push @pp, @pp6;
	push @pp, @pp7;
	push @pp, @pp8;
	push @pp, @pp9;
	push @pp, @pp10;
	push @pp, @pp11;

	 while (<FH>){
		chomp($_);
		s/^\s+//;
		my @list = split('\s+'); #fam file
		foreach my $line (@pp){
		  $line =~ s/^\s+//;
		  my @pops = split('\s+', $line); #pop files
		  if(($list[0] eq $pops[0]) and ($list[1] eq $pops[1])){
			$list[5] = $pops[2];
			last;
		  }#end if
		}#end foreach
		say OT join("\t", @list);
	 }#end while
}#end main

sub error{
	my $e = shift | 'Unknown error';	
	say "$e: $0";
	exit;
}
