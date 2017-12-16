#!/usr/bin/perl

use Digest::SHA1 qw(sha1_base64);
use XML::Bare;
use LWP::Simple;

my $pi_url = 'http://pi.jondopay.de:1234';  # produktiv
# my $pi_url = 'http://87.230.101.54:1234';  # test

my $tarifename= 'InfoService';
my $payment= 'Bitcoin';

my $xmlpage= get( $pi_url . '/?create=' . $tarifename . '&shop=JONDOS&price=0' );
if ( defined($xmlpage) ) {
         my $xmlob = new XML::Bare( text => $xmlpage );
         my $xmlroot = $xmlob->parse();
         my $code= $xmlroot->{CodeInfo}->{Code}->{value};

         if(defined($code)) {
             $xmlpage= get( $pi_url . '/?check=' . $code );
             $xmlob = new XML::Bare( text => $xmlpage );
             $xmlroot = $xmlob->parse();
             $transfernummer= $xmlroot->{CodeInfo}->{Transaction}->{value};

             $xmlpage= get( $pi_url . '/?activate=' . $code);

             print "Code: $code \n";

         } else { print "Fehler! Kein Code gefunden.\n"; }
} else {
  print "Fehler! Kann PI nicht erreichen.\n";
}
