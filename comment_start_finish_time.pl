#!/usr/bin/perl
#Usage: perl xxx.pl input_file out_file
#VERSION: 1.0
#daniux
#Some generated report will contain start/finish time stamp, this script will comment out all those non-command lines


open(IN, "$ARGV[0]");
open(OUT, "$ARGV[1]");
my ($atime1, $mtime1, $ctime1) = (stat $ARGV[0])[8..10];
my ($atime2, $mtime2, $ctime2) = (stat $ARGV[1])[8..10];

if (!-e $ARGV[0]) {
  die "Could not open input file '$ARGV[0]'\nUsage: perl xxx.perl input_file output_file\n";
} elsif (!-e $ARGV[1]) {
  print "Could not open output file '$ARGV[1]'\nScript will generate output file '$ARGV[1]'\n";
  open(OUT, ">$ARGV[1]");
  while (<IN>) {
  if(/Start Time:/) {
  print OUT "###$_";
  }
  elsif(/Finish Time:/) {
  print OUT "###$_";
  } else {
  print OUT "$_";
  }
  }
}
else {
if ( $mtime1 > $mtime2 ) {
print "output file is older than input file, script will overwrite output file\n";
open(OUT, ">$ARGV[1]");
  while (<IN>) {
  if(/Start Time:/) {
  print OUT "###$_";
  }
  elsif(/Finish Time:/) {
  print OUT "###$_";
  } else {
  print OUT "$_";
  }
  }
  } else {
  print "output file is newer than input file, no need to generate again\n";
  }
}

close(IN);
close(OUT);
