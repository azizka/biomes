# Biome classification workflow

## Goal

This vignette shows how to classify species occurrence data into biome
schemes shipped with the `biomes` package. The workflow has three
building blocks:

- [`biomes_get()`](https://azizka.github.io/biomes/reference/biomes_get.md)
  — load the 31 biome raster layers.
- [`biomes_info()`](https://azizka.github.io/biomes/reference/biomes_info.md)
  / `biomes_information` — inspect biome metadata.
- [`biomes_classify()`](https://azizka.github.io/biomes/reference/biomes_classify.md)
  — assign each occurrence to a biome.
- [`biomes_biome_tab()`](https://azizka.github.io/biomes/reference/biomes_biome_tab.md)
  — tabulate occurrences per biome.

------------------------------------------------------------------------

## 1. Load biome layers and metadata

``` r

layers <- biomes_get()
layers
#> class       : SpatRaster
#> size        : 1800, 3600, 31  (nrow, ncol, nlyr)
#> resolution  : 10000, 10000  (x, y)
#> extent      : -1.8e+07, 1.8e+07, -9000000, 9000000  (xmin, xmax, ymin, ymax)
#> coord. ref. : +proj=moll +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84 +units=m +no_defs
#> source      : Biomes_Inventory_RasterStack.tif
#> names       : Biome~er_01, Biome~er_02, Biome~er_03, Biome~er_04, Biome~er_05, Biome~er_06, ...
#> min values  :           1,           1,           1,           1,           1,           1, ...
#> max values  :          21,          98,          30,          20,          15,          14, ...
```

`layers` is a `SpatRaster` with 31 layers. Each layer corresponds to one
row of the `biomes_information` data frame:

``` r

data(biomes_information)
biomes_information[1, c("publication", "name_of_classification",
                        "layer_in_raster_stack")]
#> # A tibble: 1 × 3
#>   publication        name_of_classification                layer_in_raster_stack
#>   <chr>              <chr>                                                 <dbl>
#> 1 Allen et al., 2020 Global vegetation patterns of the pa…                     1
```

For an interactive summary of a specific scheme:

``` r

biomes_info(1)
```

------------------------------------------------------------------------

## 2. Classify occurrence records

[`biomes_classify()`](https://azizka.github.io/biomes/reference/biomes_classify.md)
accepts a `data.frame` (with longitude/latitude columns), an `sf`
object, or a
[`terra::SpatVector`](https://rspatial.github.io/terra/reference/SpatVector-class.html).
By default it uses all 31 layers.

``` r

data(biomes_example)

# Classify against a single layer, return biome names
class_1 <- biomes_classify(
  x     = biomes_example,
  biome = layers[[1]],
  value = "name"
)
#> Warning in biomes_classify(x = biomes_example, biome = layers[[1]], value =
#> "name"): Coordinates provided as data.frame, assuming WGS84 as CRS
#> Warning: [extract] transforming vector data to the CRS of the raster
#> Classified 29104 record(s) against 1 biome layer(s):
#>   - Biome_Inventory_layer_01 (Allen et al., 2020)
head(class_1)
#>   Biome_Inventory_layer_01_name
#> 1  Temperate summergreen forest
#> 2  Temperate summergreen forest
#> 3     Tropical raingreen forest
#> 4       Warm temperate woodland
#> 5  Temperate summergreen forest
#> 6     Tropical raingreen forest
```

Use `value = "ID"` for the raw raster value, or `value = "both"` to keep
both side by side. With multiple layers, one `_value` / `_name` column
is produced per layer:

``` r

class_multi <- biomes_classify(
  x     = biomes_example,
  biome = layers[[c(1, 5, 25)]],
  value = "both"
)
#> Warning in biomes_classify(x = biomes_example, biome = layers[[c(1, 5, 25)]], :
#> Coordinates provided as data.frame, assuming WGS84 as CRS
#> Warning: [extract] transforming vector data to the CRS of the raster
#> Classified 29104 record(s) against 3 biome layer(s):
#>   - Biome_Inventory_layer_01 (Allen et al., 2020)
#>   - Biome_Inventory_layer_05 (Dinerstein et al., 2017)
#>   - Biome_Inventory_layer_25 (Ramankutty & Foley, 1999)
head(class_multi)
#>   Biome_Inventory_layer_01_value Biome_Inventory_layer_01_name
#> 1                             13  Temperate summergreen forest
#> 2                             13  Temperate summergreen forest
#> 3                              2     Tropical raingreen forest
#> 4                              5       Warm temperate woodland
#> 5                             13  Temperate summergreen forest
#> 6                              2     Tropical raingreen forest
#>   Biome_Inventory_layer_05_value
#> 1                             11
#> 2                             11
#> 3                              3
#> 4                              7
#> 5                             11
#> 6                              3
#>                              Biome_Inventory_layer_05_name
#> 1                     Temperate broadleaf and mixed forest
#> 2                     Temperate broadleaf and mixed forest
#> 3 Tropical and subtropical grassland savanna and shrubland
#> 4                              Deserts and xeric shrubland
#> 5                     Temperate broadleaf and mixed forest
#> 6 Tropical and subtropical grassland savanna and shrubland
#>   Biome_Inventory_layer_25_value Biome_Inventory_layer_25_name
#> 1                              9  Temperate deciduous woodland
#> 2                              9  Temperate deciduous woodland
#> 3                              3                       Savanna
#> 4                              6                Open shrubland
#> 5                              9  Temperate deciduous woodland
#> 6                              3                       Savanna
```

For raster values that have no entry in the legend (azonal classes
encoded with high values such as 90+), the name column falls back to
`"azonal (raster value: X)"` rather than `NA`.

------------------------------------------------------------------------

## 3. Tabulate occurrences per biome

[`biomes_biome_tab()`](https://azizka.github.io/biomes/reference/biomes_biome_tab.md)
summarizes the number of **occurrence records** (one row of the input
data = one occurrence) per biome and layer:

``` r

class_multi |>
  biomes_biome_tab()
#>                       layer
#> 1  Biome_Inventory_layer_01
#> 2  Biome_Inventory_layer_01
#> 3  Biome_Inventory_layer_01
#> 4  Biome_Inventory_layer_01
#> 5  Biome_Inventory_layer_01
#> 6  Biome_Inventory_layer_01
#> 7  Biome_Inventory_layer_01
#> 8  Biome_Inventory_layer_01
#> 9  Biome_Inventory_layer_01
#> 10 Biome_Inventory_layer_01
#> 11 Biome_Inventory_layer_01
#> 12 Biome_Inventory_layer_01
#> 13 Biome_Inventory_layer_01
#> 14 Biome_Inventory_layer_01
#> 15 Biome_Inventory_layer_01
#> 16 Biome_Inventory_layer_01
#> 17 Biome_Inventory_layer_01
#> 18 Biome_Inventory_layer_01
#> 19 Biome_Inventory_layer_01
#> 20 Biome_Inventory_layer_05
#> 21 Biome_Inventory_layer_05
#> 22 Biome_Inventory_layer_05
#> 23 Biome_Inventory_layer_05
#> 24 Biome_Inventory_layer_05
#> 25 Biome_Inventory_layer_05
#> 26 Biome_Inventory_layer_05
#> 27 Biome_Inventory_layer_05
#> 28 Biome_Inventory_layer_05
#> 29 Biome_Inventory_layer_05
#> 30 Biome_Inventory_layer_05
#> 31 Biome_Inventory_layer_05
#> 32 Biome_Inventory_layer_05
#> 33 Biome_Inventory_layer_05
#> 34 Biome_Inventory_layer_05
#> 35 Biome_Inventory_layer_25
#> 36 Biome_Inventory_layer_25
#> 37 Biome_Inventory_layer_25
#> 38 Biome_Inventory_layer_25
#> 39 Biome_Inventory_layer_25
#> 40 Biome_Inventory_layer_25
#> 41 Biome_Inventory_layer_25
#> 42 Biome_Inventory_layer_25
#> 43 Biome_Inventory_layer_25
#> 44 Biome_Inventory_layer_25
#> 45 Biome_Inventory_layer_25
#> 46 Biome_Inventory_layer_25
#>                                                       biome     n
#> 1                        Boreal evergreen needleleaf forest  2217
#> 2                                           Boreal parkland   367
#> 3                       Boreal summergreen broadleaf forest   384
#> 4                                                    Desert   221
#> 5                                                   Savanna   447
#> 6                                                Semidesert   583
#> 7                                              Shrub tundra   483
#> 8                                                    Steppe   148
#> 9                      Temperate broadleaf evergreen forest  5171
#> 10                                   Temperate mixed forest  1687
#> 11                    Temperate needleleaf evergreen forest   323
#> 12                                       Temperate parkland   407
#> 13                                      Temperate shrubland   729
#> 14                             Temperate summergreen forest  6139
#> 15                                Tropical evergreen forest  1860
#> 16                                       Tropical grassland   118
#> 17                                Tropical raingreen forest   824
#> 18                                                   Tundra     2
#> 19                                  Warm temperate woodland  2342
#> 20                                      Boreal forest/taiga  1124
#> 21                              Deserts and xeric shrubland   979
#> 22                            Flooded grassland and savanna   143
#> 23                                                 Mangrove   105
#> 24                 Mediterranean forest woodland and scrub   3621
#> 25                          Montane grassland and shrubland   205
#> 26                                             Rock and ice     2
#> 27                     Temperate broadleaf and mixed forest 10404
#> 28                                 Temperate conifer forest  1818
#> 29                Temperate grassland savanna and shrubland  1229
#> 30               Tropical and subtropical coniferous forest   170
#> 31            Tropical and subtropical dry broadleaf forest   768
#> 32 Tropical and subtropical grassland savanna and shrubland  5155
#> 33          Tropical and subtropical moist broadleaf forest  1618
#> 34                                                   Tundra   602
#> 35                                          Boreal woodland  1775
#> 36                                          Dense shrubland  2415
#> 37                                        Desert and barren    94
#> 38                                     Grassland and steppe  1296
#> 39                                           Mixed woodland  3187
#> 40                                           Open shrubland   812
#> 41                                                  Savanna  7265
#> 42                             Temperate deciduous woodland  5731
#> 43                             Temperate evergreen woodland  3529
#> 44                              Tropical deciduous woodland   339
#> 45                              Tropical evergreen woodland  2350
#> 46                                                   Tundra   192
```

For unique-species counts per biome, deduplicate by species before
tabulating (see the *Species per biome* article).

------------------------------------------------------------------------

## 4. Custom coordinate columns

If your data uses different longitude/latitude column names, pass them
via `lon` and `lat`:

``` r

biomes_classify(
  x     = biomes_example,
  biome = layers[[1]],
  lon   = "decimalLongitude",
  lat   = "decimalLatitude",
  value = "name"
) |>
  head(3)
#> Warning in biomes_classify(x = biomes_example, biome = layers[[1]], lon =
#> "decimalLongitude", : Coordinates provided as data.frame, assuming WGS84 as CRS
#> Warning: [extract] transforming vector data to the CRS of the raster
#> Classified 29104 record(s) against 1 biome layer(s):
#>   - Biome_Inventory_layer_01 (Allen et al., 2020)
#>   Biome_Inventory_layer_01_name
#> 1  Temperate summergreen forest
#> 2  Temperate summergreen forest
#> 3     Tropical raingreen forest
```

------------------------------------------------------------------------

## Summary

The typical workflow is:

1.  Load layers with
    [`biomes_get()`](https://azizka.github.io/biomes/reference/biomes_get.md)
    and pick the scheme(s) of interest.
2.  Inspect them with
    [`biomes_info()`](https://azizka.github.io/biomes/reference/biomes_info.md)
    or `biomes_information`.
3.  Classify your occurrences with
    [`biomes_classify()`](https://azizka.github.io/biomes/reference/biomes_classify.md).
4.  Summarize with
    [`biomes_biome_tab()`](https://azizka.github.io/biomes/reference/biomes_biome_tab.md)
    and / or join the classification back to your data for further
    analysis.
