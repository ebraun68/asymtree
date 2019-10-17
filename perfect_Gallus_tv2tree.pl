#!/usr/bin/env perl

use warnings;
use strict;
use Data::Dumper;

############################################################################
# Initialize variables
############################################################################

my($progname) = $0;
my($iter);
my($jter);
my($kter);
my($lter);
my($mter);
my($zter);
my($tvar1);
my($tvar2);

my @tmparr1;
my @tmparr2;

if ( @ARGV != 1 ) {
	print "Usage:\n  \$ $progname <infile> \n";
	print "  infile  = relaxed phylip format file (informative sites)\n";
	print "  writes encoded newick trees to stdout\n";
	print "  NOTE: encoding is specific to Gallus phylogenome project\n";
	print "exiting...\n";
	exit;
}

my($infile)  = $ARGV[0];

############################################################################
# Read the inputfile file
############################################################################
my @seqlist;
open (my $SEQF, "$infile") or die "Could not open file < $infile > for input.\n";
@seqlist = <$SEQF>; # Read the relaxed phylip format input file
close($SEQF) or die "Could not close file < $infile >\n";
my($seqlistnum) = $#seqlist + 1;
for ($iter=0; $iter<$seqlistnum; $iter++) { chomp($seqlist[$iter]); }

my($ntax);
my($nchar);

($ntax,$nchar) = split(/\s+/, $seqlist[0]);

my @name;
my @seq;
for ($iter=0; $iter<$ntax; $iter++) {
	($name[$iter],$seq[$iter]) = split(/\s+/, $seqlist[$iter+1]);
}

############################################################################
# Code perfect TV sites as trees
############################################################################
my($Bthostate);
my($sitepattern);

for ($iter=0; $iter<$nchar; $iter++) {
	$Bthostate = substr($seq[0],$iter,1);
	$sitepattern = "0";
	for ($jter=1; $jter<$ntax; $jter++) {
		$tvar1 = substr($seq[$jter],$iter,1);
		if ( $tvar1 eq $Bthostate ) { $sitepattern = "$sitepattern" . "0"; }
		else { $sitepattern = "$sitepattern" . "1"; }
	}
	if ( $sitepattern eq "00111") { print "(Btho,Gvar,(Ggal,Gson,Glaf));"; }
	elsif ( $sitepattern eq "01011") { print "(Btho,Ggal,(Gvar,Gson,Glaf));"; }
	elsif ( $sitepattern eq "01101") { print "(Btho,Gson,(Gvar,Ggal,Glaf));"; }
	elsif ( $sitepattern eq "01110") { print "(Btho,Glaf,(Gvar,Ggal,Gson));"; }

	elsif ( $sitepattern eq "00011") { print "(Btho,Gvar,Ggal,(Gson,Glaf));"; }
	elsif ( $sitepattern eq "00110") { print "(Btho,Gvar,Glaf,(Ggal,Gson));"; }
	elsif ( $sitepattern eq "01100") { print "(Btho,Gson,Glaf,(Gvar,Ggal));"; }
	
	elsif ( $sitepattern eq "01010") { print "(Btho,Ggal,Glaf,(Gvar,Gson));"; }
	elsif ( $sitepattern eq "01001") { print "(Btho,Ggal,Gson,(Gvar,Glaf));"; }
	
	elsif ( $sitepattern eq "00101") { print "(Btho,Gvar,Gson,(Ggal,Glaf));"; }
	else { print "PATTERN = $sitepattern"; }
	
	print "\n";
}

