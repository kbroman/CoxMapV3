#!/usr/bin/perl
######################################################################
# identifyXO.pl
#
# use the results of the clean chompic output to identify the locations
# of crossovers and the number of typed markers between them.
######################################################################

@chr = (1..19,"X");
foreach $chr (@chr) {
    $ischr{$chr} = 1;
}

$picfile = $ARGV[0];
if($ischr{$picfile}) {
    $chr = $picfile;
    $picfile = "pic$chr\_clean.txt";
    $mapfile = "ss$chr\.txt";
    $outfile1 = "xo$chr\.csv";
    $outfile2 = "dblxo$chr\.csv";
    $outfile3 = "nxo$chr\.csv";

    $opic = "pic$chr\.txt";
    print " -Cleaning chrompic file\n";
    system("cleanChrompic.pl $opic $picfile");
}
else {
  $mapfile = $ARGV[1];
  $outfile1 = $ARGV[2];
  $outfile2 = $ARGV[3];
  $outfile3 = $ARGV[4];
  if($picfile eq "") {
      $picfile = "pic19_clean.txt";
  }
  if($mapfile eq "") {
      $mapfile = "ss19.txt";
  }
  if($outfile1 eq "") {
      $outfile1 = "xo19.csv";
  }
  if($outfile2 eq "") {
      $outfile2 = "dblxo19.csv";
  }
  if($outfile3 eq "") {
      $outfile3 = "nxo19.csv";
  }
}





print " -Reading $picfile\n";
open(IN, $picfile) or die("Cannot read from $picfile");
while($line = <IN>) {
    ($fam,$ind,$par,$pic) = split(/\s+/, $line);
    $pic =~ s/i/1/g;
    $pic =~ s/o/0/g;
    $pic{$fam}{$ind}{$par} = $pic;
    unless($seenfam{$fam}) {
	$seenfam{$fam} = 1;
	push(@fam, $fam);
    }
    unless($seenind{$fam}{$ind}) {
	$seenind{$fam}{$ind} = 1;
	push(@{$ind{$fam}}, $ind);
    }
}
close(IN);

print " -Reading $mapfile\n";
open(IN, $mapfile) or die("Cannot read from $mapfile");
while($line = <IN>) {
    if($line =~ /ex-specific/) { last; }
}
while($line = <IN>) {
    $line = <IN>; chomp($line);
    if($line =~ /denotes recomb/) { last; }
    @v = split(/\s+/, $line);
    if($v[0] eq "") { shift @v; }
    ($index,$marker,$fem,$mal) = @v;
    push(@markers, $marker);
    $loc{$marker}{"ma"} = $fem;
    $loc{$marker}{"pa"} = $mal;
}

print " -Writing to $outfile1, $outfile2 and $outfile3\n";
open(OUT1, ">$outfile1") or die("Cannot write to $outfile1");
open(OUT2, ">$outfile2") or die("Cannot write to $outfile2");
open(OUT3, ">$outfile3") or die("Cannot write to $outfile3");
print OUT1 "fam,ind,par,left,right,leftloc,rightloc,nmar,distance\n";
print OUT2 "fam,ind,par,left,right,mind,maxd,ntyped\n";
print OUT3 "fam,ind,par,nxo\n";

$nmar = @markers;
foreach $fam (@fam) {
    foreach $ind (@{$ind{$fam}}) {
	foreach $par ("ma","pa") {
	    $flag = 0;
	    @pic = split(//, $pic{$fam}{$ind}{$par});
	    if(@pic != $nmar) {
		$n = @pic;
		print " ---Problem: $fam $ind $par $nmar $n\n";
	    }

	    @left = @right = ();
	    $cur = "";
	    foreach $i (0..(@pic-1)) {
		if($pic[$i] ne "-") { 
		    $flag = 1;
		    if($cur eq "") { 
			$cur = $pic[$i];
			$left = $i;
		    }
		    elsif($cur eq $pic[$i]) {
			$left = $i;
		    }
		    else {
			$cur = $pic[$i];
			push(@left, $left);
			push(@right, $i);
			$left = $i;
		    }
		}
	    }
	    if($flag==1) {
		$nxo = @left;
		print OUT3 "$fam,$ind,$par,$nxo\n";
	    }
	    if(@left > 0) {
		foreach $i (0..(@left-1)) {
		    $ld = $loc{$markers[$left[$i]]}{$par};
		    $rd = $loc{$markers[$right[$i]]}{$par};
		    print OUT1 "$fam,$ind,$par,$left[$i],$right[$i],$ld,$rd,";
		    print OUT1 ($right[$i]-$left[$i]-1,",",$rd-$ld,"\n");
		}
	    }
	    if(@left > 1)  {
		foreach $i (0..(@left-2)) {
		    $mind = $loc{$markers[$left[$i+1]]}{$par} - $loc{$markers[$right[$i]]}{$par};
		    $maxd = $loc{$markers[$right[$i+1]]}{$par} - $loc{$markers[$left[$i]]}{$par};
		    $nt=0;
		    foreach $j ($right[$i]..$left[$i+1]) {
			if($pic[$j] ne "-") { 
			    $nt++;
			}
		    }
		    print OUT2 "$fam,$ind,$par,$right[$i],$left[$i+1],$mind,$maxd,$nt\n";
		}
	    }

	}
    }
}
