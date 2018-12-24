#!/usr/bin/env perl
use strict;
use warnings;
use List::Util qw(min);
use List::Util qw(max);
$ENV{SAC_DISPLAY_COPYRIGHT} = 0;

@ARGV == 1 or die "Usage: perl $0 dir\n";
my ($dir) = @ARGV;

my $taup = `which taup_time`;
exit "Skip marking arrival times in SAC files because Taup isn't install\n" unless (defined($taup));

chdir $dir;

open(SAC, "| sac") or die "Error in opening SAC\n";
print SAC "wild echo off\n";
foreach my $Zfile (glob "*Z.SAC") {
    my ($net, $sta) = split m/\./, $Zfile;
    my ($evdp, $gcarc, $b, $e) = (split m/\s+/, `saclst evdp gcarc b e f $Zfile`)[1..4];
    my $ttp = min (split m/\s+/, `taup_time -mod prem -ph ttp -h $evdp -deg $gcarc --time`);
    my $ss = min (split m/\s+/, `taup_time -mod prem -ph SS -h $evdp -deg $gcarc --time`);
    print SAC "r ${net}.${sta}.*.SAC\n";
    print SAC "ch t0 $ttp t1 $ss kt0 ttp kt1 SS\n";
    print SAC "wh\n";
}
print SAC "q\n";
close(SAC);

chdir "..";
