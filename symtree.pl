#!/usr/bin/env perl

use warnings;
use strict;
use Data::Dumper;

############################################################################
# This program calculates the expected gene tree spectrum for the rooted
# species tree ((AB)(CD));
############################################################################

############################################################################
# Set the global variables
############################################################################
my($progname) = $0;
my($version) = "0.9a";

my($iter);
my($jter);
my($kter);
my($lter);
my($mter);
my($nter);

my($tempvar);

if ( @ARGV != 2 ) {
	print "Usage:\n  \$ $progname <T2> <T3>\n";
	print "  T2 and T3 = branch lengths";
	print "  ((A,B):T3+T2, (C,D)):T2\n";
	print "exiting...\n";
	exit;
}

my($T2) = $ARGV[0];
my($T3) = $ARGV[1];

############################################################################
# Calculate the probabilities of the 15 gene trees
############################################################################
my @treeprob;

$treeprob[0] = (Gprob(21,$T3+$T2) * Gprob(21,$T2)) + ((Gprob(21,$T3+$T2) * Gprob(22,$T2))/3.0) + ((Gprob(22,$T3+$T2) * Gprob(21,$T2))/3.0) + ((Gprob(22,$T3+$T2) * Gprob(22,$T2))/9.0) ;
$treeprob[1] = ((Gprob(22,$T3+$T2) * Gprob(22,$T2))/9.0) ;
$treeprob[2] = ((Gprob(22,$T3+$T2) * Gprob(22,$T2))/9.0) ;
$treeprob[3] = ((Gprob(21,$T3+$T2) * Gprob(22,$T2))/3.0) + ((Gprob(22,$T3+$T2) * Gprob(22,$T2))/18.0) ;
$treeprob[4] = ((Gprob(21,$T3+$T2) * Gprob(22,$T2))/3.0) + ((Gprob(22,$T3+$T2) * Gprob(22,$T2))/18.0) ;

$treeprob[5] = ((Gprob(22,$T3+$T2) * Gprob(22,$T2))/18.0) ;
$treeprob[6] = ((Gprob(22,$T3+$T2) * Gprob(22,$T2))/18.0) ;
$treeprob[7] = ((Gprob(22,$T3+$T2) * Gprob(22,$T2))/18.0) ;
$treeprob[8] = ((Gprob(22,$T3+$T2) * Gprob(22,$T2))/18.0) ;
$treeprob[9] = ((Gprob(22,$T3+$T2) * Gprob(22,$T2))/18.0) ;

$treeprob[10] = ((Gprob(22,$T3+$T2) * Gprob(22,$T2))/18.0) ;
$treeprob[11] = ((Gprob(22,$T3+$T2) * Gprob(22,$T2))/18.0) ;
$treeprob[12] = ((Gprob(22,$T3+$T2) * Gprob(22,$T2))/18.0) ;
$treeprob[13] = ((Gprob(22,$T3+$T2) * Gprob(21,$T2))/3.0) + ((Gprob(22,$T3+$T2) * Gprob(22,$T2))/18.0) ;
$treeprob[14] = ((Gprob(22,$T3+$T2) * Gprob(21,$T2))/3.0) + ((Gprob(22,$T3+$T2) * Gprob(22,$T2))/18.0) ;

############################################################################
# Output the probabilities of the 15 gene trees
############################################################################
my($T3_T2) = $T3 + $T2;

print "Species tree:\n";
print "  ((A,B):$T3_T2, (C,D):$T2)\n\n";

print "Expected proportion of each gene tree:\n";
print "* ((AB)(CD)) -- $treeprob[0]\n";
print "  ((AC)(BD)) -- $treeprob[1]\n";
print "  ((AD)(BC)) -- $treeprob[2]\n";
print "  (((AB)C)D) -- $treeprob[3]\n";
print "  (((AB)D)C) -- $treeprob[4]\n";
	
print "  (((AC)B)D) -- $treeprob[5]\n";
print "  (((AC)D)B) -- $treeprob[6]\n";
print "  (((AD)B)C) -- $treeprob[7]\n";
print "  (((AD)C)B) -- $treeprob[8]\n";
print "  (((BC)A)D) -- $treeprob[9]\n";
	
print "  (((BC)D)A) -- $treeprob[10]\n";
print "  (((BD)A)C) -- $treeprob[11]\n";
print "  (((BD)C)A) -- $treeprob[12]\n";
print "  (((CD)A)B) -- $treeprob[13]\n";
print "  (((CD)B)A) -- $treeprob[14]\n";

print "\n* indicates speciodendric gene tree\n\n";

exit;

################################################################################
# Equations for Gij from:                                                      #
#   Rosenberg NA (2002) The probability of topological concordance of gene     #
#   trees and species trees. Theoretical Population Biology 61, 225–247        #
################################################################################
sub Gprob {

	my($Gtype,$Tin) = @_;

	my($Gval);
	my($Tval);
	my($Tv3);

	if ( $Gtype == 21 ) { 
		$Tval = -1.0 * $Tin; 
		$Gval = 1.0 - exp($Tval);
	}
	elsif ( $Gtype == 22 ) { 
		$Tval = -1.0 * $Tin;
		$Gval = exp($Tval);
	}
	elsif ( $Gtype == 31 ) { 
		$Tval = -1.0 * $Tin; $Tv3 = -3.0 * $Tin;
		$Gval = 1.0 - (1.5 * exp($Tval)) + (0.5 * exp($Tv3));
	}
	elsif ( $Gtype == 32 ) { 
		$Tval = -1.0 * $Tin; $Tv3 = -3.0 * $Tin;
		$Gval = (1.5 * exp($Tval)) - (1.5 * exp($Tv3));
	}
	elsif ( $Gtype == 33 ) { 
		$Tv3 = -3.0 * $Tin; 
		$Gval = exp($Tv3);
	}
	
	return $Gval;

}
