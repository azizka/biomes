# One-call workflow: from taxon (or dataset) to table + map

Convenience wrapper that runs the full `biomes` workflow in a single
call. There are two entry paths:

## Usage

``` r
biomes_full(
  x = NULL,
  taxon = NULL,
  layer = "best",
  lon = "decimalLongitude",
  lat = "decimalLatitude",
  value = "name",
  show = FALSE,
  ...
)
```

## Arguments

- x:

  Optional. A data frame with longitude/latitude columns, an `sf`
  spatial object, or a
  [`terra::SpatVector`](https://rspatial.github.io/terra/reference/SpatVector-class.html).
  Mutually exclusive with `taxon`.

- taxon:

  Optional scientific name (species, genus, family, ...). Mutually
  exclusive with `x`.

- layer:

  Either an integer in `1:31` to force a specific layer, or `"best"`
  (default) to pick the best layer via
  [`biomes_rank()`](https://azizka.github.io/biomes/reference/biomes_rank.md).

- lon, lat:

  Column names of longitude / latitude in `x` (data frame only).
  Defaults `"decimalLongitude"`/`"decimalLatitude"`.

- value:

  Passed to
  [`biomes_classify()`](https://azizka.github.io/biomes/reference/biomes_classify.md):
  `"name"` (default), `"ID"`, or `"both"`.

- show:

  Logical. If `TRUE`, print the map and the tabulation to the console as
  a side effect. The function always returns its result invisibly.
  Default: `FALSE`.

- ...:

  Further arguments passed to
  [`biomes_occ()`](https://azizka.github.io/biomes/reference/biomes_occ.md)
  when `taxon` is given (e.g. `limit`, `year_min`, `year_max`,
  `use_download`, GBIF credentials).

## Value

Invisibly, a `biomes_full` list with elements:

- `occ`:

  The occurrence data frame (downloaded or provided).

- `layer`:

  The chosen layer index.

- `ranking`:

  The ranking data frame (only when `layer = "best"`), otherwise `NULL`.

- `classified`:

  The output of
  [`biomes_classify()`](https://azizka.github.io/biomes/reference/biomes_classify.md).

- `table`:

  The biome occurrence table from
  [`biomes_tab()`](https://azizka.github.io/biomes/reference/biomes_tab.md).

- `map`:

  The `ggplot`/`cowplot` map from
  [`biomes_visualise()`](https://azizka.github.io/biomes/reference/biomes_visualise.md).

## Details

1.  **From a taxon name.** Pass a scientific name as `taxon`
    (`x = NULL`). `biomes_full()` calls
    [`biomes_occ()`](https://azizka.github.io/biomes/reference/biomes_occ.md)
    to download cleaned GBIF occurrences for the taxon and then proceeds
    as below.

2.  **From an occurrence dataset.** Pass a data frame, `sf` object or
    [`terra::SpatVector`](https://rspatial.github.io/terra/reference/SpatVector-class.html)
    as `x` (`taxon = NULL`).

Once occurrences are available the function:

- picks the biome layer (either `layer = <integer>` or, with the default
  `layer = "best"`, by running
  [`biomes_rank()`](https://azizka.github.io/biomes/reference/biomes_rank.md)
  and selecting the top-1 layer);

- classifies the records with
  [`biomes_classify()`](https://azizka.github.io/biomes/reference/biomes_classify.md);

- tabulates them with
  [`biomes_tab()`](https://azizka.github.io/biomes/reference/biomes_tab.md);

- draws an occurrence map with
  [`biomes_visualise()`](https://azizka.github.io/biomes/reference/biomes_visualise.md).

## Examples

``` r
if (FALSE) { # \dontrun{
# Path 1: from a taxon name (downloads via GBIF)
res <- biomes_full(taxon = "Fagus sylvatica", limit = 2000)
res$table
res$map

# Path 2: from an existing data frame, pick the best layer
data("biomes_example")
res <- biomes_full(x = biomes_example, layer = "best")

# Path 2 with a fixed layer
res <- biomes_full(x = biomes_example, layer = 1)
} # }
```
