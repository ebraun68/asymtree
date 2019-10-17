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

if ( @ARGV != 2 ) {
	print "Usage:\n  \$ $progname <infile> <outfile> \n";
	print "  infile  = relaxed phylip format file (informative sites)\n";
	print "  outfile = nexus format file (perfect sites)\n";
	print "exiting...\n";
	exit;
}

my($infile)  = $ARGV[0];
my($outfile) = $ARGV[1];

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
# Identify perfect sites
############################################################################
my($nA);	my($nC);	my($nG);	my($nT);	my($other);
my($states);
my @perfect;
for ($iter=0; $iter<$nchar; $iter++) { $perfect[$iter] = 0; }
my($perfectsites) = 0;

for ($iter=0; $iter<$nchar; $iter++) {
	$nA=0; $nC=0; $nG=0; $nT=0;
	$other=0; $states=0;
	for ($jter=0; $jter<$ntax; $jter++) {
		$tvar1 = substr($seq[$jter],$iter,1);
		if ( uc($tvar1) eq "A" ) { $nA++; }
		elsif ( uc($tvar1) eq "C" ) { $nC++; }
		elsif ( uc($tvar1) eq "G" ) { $nG++; }
		elsif ( uc($tvar1) eq "T" ) { $nT++; }
		else { $other++; }
	}
	if ( $nA > 0 ) { $states++; }
	if ( $nC > 0 ) { $states++; }
	if ( $nG > 0 ) { $states++; }
	if ( $nT > 0 ) { $states++; }
	if ( $other == 0 && $states == 2 ) { $perfect[$iter]=1; $perfectsites++; }
}

############################################################################
# Write the perfect sites to nexus files
############################################################################

open (my $OUTF, ">$outfile.all.nex") or die "Could not open file < $outfile.all.nex > for output.\n";
open (my $TVF, ">$outfile.tv.nex") or die "Could not open file < $outfile.tv.nex > for output.\n";


print $OUTF "#NEXUS\n\n";
print $OUTF "Begin data;\n";
print $OUTF "\tDimensions ntax=$ntax nchar=$perfectsites;\n";
print $OUTF "\tFormat datatype=dna missing=? gap=-;\n";
print $OUTF "\tMatrix\n";

print $TVF "#NEXUS\n\n";
print $TVF "Begin data;\n";
print $TVF "\tDimensions ntax=$ntax nchar=$perfectsites;\n";
print $TVF "\tFormat datatype=standard missing=? gap=-;\n";
print $TVF "\tMatrix\n";

for ($iter=0; $iter<$ntax; $iter++) {
	print $OUTF "$name[$iter]     ";
	print $TVF "$name[$iter]     ";
	for ($jter=0; $jter<$nchar; $jter++) {
		if ( $perfect[$jter] == 1 ) {
			$tvar1 = substr($seq[$iter],$jter,1);
			print $OUTF "$tvar1";
			if ( uc($tvar1) eq "A" || uc($tvar1) eq "G" ) { print $TVF "0"; }
			else { print $TVF "1"; }
		}
	}
	print $OUTF "\n";
	print $TVF "\n";
}

print $OUTF "\t;\nEnd;\n\n";
print $TVF "\t;\nEnd;\n\n";

close($OUTF) or die "Could not close file < $outfile.all.nex >\n";
close($TVF) or die "Could not close file < $outfile.all.nex >\n";

print "\nPerfect sites written to $outfile.all.nex and $outfile.tv.nex\n";
print "Exiting...\n";

