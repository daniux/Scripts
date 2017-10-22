#! /usr/bin/perl
# Ver: 1.0
# daniux
# Given the specified instance port, this script will detele it accordingly. 

$srcfile = shift @ARGV;
$desfile = shift @ARGV;
$desfile_a = shift @ARGV;
$desfile_b = shift @ARGV;

open SRC, "$srcfile";
open (DES,'>', $desfile) or die $!;
open (DES_a,'>', $desfile_a) or die $!;
open (DES_b,'>', $desfile_b) or die $!;

print DES "##-- $srcfile\n\n";
print DES_a "##-- $srcfile\n\n";

$start = 0;
$quit = 0;
$count_a = 0;
$count_b = 0;

print DES "PIN,Required Trans,Actual Trans,Slack\n";
print DES_b "set PINs \[list \\\n";

while ( ($_ =<SRC>) && ($quit == 0) ) {
  if (/^\s+max_transition$/) { $start = 1; print "max_transition\n" }
  if ( /^\s+-*$/ && ($start == 1) ) {$start = 2; print "------------ START\n"}
  if ( $start == 2 ) {
  if (/^\s+min_transition$/) {
print "------------ END\n";
$quit = 1;
  }
  if (/^\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+\(VIOLATED.*\)$/) {
  $pin = $1; $req_tran = $2; $act_tran = $3; $slack = $4;
if ($pin =~ m/(.*)\/([^\/]*)$/) {
## Filter all the analog pins here.
if ($2 =~ m/VREF|PIN_TXN|PIN_TXP|PIN_TP|TP|REFCLK|PAD|PIN_REFCLKC_A_OUT|PIN_REFCLKC_A|PIN_REFCLKC_IN_TXSIDE|PIN_CLK150M|PIN_REFCLKC_IN_TXSIDE_G2|REFCLK_OUT_RX|CLKOUT_DIG|VDD|VSS|GND|PIN_IBYPASS|SI|SO|CK|ICC10U|XTAL_IN|ISENSE|ISET|PIN_RXN|PIN_RXP|PUPD5K|CLK150M|FBCLK_EXT|OSCCLK|CLK100M|CLK/) {
print DES_a "ANALOG or CLOCK pin ignored: $pin\n"; $count_a++
  } else {
print DES "$pin,$req_tran,$act_tran,$slack\n"; $count_b++;
print DES_b "$pin \\\n"
  }
  }
  }
  }
}

print DES "\nTotal Number of Max Transition Violation is: $count_b";
print DES_b "\]\n";

close(SRC);
close(DES);
