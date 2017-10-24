#!/usr/bin/perl

#Usage: perl xxx.pl xxxxx.lib
#This script is used for collecting the timing value in the liberty file
#Author: daniux
#VERSION: 1.0

open(FILE1, "$ARGV[0]") or die "Could not open file '$ARGV[0]'";
open(OUT1, ">>$ARGV[0]_SEQ.csv");

@cell_list = ( "sshdfnrx2",
"sshdfnrx4",
"sshdfnsqx2",
"sshdfnsqx4",
"sshdfrsx2",
"sshdfrsx4"
 );
###########
## SETUP ##
###########
open(FILE1, "$ARGV[0]") or die "Could not open file '$ARGV[0]'";
$in_cell = 0;
$in_output = 0;
$in_value = 0;
print OUT1 "SETUP\n";
print OUT1 "Cell_name min_value typ_value max_value leakage_value\n";
while (<FILE1>) {
chomp;
foreach $cell (@cell_list) {
  if (/\s*cell\s+\(\s+[hsul][npz]d_$cell\s+\)/) {
  $in_cell = 1;
  $current_cell = $cell;
  }
}
  if ($in_cell) {
  if (/\s+cell_leakage_power\s*:\s*(.*?)\s*;/) {
  $leakage_value = $1;
  }
  if (/\s*rise_constraint\(setup_template/) {
  $in_cell = 0;
  $in_output = 1;
  }
  }

  if ($in_output) {
  if (/\s+values\(\s*\"(\S+),/) {
  $line_number = 0;
  $in_value = 1;
  $min_value = $1;
  }

  if ($in_value) {
  $line_num += 1;
  }

  if (/\s+\"\S+,\s+\S+,\s+\S+,\s+\S+,\s+(\S+)\"\);/) {
  $max_value = $1;
  $in_output = 0;
  $in_value = 0;
  $line_num = 0;
  print OUT1 "$current_cell $min_value $typ_value $max_value $leakage_value\n";
  } elsif ($line_num == 3) {
  if (/\s+\"\S+,\s+\S+,\s+(\S+),\s+\S+,\s+\S+\",\\/) {
  $typ_value = $1;
  }
  }
  }
}
#close(OUT2);
close(FILE1);

##########
## HOLD ##
##########
open(FILE1, "$ARGV[0]") or die "Could not open file '$ARGV[0]'";
$in_cell = 0;
$in_output = 0;
$in_value = 0;
print OUT1 "HOLD\n";
print OUT1 "Cell_name min_value typ_value max_value leakage_value\n";
while (<FILE1>) {
chomp;
foreach $cell (@cell_list) {
  if (/\s*cell\s+\(\s+[hsul][npz]d_$cell\s+\)/) {
  $in_cell = 1;
  $current_cell = $cell;
  }
}
  if ($in_cell) {
  if (/\s+cell_leakage_power\s*:\s*(.*?)\s*;/) {
  $leakage_value = $1;
  }
  if (/\s*rise_constraint\(hold_template/) {
  $in_cell = 0;
  $in_output = 1;
  }
  }

  if ($in_output) {
  if (/\s+values\(\s*\"(\S+),/) {
  $line_number = 0;
  $in_value = 1;
  $min_value = $1;
  }

  if ($in_value) {
  $line_num += 1;
  }

  if (/\s+\"\S+,\s+\S+,\s+\S+,\s+\S+,\s+(\S+)\"\);/) {
  $max_value = $1;
  $in_output = 0;
  $in_value = 0;
  $line_num = 0;
  print OUT1 "$current_cell $min_value $typ_value $max_value $leakage_value\n";
  } elsif ($line_num == 3) {
  if (/\s+\"\S+,\s+\S+,\s+(\S+),\s+\S+,\s+\S+\",\\/) {
  $typ_value = $1;
  }
  }
  }
}
#close(OUT1);
close(FILE1);
##########
## CK-Q ##
##########
open(FILE1, "$ARGV[0]") or die "Could not open file '$ARGV[0]'";
$in_cell = 0;
$in_output = 0;
$in_value = 0;
print OUT1 "CK-Q\n";
print OUT1 "Cell_name min_value typ_value max_value leakage_value\n";
while (<FILE1>) {
chomp;
foreach $cell (@cell_list) {
  if (/\s*cell\s+\(\s+[hsul][npz]d_$cell\s+\)/) {
  $in_cell = 1;
  $current_cell = $cell;
  }
}
  if ($in_cell) {
  if (/\s+cell_leakage_power\s*:\s*(.*?)\s*;/) {
  $leakage_value = $1;
  }
  if (/\s+cell_rise\(delay_template_/) {
  $in_cell = 0;
  $in_output = 1;
  }
  }

  if ($in_output) {
  if (/\s+values\(\s*\"(\S+),/) {
  $line_number = 0;
  $in_value = 1;
  $min_value = $1;
  }

  if ($in_value) {
  $line_num += 1;
  }

  if (/\s+\"\S+,\s+\S+,\s+\S+,\s+\S+,\s+\S+,\s+\S+,\s+(\S+)\"\);/) {
  $max_value = $1;
  $in_output = 0;
  $in_value = 0;
  $line_num = 0;
  print OUT1 "$current_cell $min_value $typ_value $max_value $leakage_value\n";
  } elsif ($line_num == 3) {
  if (/\s+\"\S+,\s+\S+,\s+(\S+),\s+\S+,\s+\S+,\s+\S+,\s+\S+\",\\/) {
  $typ_value = $1;
  }
  }
  }
}
