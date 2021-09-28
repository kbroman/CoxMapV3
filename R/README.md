## R scripts

- `grab_maps.R` - grab map information from `sa*.txt` and `ss*.txt`
  output produced by crimap and create a CSV file

- `combine_maps.R` - combined the crimap map with the build 39 physical
  locations and shift the marker positions so that 0 cM == 3 Mbp

- `reorder_genfiles.R` - reorder the crimap input files (`*.gen`)
  according to the build 39 physical positions

- `subset_genfiles.R` - subset the crimap input files (`*.gen`) to the
  markers that have known build 39 physical positions
