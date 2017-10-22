#!/usr/bin/perl -w
#Usage: perl xxx.pl QoR report
#daniux
#VERSION: 1.0
#This script is used to collect timing group information from timing report.

open(FILE1, "$ARGV[0]") or die "cannot open $ARGV[0]\n";
open(OUT, ">$ARGV[0].check.max");
open(OUT1, ">$ARGV[0].check.min");

$in_path_group = 0;
$in_min_group = 0;
print OUT "Timing Path Group,Critical Path Length,Critical Path Slack,Total Negative Slack,No. of Violating Paths\n";
print OUT1 "Timing Path Group,Critical Path Length,Critical Path Slack,Total Negative Slack,No. of Violating Paths\n";

foreach $line (<FILE1>){
  if($line =~ /\s+Timing Path Group '(\S+)' \(max_delay\/setup\)$/) {
  $path_group = $1;
# $path_type = "setup";
  $in_path_group = 1;
  next;
  }

  if($in_path_group) {
  if($line =~ /\s+Critical Path Length:\s+(\S+)$/) {
  $cpl = $1;
  }
  if($line =~ /\s+Critical Path Slack:\s+(\S+)$/) {
  $cps = $1;
  }
  if($line =~ /\s+Total Negative Slack:\s+(\S+)$/) {
  $tns = $1;
  }
  if($line =~ /\s+No. of Violating Paths:\s+(\S+)$/) {
  $no_vp = $1;
  $in_path_group = 0;
  print OUT "$path_group,$cpl,$cps,$tns,$no_vp\n";
  }
  }

  if($line =~ /\s+Timing Path Group '(\S+)' \(min_delay\/hold\)$/) {
  $path_group = $1;
  $in_min_group = 1;
  next;
  }

  if($in_min_group) {
  if($line =~ /\s+Critical Path Length:\s+(\S+)$/) {
  $cpl = $1;
  }
  if($line =~ /\s+Critical Path Slack:\s+(\S+)$/) {
  $cps = $1;
  }
  if($line =~ /\s+Total Negative Slack:\s+(\S+)$/) {
  $tns = $1;
  }
  if($line =~ /\s+No. of Violating Paths:\s+(\S+)$/) {
  $no_vp = $1;
  $in_min_group = 0;
  print OUT1 "$path_group,$cpl,$cps,$tns,$no_vp\n";
  }
  }

}

close(OUT);
close(OUT1);
close(FILE1);collect_timing_group.pl
