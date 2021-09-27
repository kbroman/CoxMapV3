#!/usr/bin/perl
######################################################################
# createCrimapRunFiles.pl
######################################################################

$nproc = $ARGV[0];
if($nproc eq "") { $nproc = 20; }
if(@ARGV < 2) {
    @chr = (1..19,"X");
}
else {
    @chr = @ARGV[1..(@ARGV-1)];
}

$j = 0;
foreach $i (0..(@chr-1)) {
    push(@{$thechr[$j]}, $chr[$i]);
    $j++;
    if($j >= $nproc) { $j=0; }
}
#foreach $i (0..($nproc-1)) {
#    print(join("|", @{$thechr[$i]}), "\n");
#}

open(OUT2, ">runall.sh");

foreach $i (0..($nproc-1)) {
    $ofile = "run" . ($i+1) . ".pl";
    print " -Writing to $ofile\n";
    open(OUT, ">$ofile") or die("Cannot write to $ofile");
    print OUT "#!/usr/bin/perl\n";
    print OUT ('@chr = (reverse (', join(",", @{$thechr[$i]}), "));\n");
    print OUT ('foreach $chr (@chr) {', "\n");
    print OUT ('  system("../Perl/makePar.pl final$chr 0");', "\n");
    print OUT ('  system("crimap final$chr.par fixed > ss$chr.txt");', "\n");
    print OUT ('  system("crimap final$chr.par chrompic > pic$chr.txt");', "\n");
    print OUT ('  system("makePar.pl final$chr 1");', "\n");
    print OUT ('  system("crimap final$chr.par fixed > sa$chr.txt");', "\n");
    print OUT ("}\n");
    system("chmod +x $ofile");

    print OUT2 ("nice -n 20 ", $ofile, " &\n");
}
system("chmod +x runall.sh");
