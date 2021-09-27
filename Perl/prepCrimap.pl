#!/usr/bin/perl
######################################################################
# prepCrimap.pl
#
# run makePar and crimap prepare for all chromosomes
######################################################################

$stem = $ARGV[0];
if($stem eq "") { $stem = "final"; }
if($ARGV[1] eq "") {
    @chr = (1..19,"X");
}
else {
    @chr = @ARGV[1..(@ARGV-1)];
}

foreach $chr (@chr) {
    print "Chr $chr\n";
    system("../Perl/makePar.pl $stem$chr 0");
    $parfile = $stem . $chr . ".par";
    $datfile = $stem . $chr . ".dat";
    if(-e $datfile) {
	system("\\rm $datfile");
    }
    system("crimap $parfile prepare < ../Perl/crimap_input.txt > prep$chr\.txt");
}    
