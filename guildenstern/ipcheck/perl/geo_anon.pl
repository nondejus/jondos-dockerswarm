#!/usr/bin/perl


# use strict;
use warnings;

use IO::Handle;
use Geo::IP;

if (@ARGV != 1) {
    exit 1;
}

my $gi = Geo::IP->new(GEOIP_STANDARD);

my $LOG;
open $LOG, ">>$ARGV[0]";

# Daten sofort schreiben, ohne Pufferung.
$LOG->autoflush(1);

while (my $line = <STDIN>) {
  chomp $line;

  if (! ( ($line =~ /promote=true&colorText=20\-20\-20/) || ($line =~ /awxcnx\.de/ ) ) ) {

    my $ip;
    my $newip;
    my $rest;
    ($ip, $rest)= split /-/, $line, 2;
    chop($ip);

    if(( $ip eq '212.117.177.6' ) || ( $ip eq '87.236.194.76' ) || ( $ip eq '64.118.81.157' ) ||
      ( $ip eq '95.211.124.200' ) || ( $ip eq '82.103.137.85' ) || ( $ip eq '80.190.200.170' ) ||
      ( $ip eq '62.2.182.245' ) || ( $ip eq '212.227.103.74' ) || ( $ip eq '89.187.142.72' ) ||
      ( $ip eq '80.237.225.145' ) || ( $ip eq '178.33.255.188' ) || ( $ip eq '82.113.145.225' ) ||
      ( $ip eq '216.18.20.108' ) || ( $ip eq '85.31.187.19' ) || ( $ip eq '212.117.177.5' ) ||
      ( $ip eq '188.165.6.178' ) ||
       ( $ip eq '141.76.45.33' ) || ( $ip eq '141.76.45.34' ) || ( $ip eq '141.76.45.35' ))

    { $newip= '127.0.10.1'; }

    else {
       my $country_org;

       $country_org = $gi->country_code_by_addr($ip);
       if  (!(defined($country_org))) { $country_org = 'unbekannt'; }

       my @ipnum= split /\./, $ip;

       my $ip_set1= 0;
       $newip = $ipnum[0] . '.' . $ipnum[1] . '.0.1';

       my $country_log = $gi->country_code_by_addr($newip);
       if (!(defined($country_log))) { $country_log = 'unbekannt'; }

       while (( $country_log ne $country_org ) && ( $ip_set1 < 255 )) {
         $ip_set1++;
         $newip = $ipnum[0] . '.' . $ipnum[1] . '.' . $ip_set1 . '.1';
         $country_log = $gi->country_code_by_addr($newip);
         if (!(defined($country_log))) { $country_log = 'unbekannt'; }
       }

       if ( $country_log ne $country_org ) {
          $ip_set1= 1;
          while (( $country_log ne $country_org ) && ( $ip_set1 < 255 )) {
            $ip_set1++;
            $newip = $ipnum[0] . '.' . $ipnum[1] . '.' .  $ipnum[2] . '.' . $ip_set1;
            $country_log = $gi->country_code_by_addr($newip);
            if (!(defined($country_log))) { $country_log = 'unbekannt'; }
          }
       }
    }
    print $LOG $newip, ' - ', $rest, "\n";
  }

}
