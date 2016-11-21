#!/usr/bin/perl

use strict;

my %imiss;
my %removed;

open IMISS, '<', $ARGV[0].".imiss"
        or die "Cannot open genotypes file (".$ARGV[0].".genome): $!\n";
print "Reading PLINK .imiss file ".$ARGV[0].".imiss\n";

#build an hash with the FID and IID as keys, the F_MISS is the value
while(<IMISS>){
	s/^\s+//;
    my @fields = split /\s+/, $_;
    $imiss{$fields[0]}{$fields[1]} = $fields[5];
}

open GENOME, '<', $ARGV[0].".genome"
        or die "Cannot open genotypes file (".$ARGV[0].".genome): $!\n";
open OUT, '>', "fail-IBD-QC.txt";
open OT, '>', "fail_IBD-QC-more.txt";
print "Reading PLINK .genome file ".$ARGV[0].".genome\n";
print OT "FID\tIID\tRELATIVE\tPI_HAT\tF_MISS\n";

my $count = 0;

#checks to see if pi hat is greater than 0.185 btw two people
#if it is, check which individual has a higher missingess rate and put that
#into file. It ensures, it doesnt write an id more than once

while(<GENOME>){
    s/^\s+//;
    my @fields = split /\s+/, $_;
 	if($fields[9] > 0.185){
 		if($imiss{$fields[0]}{$fields[1]}>$imiss{$fields[2]}{$fields[3]}){
 			unless($removed{$fields[0]}{$fields[1]}){
				++$count;
 				print OUT "$fields[0]\t$fields[1]\n";
 				print OT "$fields[0]\t$fields[1]\t$fields[2]\t$fields[3]\t$fields[9]\t$imiss{$fields[0]}{$fields[1]}\n";
 				$removed{$fields[0]}{$fields[1]} = 1;
 			}
 		}
 		elsif($imiss{$fields[0]}{$fields[1]}<$imiss{$fields[2]}{$fields[3]}){
 			unless($removed{$fields[2]}{$fields[3]}){
				++$count;
 				print OUT "$fields[2] $fields[3]\n";
				print OT "$fields[0]\t$fields[1]\t$fields[2]\t$fields[3]\t$fields[9]\t$imiss{$fields[0]}{$fields[1]}\n";
 				$removed{$fields[2]}{$fields[3]} = 1;
 			}
 		}
 		else{
 			unless($removed{$fields[0]}{$fields[1]}){
				++$count;
 				print OUT "$fields[0] $fields[1]\n";
				print OT "$fields[0]\t$fields[1]\t$fields[2]\t$fields[3]\t$fields[9]\t$imiss{$fields[0]}{$fields[1]}\n";
 				$removed{$fields[0]}{$fields[1]} = 1;
 			}
 		}
 	}#end if
}#end while
    
print "$count individual(s) failed IBD test\n";
print "Check fail_IBD-QC-more.txt for more details on the individuals\n";

