# Step 3: Occurrences-to-biome classification

## Goal

With a biome scheme chosen in [Step
2](https://azizka.github.io/biomes/articles/step2-choice-of-a-biome-scheme.md),
[`biomes_classify()`](https://azizka.github.io/biomes/reference/biomes_classify.md)
assigns **one biome per occurrence record**. You select the scheme by
its **biome scheme number** (1-31), the same number
[`biomes_rank()`](https://azizka.github.io/biomes/reference/biomes_rank.md)
returns as the best scheme.

> **Terms.** *Classifying* here means assigning each **occurrence
> record** to a **biome** (e.g. *savanna*) of the chosen **biome
> scheme** (identified by its biome scheme number).

------------------------------------------------------------------------

## 1. Classify occurrence records into biomes

[`biomes_classify()`](https://azizka.github.io/biomes/reference/biomes_classify.md)
takes a table of points (or an `sf` / `SpatVector`) and returns the
**input data with the biome assignment appended on the right**. Pick the
scheme with the `scheme` argument; you never handle `SpatRaster` objects
yourself.

``` r

classified <- biomes_classify(bombacoideae_occurrences, scheme = 1)
#> Coordinates provided as data.frame, assuming WGS84 as CRS.
#> Classified 17030 record(s) against 1 biome layer(s):
#>   - Biome_Inventory_layer_01 (Allen et al., 2020)
head(classified)
#>                     species decimalLongitude decimalLatitude countryCode
#> 1 Cavanillesia platanifolia        -79.98333         -2.1500         ECU
#> 2    Cavanillesia umbellata        -70.25000        -12.0000         PER
#> 3    Cavanillesia umbellata        -78.63333         -4.5000         PER
#> 4    Cavanillesia umbellata        -76.46666         -2.8000         PER
#> 5    Cavanillesia umbellata        -69.10420        -12.0321         PER
#> 6    Cavanillesia umbellata        -74.30611        -11.1425         PER
#>   Biome_Inventory_layer_01_name
#> 1     Tropical raingreen forest
#> 2     Tropical evergreen forest
#> 3     Tropical evergreen forest
#> 4     Tropical evergreen forest
#> 5     Tropical evergreen forest
#> 6     Tropical evergreen forest
```

A new column `Biome_Inventory_layer_01_name` has been added (the column
names carry the raster layer names of the packaged stack). The appended
columns use the suffixes `_value` (raster code) and `_name` (biome
name). Records that fall **outside** every biome of a scheme
(e.g. coastal records or small islands missing from a coarse map) are,
by default, labelled `"no_biome"` rather than dropped, so the counts
stay complete:

``` r

table(classified$Biome_Inventory_layer_01_name, useNA = "ifany")
#> 
#>    Boreal evergreen needleleaf forest                       Boreal parkland 
#>                                     1                                    81 
#>   Boreal summergreen broadleaf forest                                Desert 
#>                                     6                                     2 
#>                              no_biome                               Savanna 
#>                                  1031                                  1316 
#>                            Semidesert                                Steppe 
#>                                   149                                     3 
#>  Temperate broadleaf evergreen forest Temperate needleleaf evergreen forest 
#>                                   876                                   141 
#>                    Temperate parkland                   Temperate shrubland 
#>                                   186                                   236 
#>             Tropical evergreen forest                    Tropical grassland 
#>                                  7405                                   860 
#>             Tropical raingreen forest               Warm temperate woodland 
#>                                  4367                                   370
```

Handling off-map records **explicitly and identically across schemes**
matters, because the amount and spatial pattern of unassigned records
differs between schemes, and is itself one of the ranking criteria in
Step 2.

------------------------------------------------------------------------

## 2. Common variations

``` r

# Several schemes at once, one column per scheme
biomes_classify(bombacoideae_occurrences, scheme = c(1, 25)) |> head(3)
#> Coordinates provided as data.frame, assuming WGS84 as CRS.
#> Classified 17030 record(s) against 2 biome layer(s):
#>   - Biome_Inventory_layer_01 (Allen et al., 2020)
#>   - Biome_Inventory_layer_25 (Ramankutty & Foley, 1999)
#>                     species decimalLongitude decimalLatitude countryCode
#> 1 Cavanillesia platanifolia        -79.98333           -2.15         ECU
#> 2    Cavanillesia umbellata        -70.25000          -12.00         PER
#> 3    Cavanillesia umbellata        -78.63333           -4.50         PER
#>   Biome_Inventory_layer_01_name Biome_Inventory_layer_25_name
#> 1     Tropical raingreen forest          Grassland and steppe
#> 2     Tropical evergreen forest   Tropical evergreen woodland
#> 3     Tropical evergreen forest   Tropical evergreen woodland

# Keep both the raster value and the biome name
biomes_classify(bombacoideae_occurrences, scheme = 1, value = "both") |> head(3)
#> Coordinates provided as data.frame, assuming WGS84 as CRS.
#> Classified 17030 record(s) against 1 biome layer(s):
#>   - Biome_Inventory_layer_01 (Allen et al., 2020)
#>                     species decimalLongitude decimalLatitude countryCode
#> 1 Cavanillesia platanifolia        -79.98333           -2.15         ECU
#> 2    Cavanillesia umbellata        -70.25000          -12.00         PER
#> 3    Cavanillesia umbellata        -78.63333           -4.50         PER
#>   Biome_Inventory_layer_01_value Biome_Inventory_layer_01_name
#> 1                              2     Tropical raingreen forest
#> 2                              1     Tropical evergreen forest
#> 3                              1     Tropical evergreen forest

# Return only the classification columns (drop the input)
biomes_classify(bombacoideae_occurrences, scheme = 1, append = FALSE) |> head(3)
#> Coordinates provided as data.frame, assuming WGS84 as CRS.
#> Classified 17030 record(s) against 1 biome layer(s):
#>   - Biome_Inventory_layer_01 (Allen et al., 2020)
#>   Biome_Inventory_layer_01_name
#> 1     Tropical raingreen forest
#> 2     Tropical evergreen forest
#> 3     Tropical evergreen forest

# Keep NA for off-map points instead of the "no_biome" label
class_na <- biomes_classify(bombacoideae_occurrences, scheme = 1, na = NA)
#> Coordinates provided as data.frame, assuming WGS84 as CRS.
#> Classified 17030 record(s) against 1 biome layer(s):
#>   - Biome_Inventory_layer_01 (Allen et al., 2020)
sum(is.na(class_na$Biome_Inventory_layer_01_name))
#> [1] 1031
```

For a scheme outside the packaged stack, pass your own single-layer
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
via `biome =` instead of a scheme number.

------------------------------------------------------------------------

## Next

Your records now carry a biome assignment. Continue with [Step 4: Output
and
visualisation](https://azizka.github.io/biomes/articles/step4-output-and-visualisation.md)
to tabulate and map them.
