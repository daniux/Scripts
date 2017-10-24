#!/usr/local/bin/perl
# Ver: 1.0
# daniux
# usage schedule.pl -schedule 23:00 -command "soscmd update; run -build; run -regress mini.list > test.log; cat test.log | mail -s mini_result brucew"
use POSIX;
# Automatic start job based on the specified time

my $usage =
  "\n".
  "USAGE: \n".
  "\t$0 <-schedule {hh:mm}> <-command {command}> <-days {ddddddd}> <-help>\n".
  "\n".
  "DESCRIPTION:\n".
  "\t-schedule {hh:mm}\n".
  "\t\thh: hour in 24 hour format\n".
  "\t\tmm: minute\n".
  "\t-command {command}\n".
  "\t\tcommand: any shell command\n".
  "\t-days {ddddddd}\n".
  "\t\teach digit represents a day in a week. Starting from Sunday.\n".
  "\t\tThis argument should have exactly 7 digits, and at least one digit is not 0.\n".
  "\t\tExample:\n".
  "\t\t\tFor Weekdays: -days 0111110\n".
  "\t\t\tFor Weekends: -days 1000001\n".
  "\n";

my $i;
my $scheduled_hour;
my $scheduled_min;
my $command;
my @scheduled_days;
my $days = 1111111;
my @day = qw( Sun Mon Tue Wed Thu Fri Sat );

for ($i = 0; $i <= $#ARGV; $i++) {
  if (($ARGV[$i] =~ /^-c(o(m(m(a(n(d)?)?)?)?)?)?$/) && ($ARGV[$i+1] =~ /.*/)) {
  $command = $ARGV[$i+1];
  $i++;
  next;
  }
  if (($ARGV[$i] =~ /^-s(c(h(e(d(u(l(e)?)?)?)?)?)?)?$/) && ($ARGV[$i+1] =~ /^[0-9]*:[0-9]*$/)) {
  ($scheduled_hour, $scheduled_min) = split(/:/, $ARGV[$i+1]);
  $i++;
  next;
  }
  if (($ARGV[$i] =~ /^-d(a(y(s)?)?)?$/) && ($ARGV[$i+1] =~ /^[01]{7}$/)) {
  $days = $ARGV[$i+1];
  $i++;
  next;
  }
  die $usage;
}

if (not($scheduled_hour & $scheduled_min & $command)) {
  die $usage;
}

if ($days == 0) {
  die "Argument for -days should have at least one non-zero digit.\n";
}

@scheduled_days = split (//, $days);

main();

sub main() {
  while (1) {
  print "\n========================================================\n\n";
  print "\t-days\t\t$days ( ";
  $i = 0;
  foreach (@scheduled_days) {
  print "@day[$i] " unless !$_;
  $i++;
  }
  printf ")\n";
  printf ("\t-schedule\t%02d:%02d\n", $scheduled_hour, $scheduled_min);
  print "\t-command\t$command\n";
  print "\n";
  $|++;
  sleep(get_scheduled_time_diff()+1);
  print "\n========================================================\n\n";
  system("$command");
  }
}

sub get_scheduled_time_diff() {
  $time = time();
  $i = 0;

  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);
  $scheduled_time = mktime(0,$scheduled_min,$scheduled_hour,$mday,$mon,$year,$wday,$yday,$isdst);

  # check if scheduled time already passed
  if ($time > $scheduled_time) {
  $scheduled_time += 24*60*60; # add one day
  }

  # check if this is one of the scheduled days
  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($scheduled_time);
  while (!$scheduled_days[$wday]) {
  $scheduled_time += 24*60*60; # add one day
  ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($scheduled_time);
  }

  $time_diff = $scheduled_time - $time;
  print "\tTask Scheduled to Run at: " . localtime($scheduled_time) ."\n";
  print "\t$time_diff Seconds Remaining\n\n";
  return $time_diff;
}
