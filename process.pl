#!/usr/bin/env perl
use strict;
use warnings;

@ARGV >= 1 or die "Usage: \n\tperl $0 event1 event2 ... eventn\n\tperl $0 events.info\n";

my @events;

if (@ARGV == 1 and -f $ARGV[0]) {
    open(IN, "< $ARGV[0]");
    foreach (<IN>) {
        #20051230182646 2005-12-30T18:26:46.000  -82.286    7.6796   29.6
        my ($event, $origin, $lon, $lat, $dep, $mag) = split m/\s+/;
        foreach (glob "seed/${event}.*") {
            mkdir $event;
            open (OUT, "> $event/event.info") or die;
            print OUT "$origin $lat $lon $dep\n";
            close (OUT);
            system "cp $_ $event/";
            push @events, $event;
            last;
        }
    }
    close(IN);
} else {
    @events = @ARGV;
}

foreach my $event (@events) {
    system "perl rdseed.pl $event";
    system "perl eventinfo.pl $event";
    system "perl marktime.pl $event";
    system "perl transfer.pl $event";
    system "perl rotate.pl $event";
    system "perl resample.pl $event";
}
