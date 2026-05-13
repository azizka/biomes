# Legend (biome class names) for the 31 biome classifications

A data frame mapping the raster values used in each of the 31 biome
layers to human-readable biome class names. Each row corresponds to one
layer in the raster stack returned by
[`biomes_get()`](https://azizka.github.io/biomes/reference/biomes_get.md),
in the same order. Columns `id_1`, `id_2`, ... give the biome class
names for raster values 1, 2, ..., respectively. Cells are `NA` for
classifications with fewer classes than the maximum across all
classifications.

## Usage

``` r
biomes_legend
```

## Format

A data frame with 31 rows and 41 columns:

- layer:

  Index of the layer in the raster stack returned by
  [`biomes_get()`](https://azizka.github.io/biomes/reference/biomes_get.md).

- source:

  Short reference to the publication that defines the classification.

- id_1, id_2, id_3, id_4, id_5, id_6, id_7, id_8, id_9, id_10, id_11,
  id_12, id_13, id_14, id_15, id_16, id_17, id_18, id_19, id_20, id_21,
  id_22, id_23, id_24, id_25, id_26, id_27, id_28, id_29, id_30, id_31,
  id_32, id_33, id_34, id_35, id_36, id_37, id_38, id_39:

  Biome class names for raster values 1 through 39. `NA` if the
  classification has fewer classes.

## Source

Fischer J-C, Walentowitz A, Beierkuhnlein C (2022) The biome inventory -
Standardizing global biogeographical units. Global Ecology and
Biogeography 31(11): 2172-2183.
[doi:10.1111/geb.13574](https://doi.org/10.1111/geb.13574)
