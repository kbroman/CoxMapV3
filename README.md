## Cox genetic map V3

Working to revise the [Cox genetic
map](https://doi.org/10.1534/genetics.109.105486) to
[mouse genome build 39](https://www.ncbi.nlm.nih.gov/assembly/GCF_000001635.27/)
coordinates.

- The original map was with build 37. Markers were shifted so that 0 cM == 0 Mbp.

- It was later moved to build 38, and at some point we changed it to
  have 0 cM == 3 Mbp.

- Shifting to build 39 requires dealing with a couple of big
  inversions, particular at (centromeres of chromosome 10 and 14; it
  seems like the chr 10 one was introduced in build 38 and is now
  being corrected, while the chr 14 inversion is new).

- The [original crimap
  software](http://compgen.rutgers.edu/crimap.shtml) doesn't compile
  on modern systems, so we are now using [CRI-MAP
  Improved](https://www.animalgenome.org/tools/share/crimap/) by Ian
  Evans and Jill Maddox. it gives slightly different results, but not
  enough to matter.

Data/   - crimap files used for original Cox map
          (families split and data cleaned)

Perl/   - perl scripts used to prepare and run crimap
          (using version 2.507 of "[CRIMAP Improved](https://www.animalgenome.org/tools/share/crimap/)")

R/      - script to grab maps from sa*.txt and ss*.txt
          and save data frame in RDS file

Work/   - directory where I'm running cri-map and getting estimated
          maps

OrigMaps/  - original (v1 and v2) cox maps
           - seems like combinedmaps_2008-08-06_clean.csv is the
             original v1 map
           - snpmap_rev_2008-12-10.csv was the v2 map with
             positions shifted to line up 0 Mbp with 0 cM
           - CoxMaps_rev_build38.csv has build 38 positions added

Build39/  - bp coordinates of Cox markers in build 37, 38, and 39
