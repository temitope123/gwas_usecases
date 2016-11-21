#!/usr/bin/perl -w
#pedfilemaker.pl
#version1: 21/12/2010

print "\n\n\t\@-------------------------------------------------------\@\n";
print "\t| pedfilemaker.pl | v.1.0 | 05/Jan/2011 |\n";
print "\t|-------------------------------------------------------|\n";
print "\t| (c) 2010 Christian Vogler, Uni Basel\t\t|\n";
print "\t| mailto: christian.vogler\@unibas.ch\t|\n";
print "\t|-------------------------------------------------------|\n";
print "\t|\t\tno warranty whatsoever!\t\t\t|\n";
print "\t|\t\t\tHave fun!!!\t\t\t|\n";
print "\t|\t\t\tdedicated to:\t\t\t|\n";
print "\t|\t\t\"ROCK'N'ROLL SIIIIIIIIIIIIIEEEEEEEEEEENNNNNNCCCCCEEEEEEEEEEEE!!!!!!\"\t\t|\n";
print "\t\@-------------------------------------------------------\@\n\n\n\n\n\n";



#last_modified: 26/01/2011

#changes:
#turned off strand flipping (unresolved error) #26/01/2011
#fixed bracket interpretation as metachar in
#regex m/^\Q$variable\E/ #24/01/2011
#added -ni option #18/01/2011
#set family ID in pedfile to original cel_name #18/01/2011
#fixed duplicate cel bug #18/01/2011
#corrected strand issue of second allele #13/01/2011
#output additional plink versions with AFFY-id 
#and rs_id of mapfile #05/01/2011
#changed the recoding of missing values to 0 0 #05/01/2011
#added time_stamps and snp_progress_iterator #29/12/2010


use strict;
use warnings;
use Getopt::Long;
use Time::HiRes;

sub roundup {
my $n = shift;
return(($n == int($n)) ? $n : int($n + 1))
}


my $now_string = localtime;

#($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

my $affy_calls;
my $report;
my $annot;
my $out_dir;
my $subjects_in_files = 50;

GetOptions( "ac|affy_calls:s" => \$affy_calls, 
"r|report:s" => \$report, 
"an|annot:s" => \$annot, 
"o|out_dir:s" => \$out_dir,
"ni|num_of_ind:s" => \$subjects_in_files);

if(!defined($affy_calls)||!defined($report)||!defined($annot)||!defined($out_dir)){
print "Synopsis:\n";
print "This programme was written to create ped- and mapfiles from the affymetrix birdseed files.\n\n\n";
print "Usage: pedfilemaker.pl -affy_calls <birdseed.calls.txt> -report <birdseed.report.txt> -annot <GenomeWideSNP_6.naXX.annot.csv> -out_dir <> \n\n";

print "\t-affy_calls\t\| -ac\n";
print "\t-report\t\t\| -r\n";
print "\t-annot\t\t\| -an\n";
print "\t-out_dir\t\| -o\n\n";
print "\toptional: set number of individuals in split-files (default set to 50):\n";
print "\t-num_of_ind\t| -ni\n\n\n";


exit;
}


my $start = Time::HiRes::gettimeofday();

my $affy_calls_rec = "$out_dir" . "/birdseed.calls_recoded.txt";
my $map = "$out_dir" . "/mapfile.map";
my $map_plink_rs_id = "$out_dir" . "/plink_mapfile_rs_id.map";
my $map_plink_AFFY_id = "$out_dir" . "/plink_mapfile_AFFY_id.map";
my $ped = "$out_dir" . "/pedfile.ped";
my $strandfile = "$out_dir" . "/strandfile.txt";
my $logfile = "$out_dir" . "/pedmaker.log.txt"; 


if (-e "$logfile") {unlink $logfile};

open(OUT7, ">>$logfile") || die print "Can't open $logfile\n";

print(OUT7 "Programme pedfilemaker.pl logfile\n\n»»»Started run:\t$now_string\n\n");



print "\n\n»»»Determining number of subjects in $affy_calls...\n";
print (OUT7 "\n\n»»»Determining number of subjects in $affy_calls...\n");


open(IN1,"<$affy_calls") || die print "Can't open recoded birdseed.calls.txt\n";

my @subjects;
my $total_subjects;

while (<IN1>){
if(m /^probeset_id/){
my $subjects = $_;
@subjects = (split /\t/, $subjects);
shift (@subjects);

$total_subjects = $#subjects+1;
print "There are ", $#subjects+1, " subjects in $affy_calls\n";
}
}
close (IN1);

print "\t»»»Done!\n";
print (OUT7 "\t»»»Done!\n");

my $end1 = Time::HiRes::gettimeofday();
print "seconds elapsed:\n";
printf("%.2f\n", $end1 - $start);


open(IN1,"<$affy_calls") || die print "Can't open birdseed.calls.txt\n";
open(IN3,"<$annot") || die print "Can't open $annot\n";

