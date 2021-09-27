#!/usr/bin/perl
######################################################################
#
# makePar.pl
#
# Karl W. Broman, PhD
# August 1997; July 1998
#
######################################################################
#
# Run this program as follows:
#
# makePar.pl 22 107 1
#
######################################################################
#
# This program makes a new par file in the current directory,
# called chr*z.par, and using the given number of markers
#
# The number of markers may be left off; the first argument may be
# either a chromosome number, in which case the gen file is assumed
# to be chr??z.gen, or may be a "stem" (ie, everything prior to the
# .gen). If there's a third argument, 1 means sex-averaged and 0
# means sex-specific.
#
######################################################################

$stem = $ARGV[0];
$genfile = $stem . ".gen";
if(-e $genfile) {
    $parfile = $stem . ".par";
    $datfile = $stem . ".dat";
    $ordfile = $stem . ".ord";
}
else {
    $parfile = "chr" . $stem . "z.par";
    $genfile = "chr" . $stem . "z.gen";
    $datfile = "chr" . $stem . "z.dat";
    $ordfile = "chr" . $stem . "z.ord";
}

$sexave = $ARGV[1];
$nmar = $ARGV[2];

if($nmar == 0) {
    open(IN, $genfile) or die("Cannot read from $genfile");
    $line = <IN>;
    $nmar = <IN>; chomp($nmar);
    close(IN);
}

#
# make par file
#

# print "Creating par file $parfile with $nmar markers\n";
open(PAR, ">$parfile") or die("Cannot write to $parfile in makePar");

print PAR ("dat_file $datfile *\n");
print PAR ("gen_file $genfile *\n");
print PAR ("ord_file $ordfile *\n");
print PAR ("nb_our_alloc 3000000 *\n");

if($sexave) { print PAR ("SEX_EQ 1 *\n"); }
else { print PAR ("SEX_EQ 0 *\n"); }

print PAR ("TOL 0.010000 *\n");
print PAR ("PUK_NUM_ORDERS_TOL 8 *\n");
print PAR ("PK_NUM_ORDERS_TOL 10 *\n");
print PAR ("PUK_LIKE_TOL 2.000 *\n");
print PAR ("PK_LIKE_TOL 2.000 *\n");
#print PAR ("PUK_LIKE_TOL 0.000 *\n");
#print PAR ("PK_LIKE_TOL 0.000 *\n");

print PAR ("use_ord_file 0 *\n");
print PAR ("write_ord_file 0 *\n");
print PAR ("use_haps 0 *\n");
print PAR ("ordered_loci ");
foreach $i (0..($nmar-1)) { print PAR ("$i "); }
print PAR ("*\n");
print PAR ("\nEND\n\n");
print PAR ("Complete_order ");
foreach $i (0..($nmar-1)) { print PAR ("$i "); }
print PAR ("*\n");
close(PAR);
