# biomes

**biomes** provides raster layers of 31 commonly used biome definitions
(from Fischer et al, 2022) at 10 × 10 km resolution globally, plus
convenience functions for biogeographic analyses: classify user-provided
species occurrences into biomes, summarize them and visualize.

------------------------------------------------------------------------

## Installation

``` r

# install.packages("devtools")
devtools::install_github("azizka/biomes")
library(biomes)
```

`biomes` depends on the [terra](https://rspatial.github.io/terra/)
package and attaches it for you, so
[`plot()`](https://rspatial.github.io/terra/reference/plot.html) on a
biome layer works directly.

------------------------------------------------------------------------

## 1. Load the biome layers and example dataset

``` r

library(biomes)

layers <- biomes_get()   # SpatRaster with 31 biome layers
layers[[1]]              # first biome layer
plot(layers[[1]])        # quick look (terra is attached by biomes)
```

The matching metadata is available as the `biomes_information` data
frame — one row per layer, in the same order as the raster stack:

``` r

data(biomes_information)
biomes_information[1, ]
```

For a human-readable summary of one or more biome schemes, use
[`biomes_info()`](https://azizka.github.io/biomes/reference/biomes_info.md):

``` r

biomes_info(1)              # info for layer 1
biomes_info(c(1, 14, 21))   # info for several layers
biomes_info()               # info for all 31 layers
```

------------------------------------------------------------------------

## 2. Classify occurrence records into biomes

[`biomes_classify()`](https://azizka.github.io/biomes/reference/biomes_classify.md)
takes a data frame of points (or an `sf` / `SpatVector` of points) and
returns one biome assignment per record. By default it classifies
against all 31 layers shipped with the package.

``` r

data(biomes_example)

# Default: classify against all 31 layers and return biome names
biomes_classify(x = biomes_example)
```

You can restrict the classification to specific layers:

``` r

layers <- biomes_get()

biomes_classify(
  x     = biomes_example,
  biome = layers[[c(1, 25)]]
)
```

You can also display the raster value (the raw biome ID) instead of the
biome name, and customize the coordinate column names:

``` r

biomes_classify(
  x     = biomes_example,
  biome = layers[[1]],
  lon   = "decimalLongitude",
  lat   = "decimalLatitude",
  value = "ID"   # "name" (default), "ID", or "both"
)
```

The output columns are named after the input layers with the suffixes
`_value` (raster value) and `_name` (biome name).

## 3. Tabulate occurrences per biome

``` r

library(dplyr)

biomes_example |>
  biomes_classify() |>
  biomes_biome_tab()
```

This counts **occurrence records** (one row of the input = one
occurrence) per biome and layer. To count unique species per biome,
deduplicate by `species` before tabulating.

## 4. Articles

Three companion articles illustrate how to use the package:

1.  [Count the number of species per
    biome](https://azizka.github.io/biomes/vignettes/articles/species_number_per_biome.html)
2.  [Create publication-level maps of a dataset over a
    biome](https://azizka.github.io/biomes/vignettes/articles/publicaiton_level_map.html)
3.  [Compare two or more biome definitions for a given occurrence
    dataset](https://azizka.github.io/biomes/vignettes/articles/compare_biome_definitions.html)

## Citation

Please cite these two references when using the `biomes` package:

1.  Fischer J-C, Walentowitz A, Beierkuhnlein C (2022) The biome
    inventory — Standardizing global biogeographical units. *Global
    Ecology and Biogeography* 31(11): 2172–2183.
    <https://doi.org/10.1111/geb.13574> — for the compilation of the
    biome layers.

2.  Groß H, Zizka A (2025): biomes: Analysis of Taxon Distributions in
    Global Biomes. R package, Version 0.9.
    <https://github.com/azizka/biomes> — for the R package.

``` r

citation("biomes")
```