open(OUT1,">$map") || die print "Can't open $map\n";
open(OUT2,">$strandfile") || die print "Can't open $strandfile\n";
open(OUT3,">$affy_calls_rec") || die print "Can't open $affy_calls_rec\n";
open(OUT4,">$ped") || die print "Can't open $ped\n";
open(OUT5,">$map_plink_rs_id") || die print "Can't open $map_plink_rs_id\n";
open(OUT6,">$map_plink_AFFY_id") || die print "Can't open $map_plink_AFFY_id\n";

print "\n\n »»»Reading in $annot...\n\n";
print (OUT7 "\n\n »»»Reading in $annot...\n\n");

my %snp_map;
while(<IN3>){
if((!m /^\#/) && (!m /^"Probe Set ID"/)){

s/\"//g;

my @tmp = (split /,/, $_);
my($snp_annot) = $tmp[0];
#print "$snp_annot\n";

push (@{$snp_map{$snp_annot}},@tmp[1, 2, 3, 4,8,9]);
}
}





print "\t»»»Done!\n";
print (OUT7 "\t»»»Done!\n");


my $end2 = Time::HiRes::gettimeofday();
print "seconds elapsed:\n";
printf("%.2f\n", $end2 - $start);


print "\n\n»»»Creating mapfile...\t\t»»»writing output to $map\n";
print "\n\n»»»Creating Strandfile...\t»»»writing output to $strandfile\n";
print "»»»Recoding alleles...\t\t»»»writing output to $affy_calls_rec\n";

print (OUT7 "\n\n»»»Creating mapfile...\t\t»»»writing output to $map\n");
print (OUT7 "\n\n»»»Creating Strandfile...\t»»»writing output to $strandfile\n");
print (OUT7 "»»»Recoding alleles...\t\t»»»writing output to $affy_calls_rec\n");



$" = "\t";
while (<IN1>){
if((m /^\#/) || (m /^probeset_id/)){
print (OUT3 $_);
}
}
close (IN1);
close (OUT3);

my $snp_stat_iterator;
my $snp_progress = 0;
open(IN1,"<$affy_calls") || die print "Can't open birdseed.calls.txt\n";
open(OUT3,">>$affy_calls_rec") || die print "Can't open $affy_calls_rec\n";
while (<IN1>){

if(m/^(SNP\S+)\t/){
my ($snp)=($1);

if (exists $snp_map{$snp}){

my $current = $snp_map{$snp};
my $rsid = $current->[0];
my $chr = $current->[1];
if ($chr ne "---") {
my $pos = $current->[2];
my $strand =$current->[3];


my $alleleA =$current->[4];
my $alleleB =$current->[5];

#if (($strand eq "-") && ("$alleleA" eq "A"))
# {$alleleA = "T";

# }
#if (($strand eq "-") && ("$alleleA" eq "C"))
# {$alleleA = "G";

# }
#if (($strand eq "-") && ("$alleleA" eq "G"))
# {$alleleA = "C";

# }
#if (($strand eq "-") && ("$alleleA" eq "T"))
# {$alleleA = "A";

# }

#if (($strand eq "-") && ("$alleleB" eq "A"))
# {$alleleB = "T";

# }
#if (($strand eq "-") && ("$alleleB" eq "C"))
# {$alleleB = "G";

# }
#if (($strand eq "-") && ("$alleleB" eq "G"))
# {$alleleB = "C";

# }
#if (($strand eq "-") && ("$alleleB" eq "T"))
# {$alleleB = "A";

# } 


print (OUT1 "$chr\t$rsid\t0.001\t$pos\t$alleleA $alleleB\n");
print (OUT5 "$chr $rsid 0.001 $pos\n");
print (OUT6 "$chr $snp 0.00.1 $pos\n");
print (OUT2 "$pos\t$strand\n");
my @calls = (split /\t/, $_);
shift @calls;

map (s/-1/N\_N/g, @calls);
map (s/0/$alleleA\_$alleleA/g, @calls);
map (s/1/$alleleA\_$alleleB/g, @calls);
map (s/2/$alleleB\_$alleleB/g, @calls);
map (s/N\_N/0\_0/g, @calls);

print (OUT3 "$snp\t@calls");}

$snp_stat_iterator++;

if($snp_stat_iterator == 10000){
$snp_progress = $snp_progress + $snp_stat_iterator;
print "\t\t»»»$snp_progress SNPs recoded...\n";
$snp_stat_iterator = 0;
my $end35 = Time::HiRes::gettimeofday();
print "seconds elapsed:\n";
printf("%.2f\n", $end35 - $start);}

}
else {print "$snp_map{$snp} not found in $annot"};
}
}

print "\t»»»Done!\n";
print (OUT7 "\t»»»Done!\n");
my $end3 = Time::HiRes::gettimeofday();
print "seconds elapsed:\n";
printf("%.2f\n", $end3 - $start);

close OUT1;
close OUT2;
close OUT3;



#print "$total_subjects\n";

my $num_split_files = $total_subjects / $subjects_in_files;

#print "$num_split_files\n";

my $num_files = roundup($num_split_files);

#print "$num_files\n";

my @filearray = (1 .. $num_files);

#print "@filearray\n";

print "Splitting $affy_calls_rec in $num_files files...\nThis can take a while, be patient...\n";
print (OUT7 "Splitting $affy_calls_rec in $num_files files...\n");

my $iteratorstart = 1;
my $iteratorend = $subjects_in_files;
$" = "\t";

for my $file(@filearray){


my $affy_calls_rec_num = "$out_dir" . "/affy_rec_num_" . "$file";

open (OUT1, ">$affy_calls_rec_num");
open (IN1, "<$affy_calls_rec");


while (<IN1>){

if(m /^\#/){
print (OUT1 $_);
}

else { my @data = (split /\t/, $_);
my @slice;
if ($iteratorend < $total_subjects) {
@slice = @data[$iteratorstart..$iteratorend];
}

else {@slice = @data[$iteratorstart..$#data];
}

unshift (@slice, $data[0]);
chomp(@slice);
my @printline = @slice;
print (OUT1 "@printline\n");
}
}
$iteratorstart =$iteratorstart+$subjects_in_files;
$iteratorend=$iteratorend+$subjects_in_files;
close (IN1);
close (OUT1); 
print "finished file # $file\n";
}


print "\t»»»Done!\n";
print (OUT7 "\t»»»Done!\n");
my $end4 = Time::HiRes::gettimeofday();
print "seconds elapsed:\n";
printf("%.2f\n", $end4 - $start);

print "Starting to create pedfile out of $num_files files...\n";
print (OUT7 "Starting to create pedfile out of $num_files files...\n");

my $famcount = 0;
my @ids;

open(OUT4,">>$ped") || die print "Can't open $ped\n";

for my $file1(@filearray){ #1_o


my $affy_calls_rec_num = "$out_dir" . "/affy_rec_num_" . "$file1";
open (IN1, "<$affy_calls_rec_num"); 

while (<IN1>) { #2_o

if(m /^probeset_id/){ #3_o 
@ids = split(/\t/, $_);
shift @ids;
chomp @ids;
} #3_c 
} #2_c
close IN1;


for $_(@ids){
print "$_\n";
#$_ = substr($_, 0, 10);
}

my @id_count;
my $id_num = 0;



for my $g(@ids){ $id_num++; #4_o
push (@id_count, $id_num);




open(IN2,"<$report") || die print "Can't open birdseed.report.txt\n";



while (<IN2>){ #5_o


if(m/^\Q$g\E/){my @line; #6_o
my @temp=split(/\t/, $_);
my $id = $temp[0];
$id = substr($id, 0, 10);
my $sex = $temp[1];
if ($sex eq "female") { #7_o
$sex = 2;
} #7_c
if ($sex eq "male") { #8_o
$sex = 1;
} #8_c

my $call = $temp[2];
if($call < 86) { #9_o
print "Warning: Individual $id has call_rate below recommended minimum threshold (86%)\n";
print (OUT7 "Warning: Individual $id has call_rate below recommended minimum threshold (86%)\n");
} #9_c


push (@line,($g,$id,0,0,$sex,$sex));
print "Processing $line[1]\n";
print (OUT7 "Processing $line[1]\n");

open (IN4, "$affy_calls_rec_num" );
my $d = $id_count[0];

while (<IN4>) { #10_o

if((!m /^\#/) && (!m /^probeset_id/)){ #11_o
my ($snp) = (split)[$d];
$snp =~ s/_/ /;
push (@line, $snp);
} #11_c
} #10_c 
close IN4;




print (OUT4 "@line\n");
shift(@id_count);
@line =undef;
} #6_c
} #5_c
} #4_c
} #1_c

close(OUT4); 

print "\t»»»Done!\n";
print (OUT7 "\t»»»Done!\n");

my $end5 = Time::HiRes::gettimeofday();

print "seconds elapsed:\n";
print (OUT7 "seconds elapsed:\n");

printf("%.2f\n", $end5 - $start);

my $total_seconds = $end5 - $start;
$total_seconds = int($total_seconds);

my $total_minutes = int($total_seconds/60);
$total_seconds -= $total_minutes*60;

my $total_hours = int($total_minutes/60);
$total_minutes -= $total_hours*60;

printf("%s hours, %s minutes, %s seconds\n",
$total_hours,
$total_minutes,
$total_seconds,
);
printf(OUT7 "%s hours, %s minutes, %s seconds\n",
$total_hours,
$total_minutes,
$total_seconds,
);


print "»»»Cleaning up...\n";
print (OUT7 "»»»Cleaning up...\n");

for my $f(@filearray){ #1_o


my $affy_calls_rec_num = "$out_dir" . "/affy_rec_num_" . "$f";
unlink ($affy_calls_rec_num);
}

print "\tFinished!\n\n\tBye,bye!\n\n\n"; 
print (OUT7 "\tFinished!\n\n\tBye,bye!\n\n\n");

__END__

