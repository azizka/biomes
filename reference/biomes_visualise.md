# Map occurrences over a biome layer

Produces a publication-style map of occurrence records overlaid on a
single biome layer (rendered as a categorical raster). Optionally adds a
pie-chart inset showing the proportion of records per biome.

## Usage

``` r
biomes_visualise(
  x,
  layer = 1L,
  biome = NULL,
  lon = "decimalLongitude",
  lat = "decimalLatitude",
  pie = FALSE,
  legend = TRUE,
  point_color = "#B20000",
  point_size = 0.25,
  title = NULL
)
```

## Arguments

- x:

  A data frame with longitude/latitude columns, an `sf` spatial object,
  or a
  [`terra::SpatVector`](https://rspatial.github.io/terra/reference/SpatVector-class.html)
  of point geometries.

- layer:

  Integer in `1:31` (default `1`). Index into the packaged biome raster
  stack. Ignored when `biome` is provided.

- biome:

  Optional
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  with a single layer. If `NULL`, the layer at index `layer` of the
  packaged raster stack is used.

- lon:

  Column name of longitude in `x` (data frame only). Default
  `"decimalLongitude"`.

- lat:

  Column name of latitude in `x` (data frame only). Default
  `"decimalLatitude"`.

- pie:

  Logical. If `TRUE`, draw a pie inset on the map showing the share of
  records per biome (only segments \>= 5% are labelled). Default
  `FALSE`.

- legend:

  Logical. If `TRUE` (default), draw the biome colour legend on the
  right side of the map. Set to `FALSE` to drop it (useful for clean
  publication figures or when the pie inset already conveys the
  proportions).

- point_color:

  Colour of the occurrence points. Default `"#B20000"`.

- point_size:

  Numeric size of the occurrence points. Default `0.25`.

- title:

  Plot title. If `NULL` (default), a sensible title is generated from
  the layer name and the source.

## Value

A `ggplot` object (when `pie = FALSE`) or a
[`cowplot::ggdraw`](https://wilkelab.org/cowplot/reference/ggdraw.html)
object (when `pie = TRUE`). Print to display or save with
[`ggplot2::ggsave()`](https://ggplot2.tidyverse.org/reference/ggsave.html).

## Details

The chosen biome layer is drawn directly with
[`tidyterra::geom_spatraster()`](https://dieghernan.github.io/tidyterra/reference/geom_spatraster.html)
(no polygonisation), occurrence points are reprojected to the layer's
CRS, and the count per biome – computed via
[`biomes_classify()`](https://azizka.github.io/biomes/reference/biomes_classify.md)
so it matches
[`biomes_tab()`](https://azizka.github.io/biomes/reference/biomes_tab.md)
exactly – is appended to the legend labels.

## Examples

``` r
if (FALSE) { # \dontrun{
data("biomes_example")
biomes_visualise(biomes_example, layer = 1)
biomes_visualise(biomes_example, layer = 17, pie = FALSE)
biomes_visualise(biomes_example, layer = 1, legend = FALSE)
} # }
```
