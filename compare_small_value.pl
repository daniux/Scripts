#!/usr/bin/perl
#version:1.0
#daniux
#This script is to compare the grep values from timing report.

use Getopt::Long;
use FileHandle;
use File::Basename;
my ($help,$file1,$file2,$file3,$output);
GetOptions(
  "help|h" => \$help,
  "file1|a=s" => \$file1,
  "file2|b=s" => \$file2,
  "file3|c=s" => \$file3,
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
my ($atime1, $mtime1, $ctime1) = (stat $file1)[8..10];
my ($atime2, $mtime2, $ctime2) = (stat $file2)[8..10];
my ($atime3, $mtime3, $ctime3) = (stat $file3)[8..10];
my ($atimeo, $mtimeo, $ctimeo) = (stat $output)[8..10];
print "$mtime1\n";
print "$mtime2\n";
print "$mtime3\n";
print "$mtimeo\n";
if ( ( $mtime1 < $mtimeo ) and ( $mtime2 < $mtimeo) and ( $mtime3 < $mtimeo) and (-e $output) ) {
  print "output file is newer than all input files, no need to generate!\n";
} elsif (( $mtime1 < $mtimeo) and ( $file2 < $mtimeo) and (-e $output) and (!-e $file3 ) ) {
  print "output file is newer than all input files, no need to generate!\n";
  } else {
  open(FILE1, $file1) or die "cannot open file1\n";
  open(FILE2, $file2) or die "cannot open file2\n";
  open(OUT,">$output") or die "cannot open output\n";
  my %file1_hash;
  my %file2_hash;
  my %file3_hash;
  my %tmp_hash;
  my %tmp2_hash;
  while (<FILE1>) {
  if (/\s*set_user_attribute\s+\[get_pins\s+(.*?)\]\s+ck_mtlimit\s+(\d*\.\d*)/) {
  $file1_hash{$1} = $2;
  }
  }
  while (<FILE2>) {
  if (/\s*set_user_attribute\s+\[get_pins\s+(.*?)\]\s+ck_mtlimit\s+(\d*\.\d*)/) {
  $file2_hash{$1} = $2;
  }
  }
  if ( -e $file3 ) {
  open(FILE3, $file3) or die "cannot open FILE3\n";
  while (<FILE3>) {
  if (/\s*set_user_attribute\s+\[get_pins\s+(.*?)\]\s+ck_mtlimit\s+(\d*\.\d*)/) {
  $file3_hash{$1} = $2;
  }
  }
  %tmp2_hash = compare(\%file1_hash,\%file2_hash);
  %tmp_hash = compare(\%tmp2_hash, \%file3_hash);
  } else {
  %tmp_hash = compare(\%file1_hash,\%file2_hash);
  }
  while ( my ($k,$v) = each %tmp_hash ) {
print OUT <<EOF;
  if { [get_attribute [get_pins $k] ck_mtlimit -quiet] == ""} {
  set_user_attribute [get_pins $k] ck_mtlimit $v
  } else {
  set_user_attribute [get_pins $k] ck_mtlimit [my_comp [get_attribute [get_pins $k] ck_mtlimit] $v min]
  }
EOF
  }
}

sub compare {
my ($hash1,$hash2) = @_;
my %hash1 = %$hash1;
my %hash2 = %$hash2;
  for (keys %hash1) {
  unless ( exists $hash2{$_} ) {
  $hash{$_} = $hash1{$_};
  next;
  }
  if ( $hash1{$_} <= $hash2{$_} ) {
  $hash{$_} = $hash1{$_};
  } else {
  $hash{$_} = $hash2{$_};
  }
  }
  for (keys %hash2) {
  unless ( exists $hash1{$_} ) {
  $hash{$_} = $hash2{$_};
  next;
  }
  }
 return %hash;
}

sub print_usage{
  print <<EOF;
Usage: $0
  [-help|h] print this messages
  <-file1|a> specify file1
  <-file2|b> specify file2
  [-file3|c] specify file3
  <-output|s> specify output
EOF
}
