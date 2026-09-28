# Metadata for the 31 biome schemes

A data frame containing descriptive metadata for each of the 31 biome
classifications shipped with the package. Each row corresponds to one
biome layer in the raster stack returned by
[`biomes_get()`](https://azizka.github.io/biomes/reference/biomes_get.md),
in the same order. The metadata is derived from the inventory compiled
by Fischer et al. (2022).

## Usage

``` r
biomes_information
```

## Format

A data frame with 31 rows and 12 columns:

- publication:

  Original publication of the biome scheme.

- name_of_classification:

  Full name of the biome scheme.

- criteria_for_biome_assignment:

  Criteria used to assign biomes.

- methodology:

  Methodology used to derive the biome classification.

- scheme_number:

  Biome scheme number (1-31); index of the corresponding layer in the
  raster stack returned by
  [`biomes_get()`](https://azizka.github.io/biomes/reference/biomes_get.md).

- background_and_specifications:

  Free-text background information about the classification scheme.

- number_of_biomes_zonal_azonal:

  Total number of biomes in the classification, with the split between
  zonal and azonal biomes in parentheses.

- cover_deviation_percent:

  Deviation of the total area covered by this classification from the
  mean area of all 31 classifications, in percent.

- original_file_format:

  File format of the original data source (e.g. raster, shapefile).

- source:

  URL or citation of the original data source.

- access_date:

  Date on which the original data source was accessed.

- biome_definition:

  The concept on which the scheme delimits its biomes, one of
  `"climate"`, `"vegetation"`, `"land_cover"`, `"ecoregion"`,
  `"integrative"` (a synthesis of several criteria or data sources), or
  `"anthropogenic"`. Used by
  [`biomes_rank()`](https://azizka.github.io/biomes/reference/biomes_rank.md)
  to rank schemes within the group sharing one biome definition.

## Source

Fischer J-C, Walentowitz A, Beierkuhnlein C (2022) The biome inventory -
Standardizing global biogeographical units. Global Ecology and
Biogeography 31(11): 2172-2183.
[doi:10.1111/geb.13574](https://doi.org/10.1111/geb.13574)

## Details

This is the raw metadata table. For an interactive, human-readable
summary of one or more classifications, see
[`biomes_info()`](https://azizka.github.io/biomes/reference/biomes_info.md).
