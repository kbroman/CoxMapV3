## Cox genetic map V3

Revised [Cox genetic
map](https://doi.org/10.1534/genetics.109.105486), for
[mouse genome build 39](https://www.ncbi.nlm.nih.gov/assembly/GCF_000001635.27/)
coordinates.

The original map was with build 37. Markers were shifted so that 0 cM
== 0 Mbp. It was later moved to build 38, and at some point we changed
it to have 0 cM == 3 Mbp. Shifting to build 39 requires dealing with a
couple of big inversions, particular at (centromeres of chromosome 10
and 14; it seems like the chr 10 one was introduced in build 38 and is
now being corrected, while the chr 14 inversion is new).

The [original crimap
software](http://compgen.rutgers.edu/crimap.shtml) doesn't compile on
modern systems, so we are now using [CRI-MAP
Improved](https://www.animalgenome.org/tools/share/crimap/) by Ian
Evans and Jill Maddox. it gives slightly different results, but not
enough to matter.

- [**`cox_v3_map.csv`**](cox_v3_map.csv) - This is the newest Cox
  genetic map, with build 39 physical positions.

- [`Data/`](Data/)

  - crimap files used for original Cox map (families split and data cleaned)

- [`Perl/`](Perl/)

  - perl scripts used to prepare and run crimap (using version 2.507
    of "[CRIMAP Improved](https://www.animalgenome.org/tools/share/crimap/)")

- [`R/`](R/)

  - scripts to merge crimap maps into a CSV file, to reorder the
    crimap input files, and to combine the genetic and physical maps

- [`OrigMaps/`](OrigMaps/)

  - original (v1 and v2) cox maps

  - seems like combinedmaps_2008-08-06_clean.csv is the original v1
    map

  - snpmap_rev_2008-12-10.csv was the v2 map with positions shifted to
    line up 0 Mbp with 0 cM

  - CoxMaps_rev_build38.csv has build 38 positions added

- [`Build39/`](Build39/)

  - bp coordinates of Cox markers in build 37, 38, and 39

---

### Outline of analysis

1. Run `R/reorder_genfiles.R` to create the crimap input files in the
   Build39 order. Uses `Data/final_gen.tgz` and creates a set of files
   in `WorkV3/`.

   You can similarly run `R/subset_genfiles.R`. This creates crimap
   input files in `WorkV3b/` that have the markers with Build39
   positions, but without reordering the positions.

2. Within the `WorkV3/` directory:

   a. Run `../Perl/prepCrimap.pl` to
      run `crimap prepare` for each of the 20 chromosomes.

   b. Run `../Perl/createCrimapRunFiles.pl`. This
      creates a set of perl scripts plus one bash script, to run crimap
      for each chromosome (chrompic + sex-averaged and sex-specific
      maps).

   c. Run `runall.sh` to run crimap on all chromosomes
   (simultaneously)

3. Run `R/grab_maps.R WorkV3` to grab the estimated map positions and
   create a combined file `map.csv`.

4. Copy `map.csv` to `Build39/cox_build39.csv`.

5. Run `R/combine_maps.R` to combine the genetic and physical maps in
   `Build39/` and create the file `cox_v3_map.csv`.

---

### License

Licensed under the
[MIT license](LICENSE.md). ([More information here](https://en.wikipedia.org/wiki/MIT_License).)
