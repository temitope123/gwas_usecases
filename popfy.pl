#!/usr/bin/perl
#
# @File popfam.pl
# @Author User
# @Created Jul 18, 2015 12:21:11 PM
#

use strict;
use warnings;
use 5.010;
use Data::Dumper qw(Dumper);
use Getopt::Long;
main(@ARGV);
sub main{
    my $fam;
        my $phe;

        GetOptions('p:s' => \$phe,
                   'f:s' => \$fam);

        unless($phe && $fam){
                say "To execute script run:";
                say("perl popfy.pl -p phe file -f fam file\n Outputs new.fam file ");
                exit;
        }#end unless

        open(FAM,$fam) || error("Cannot open file");
        open(PHE, $phe) || error("Cannot open file");

        my $_phe = {};

        while (<PHE>){
            my @list = split('\s+');
            $_phe->{$list[1]} = $list[2];

        }#end while

        open(NFAM,'>', "new.fam") || error("Cannot open file");

        while (<FAM>){
            my @list = split('\s+');

            say NFAM "$list[0]\t$list[1]\t$list[2]\t$list[3]\t$list[4]\t$_phe->{$list[5]}" if $_phe->{$list[5]};

        }#end while

#say Dumper $_phe;
}#end main