# Species per biome

``` r

library(biomes)
#> Loading required package: terra
#> terra 1.9.27
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:terra':
#> 
#>     intersect, union
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(tidyr)
#> 
#> Attaching package: 'tidyr'
#> The following object is masked from 'package:terra':
#> 
#>     extract
```

## Species per biome

A common question is *how many distinct species occur in each biome?*
The `biomes` package combines well with the tidyverse for this. The key
idea is to:

1.  classify each occurrence into a biome, and
2.  count **unique species** per biome (not occurrences).

For a single biome layer:

``` r

data(biomes_example)
layers <- biomes_get()

class <- biomes_example |>
  biomes_classify(biome = layers[[1]])
#> Warning in biomes_classify(biomes_example, biome = layers[[1]]): Coordinates
#> provided as data.frame, assuming WGS84 as CRS
#> Warning: [extract] transforming vector data to the CRS of the raster
#> Classified 29104 record(s) against 1 biome layer(s):
#>   - Biome_Inventory_layer_01 (Allen et al., 2020)

biomes_example |>
  bind_cols(class) |>
  distinct(species, Biome_Inventory_layer_01_name) |>
  count(Biome_Inventory_layer_01_name, name = "n_species")
#> # A tibble: 20 × 2
#>    Biome_Inventory_layer_01_name         n_species
#>    <chr>                                     <int>
#>  1 Boreal evergreen needleleaf forest            7
#>  2 Boreal parkland                              11
#>  3 Boreal summergreen broadleaf forest           5
#>  4 Desert                                       10
#>  5 Savanna                                      17
#>  6 Semidesert                                   12
#>  7 Shrub tundra                                  5
#>  8 Steppe                                       11
#>  9 Temperate broadleaf evergreen forest         25
#> 10 Temperate mixed forest                       10
#> 11 Temperate needleleaf evergreen forest         9
#> 12 Temperate parkland                            7
#> 13 Temperate shrubland                          18
#> 14 Temperate summergreen forest                 10
#> 15 Tropical evergreen forest                    20
#> 16 Tropical grassland                           11
#> 17 Tropical raingreen forest                    22
#> 18 Tundra                                        1
#> 19 Warm temperate woodland                      14
#> 20 NA                                           13
```

For multiple biome layers in one go:

``` r

class <- biomes_example |>
  biomes_classify(biome = layers[[c(1, 17)]])
#> Warning in biomes_classify(biomes_example, biome = layers[[c(1, 17)]]):
#> Coordinates provided as data.frame, assuming WGS84 as CRS
#> Warning: [extract] transforming vector data to the CRS of the raster
#> Classified 29104 record(s) against 2 biome layer(s):
#>   - Biome_Inventory_layer_01 (Allen et al., 2020)
#>   - Biome_Inventory_layer_17 (European Space Agency, 2010)

biomes_example |>
  bind_cols(class) |>
  select(species, ends_with("_name")) |>
  pivot_longer(
    cols      = ends_with("_name"),
    names_to  = "layer",
    values_to = "biome"
  ) |>
  distinct(layer, biome, species) |>
  count(layer, biome, name = "n_species")
#> # A tibble: 42 × 3
#>    layer                         biome                                n_species
#>    <chr>                         <chr>                                    <int>
#>  1 Biome_Inventory_layer_01_name Boreal evergreen needleleaf forest           7
#>  2 Biome_Inventory_layer_01_name Boreal parkland                             11
#>  3 Biome_Inventory_layer_01_name Boreal summergreen broadleaf forest          5
#>  4 Biome_Inventory_layer_01_name Desert                                      10
#>  5 Biome_Inventory_layer_01_name Savanna                                     17
#>  6 Biome_Inventory_layer_01_name Semidesert                                  12
#>  7 Biome_Inventory_layer_01_name Shrub tundra                                 5
#>  8 Biome_Inventory_layer_01_name Steppe                                      11
#>  9 Biome_Inventory_layer_01_name Temperate broadleaf evergreen forest        25
#> 10 Biome_Inventory_layer_01_name Temperate mixed forest                      10
#> # ℹ 32 more rows
```
