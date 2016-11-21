#!/bin/perl
#
# @File prep_evoker.pl
# @Author Damilare
# @Created Jul 18, 2015 12:21:11 PM
#

use strict;
#use warnings;
use Getopt::Long;
use 5.010;
use Data::Dumper qw(Dumper);

main(@ARGV);

sub main {
    my $filename;
    my $list;
    GetOptions( 'f|file:s' => \$filename, 'l|list:s' => \$list );
    unless($filename && $list){
        print "Please enter allele summary file:\n";
        print "--f name of file --l list of snps to include\n";
        exit;
    }    #end if    

    #variables
    my @ids;
    my $count=0;
    my $hf = {};
    #open summary file
    #system("dir");
    # birdseed.summary.txt
    open(FH, $filename) || error("Can't open file $filename");
#    open(FH, "birdseed.summary.txt") || error("Can't open file");
    #read ids
    say "Getting Fam ids";
    while (<FH>){
        if(/^probeset_id/g){
            @ids = split('\s+');
            #shift @ids;
        }#end if
    }#end while
    close FH;
    
    my $length = @ids;
    my $len =  $length -1;
    say "$len ids found in file";
    #say (join("\n", @ids));
    
    #say $_ for each @ids;
    # say $length;
    # for (my $var = 1; $var < $length; $var++) {
        # say $var;
        # say "$var: $ids[$var]";
    # }
    my $cnt = 0;
    open (LH, $list);
    my @snp2include = <LH>;
    chomp(@snp2include);
    my $snpnum = @snp2include;
    #$len =  $snpnum - 1;    
    say "$snpnum snps found in the snplist.txt file";
    foreach (@snp2include){
        my @list = split('\s+');
        
        $hf ->{$list[1]} = {};
    }
    
    say "Reading allele intensities from $filename";
    open(FH, $filename) || error("Can't open file $filename");
    while(<FH>){
        chomp($_);
        if(/^SNP_A/){
            my @list = split('\s+');
            my $currsnp = substr $list[0], 0, -2;
        if(exists $hf->{$currsnp}){     
            if($count eq 0){
                say "Working on $currsnp...";
                my $ste = substr $list[0], -4, 2;
                error("Illegal state $ste") if ($ste eq '-A');
                my $hh = {};
              for (my $var = 1; $var < $length; $var++) {
                  $hh->{$ids[$var]} = [$list[$var]];
              }#next var
               ++$count;
               $hf ->{$currsnp} = $hh;
               #say Dumper $hf;
            }#if count ==0
            else{
                my $ste = substr $list[0], -4, 2;
                error("Illegal state $ste") if ($ste eq '-B');
                my $val = $hf->{$currsnp};
                for (my $var = 1; $var < $length; $var++) {
                  my $array = $val->{$ids[$var]};
                  push @$array, $list[$var];
#                  say "else";
#                 say Dumper @$array;
              }#next var
              $count =0;
            }            
            ++$cnt;
            #last if ($i==8); 
      }#$currsnp ~~ @snp2include               
        }#if /SNP_A/    
    }#end while     
     open(OT, '>', "allele_intensity.txt") or error("Cant create file");
     print OT "SNP\t";
     my @temp = @ids;
     shift @temp;
     foreach my $id (@temp){
            print OT "$id\t$id\t";
        }
     say OT "";
     say $length;
     foreach my $k (keys %$hf){
         my @line;
         $line[0] = $k;
        my $val = $hf->{$k};
        for (my $i = 1; $i < $length; $i++) {
            my $array = $val->{$ids[$i]};                   
            push @line, @$array;# if @$array;
        }#next i
         say OT join("\t\t", @line);
     }#next key     
    say "Count: $cnt";
    #say Dumper $hf;
 }    #end main

sub error {
    my $e = shift || "unknown error!";
    say("$0: $e");
    exit 0;
}    #end error
