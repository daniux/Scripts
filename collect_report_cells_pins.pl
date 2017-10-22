#!/usr/bin/perl
#Version: 1.0
#Author: daniux
#Usage: To extract the cell/pin info from fanout/in report

open(FILE, "$ARGV[0]") or die "cannot open $ARGV[0]";
open(OUT1, ">all_dont_touch_cell.tcl");
open(OUT2, ">all_dont_touch_pin.tcl");
open(OUT3, ">for_icexplorer.tcl");

$State = "Idle";
$in_fanout = 0;

while (<FILE>) {
  if(/Fanout network of source/) {
  $in_fanout = 1;
  }
  if($in_fanout) {
  if (/^\w+\s+Pin\s+\w+\s+Pin\s+Type\s+Sense/) {
$State = "Labels";
  }
  if (($State eq "Labels") && (/^\-\-\-\-\-\-/)) {
$State = "Line";
  }
  if (($State eq "Line") or ($State eq "Driver")) {
if (/^(([^ ^\t]+)\/[^\/^ ]+)\s+(([^ ^\t]+)\/[^\/^ ]+)\s+.*?$/) {
#if (/^((\w[^ ^\t]+)\/[^\/]+)\s+((\w[^ ^\t]+)\/[^\/^ ]+)\s+.*?$/)
# if (/^((\S+)\/[^\/]+)\s+((\w[^ ^\t]+)\/[^\/^ ]+)\s+.*?$/)
$theDriverCell = $2;
  $theDriverPin = $1;
  $theLoadCell = $4;
  $theLoadPin = $3;
  push(@All_Pin, $theDriverPin);
  push(@All_Pin, $theLoadPin);
push(@All_Cell, $theDriverCell);
  push(@All_Cell, $theLoadCell);
} elsif (/^$/) {
  $State = "Driver";
  }
  }
  if ($State eq "Driver") {
$State = "Idle";
  }
  }
  if(/^\*\*\*\*\*\*\*/) {
  $in_fanout = 0;
  }
}
## For all the clock cells ##
@Pin = uniq(@All_Pin);
@Cell = uniq(@All_Cell);
%Cell2 = map {$_ => 1} @Cell;
@Cell = keys %Cell2;
@targetCell = sort(@Cell);
print OUT1 "set_dont_touch [get_cells { \\\n";
for ($i = 0; $i <= $#targetCell; $i++) {
  print OUT1 "$targetCell[$i] \\\n";
}
print OUT1 "\}\]\n";

## For all the clock pins ##
%Pin2 = map {$_ => 1} @Pin;
@Pin = keys %Pin2;
@targetPin = sort(@Pin);
print OUT2 "set_dont_touch [get_nets -of { \\\n";
for ($i = 0; $i <= $#targetPin; $i++) {
  print OUT2 "$targetPin[$i] \\\n";
}
print OUT2 "\}\]\n";

## Below is used for ICExplorer, please uncomment when needed
print OUT3 "set all_nets [get_nets -of { \\\n";
for ($i = 0; $i <= $#targetPin; $i++) {
  print OUT3 "$targetPin[$i] \\\n";
}
print OUT3 "\}\]\n";

print OUT3 "set all_cells [get_cells { \\\n";
for ($i = 0; $i <= $#targetCell; $i++) {
  print OUT3 "$targetCell[$i] \\\n";
}
print OUT3 "\}\]\n";

print OUT3 "echo \"\" > all_dont_touch_icexplorer.tcl\n";
print OUT3 "foreach_in_collection cell \$all_cells {\n";
print OUT3 " echo \"[get_attr [get_cell \$cell] full_name]\ cell\" >> all_dont_touch_icexplorer.tcl\n";
print OUT3 "}\n";

print OUT3 "foreach_in_collection net \$all_nets {\n";
print OUT3 " echo \"[get_attr [get_net \$net] full_name]\ net\" >> all_dont_touch_icexplorer.tcl\n";
print OUT3 "}\n";

sub uniq {
  my %seen;
  grep !$seen{$_}++, @_;
}

close(FILE);
close(OUT1);
close(OUT2);
close(OUT3);
