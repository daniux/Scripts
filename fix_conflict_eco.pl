#!/usr/bin/perl
#version:1.0
#daniux
#usage: fix the conflict existed beween two ECO scripts

use Getopt::Long;
use FileHandle;
use File::Basename;
my ($help,$file1,$file2,$output);
GetOptions(
  "help|h" => \$help,
  "file1|a=s" => \$file1,
  "file2|b=s" => \$file2,
  "output|t=s" => \$output,
);
## check arguments
if (defined($help)){
  print_usage();
  exit;
}
if (!defined ($file1) or !defined ($file2)){
  print_usage();
  exit;
}
if (!defined ($output)){
  print_usage();
  exit;
}
  open(FILE1, $file1) or die "cannot open file1\n";
  open(FILE2, $file2) or die "cannot open file2\n";
  open(OUT,">$output") or die "cannot open output\n";
  while (<FILE1>) {
  if (/Error: Could not size '(.*?)'\s*/) {
  push(@file1_array,"$1");
  }
  }
  close(FILE1);
while (<FILE2>) {
  if (/^\s*change_link\s*(\w[^ ^\t]+\/[^\/]+)[ \t]+\w+/) {
  $tmp = $1;
  $in_match = 0;
  foreach $file1_array (@file1_array) {
  if ($file1_array eq $tmp) {
# print OUT "# $_\n";
  $in_match = 1;
# next LINE;
  }
  }
  if ($in_match) {
  print OUT "# $_";
  } else {
  print OUT "$_";
  }

  } else {
  print OUT "$_";
  }
  }

sub print_usage{
  print <<EOF;
Usage: $0
  [-help|h] print this messages
  <-file1|a> specify file1
  <-file2|b> specify file2
  <-output|s> specify output
EOF
}
