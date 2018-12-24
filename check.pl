#!/usr/bin/env perl
use strict;
use warnings;

open (IN, "< events.txt") or die;
my @info = <IN>;
close(IN);

open (IN, "< log.txt") or die;
my @seed = <IN>;
close(IN);

foreach (@info) {
    chop;
    my ($event) = split m/\s+/;
    my $i = 1;
    foreach (@seed) {
        my ($seed) = split m/\./;
        $i = 0 if ($event eq $seed);
    }
    print "$event in events.txt do not exist in log.txt\n" if ($i == 1);
}
foreach (@seed) {
    chop;
    my ($seed) = split m/\./;
    my $i = 1;
    foreach (@info) {
        my ($event) = split m/\s+/;
        $i = 0 if ($event eq $seed);
    }
    print "$seed in log.txt do not exist in events.txt\n" if ($i == 1);
}
