#!/usr/bin/perl

#Usage: perl xxx.pl ballmap.csv padring.csv
#This script is used for ball map file and padring file check
#Author: daniux
#VERSION: 1.0

open(FILE1, "$ARGV[0]")
or die "Could not open file '$ARGV[0]'";
open(OUT1, ">$ARGV[0].list");

while (<FILE1>) {
  $_ =~ s/\s+//g;
  if (/(\w+),(\w+),(.*?)$/) {
  if ($3 =~ /VSS/) {
  next;
  } else {
  $line = $line . "$1$2 $3;";
  @line = $line =~ /\w+\s?\w+.?\w*.?[;]/g;
# print OUT1 "$1$2 $3\n";
  }
  }
}
@sortline = sort @line;
foreach $sortline (@sortline) {
  $sortline =~ s/;//;
  print OUT1 "$sortline\n";
}

close(OUT1);
close(FILE1);

open(FILE2, "$ARGV[1]")
or die "Could not open file '$ARGV[1]'";
open(OUT2, ">$ARGV[1].list");

while (<FILE2>) {
  $_ =~ s/\s+//g;
  if (/(.+),(.+)$/) {
  $line = "$2 $1";
  $line_t = $line_t . $line . ";";
  @line_total = $line_t =~ /\w+\s?\w+.?\w*.?[;]/g;
# print OUT2 "$line\n";
  } elsif (/(.+),$/) {
  $line = "unmapped $1";
  $line_t = $line_t . $line . ";";
  @line_total = $line_t =~ /\w+\s?\w+.?\w*.?[;]/g;
# print OUT2 "$line\n";
  }
}

@sortline = sort @line_total;
foreach $sortline(@sortline) {
  $sortline =~ s/;//;
  print OUT2 "$sortline\n";
}

close(OUT2);
close(FILE2);
