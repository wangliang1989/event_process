#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib $FindBin::Bin;
require config;
$ENV{SAC_DISPLAY_COPYRIGHT} = 0;

@ARGV == 1 or die "Usage: perl $0 dir\n";
my ($dir) = @ARGV;
my %pars = read_config($dir);
my ($f1, $f2, $f3, $f4) = split /\s+/, $pars{'FREQ'};
my ($bp1, $bp2, $bp3) = split /\s+/, $pars{'HP'};
#hp c 0.02 p 2 n 2

chdir $dir;

# 去仪器响应
open(SAC, "| sac") or die "Error in opening sac\n";
print SAC "wild echo off\n";
foreach (glob "*.SAC") {
    print SAC "r $_ \n";
    print SAC "rglitches; rmean; rtrend; taper \n";
    print SAC "trans from evalresp to none freq $f1 $f2 $f3 $f4\n";
    print SAC "hp c $bp1 p $bp2 n $bp3\n";
    print SAC "w over\n";
}
print SAC "q\n";
close(SAC);
foreach (glob "*.SAC") {
    my ($idep) = (split m/\s+/, `saclst idep f $_`)[1];
    unlink $_ unless ($idep == 6)
}
unlink glob "RESP.*";

chdir "..";
