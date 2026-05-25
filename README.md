# biomes

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
<!-- badges: end -->

**biomes** ships raster layers of 31 commonly used biome definitions
(from Fischer et al. 2022) at 10 × 10 km resolution globally, together
with convenience functions for biogeographic analyses: classify species
occurrences into biomes, rank the biome layers for a given dataset,
tabulate the result, and draw a publication-style map, all the way up
to a single-call wrapper that turns a taxon name into a finished table
and map.

---

## Installation

```r
# install.packages("devtools")
devtools::install_github("azizka/biomes")
library(biomes)
```

`biomes` depends on the [terra](https://rspatial.github.io/terra/)
package and attaches it for you, so `plot()` on a biome layer works
directly. Optional features (mapping, GBIF download, coordinate
cleaning) use packages declared in `Suggests`; install them on demand:
`ggplot2`, `sf`, `viridis`, `tidyterra`, `cowplot`, `ggforce`
(mapping), `rgbif`, `CoordinateCleaner` (GBIF download).

---

## TL;DR: the one-call workflow

`biomes_full()` runs the whole pipeline in a single call. Give it an
occurrence data frame (or a taxon name) and it picks the best biome
layer, classifies the records, tabulates them, and builds a map:

```r
library(biomes)

data(biomes_example)

res <- biomes_full(x = biomes_example)   # layer = "best" is the default

res            # short summary print
res$layer      # which layer was picked
res$ranking    # full ranking table
res$table      # occurrences per biome on the chosen layer
res$map        # ggplot map
print(res$map)
```

`biomes_full()` chooses the best biome layer automatically
(`layer = "best"`, the default, runs `biomes_rank()` internally) or
uses a fixed one (`layer = 1`, …, `layer = 31`). It returns its result
invisibly; set `show = TRUE` to also print the map and table.

```r
biomes_full(x = biomes_example, layer = 31)   # fixed layer
```

You can also start from a scientific name instead of a data frame; see
[Optional: occurrences from GBIF](#optional-occurrences-from-gbif)
below.

The same pipeline as individual building blocks (sections 1 to 5):

```r
ranking <- biomes_rank(biomes_example, verbose = FALSE)
best_id <- attr(ranking, "best_layer")

occ <- biomes_classify(biomes_example, layer = best_id)
biomes_tab(occ)
biomes_visualise(biomes_example, layer = best_id)
```

---

## 1. Load the biome layers and metadata

```r
library(biomes)

layers <- biomes_get()   # SpatRaster with 31 biome layers
layers[[1]]              # first biome layer
plot(layers[[1]])        # quick look (terra is attached by biomes)
```

The matching metadata sits in `biomes_information`, one row per layer,
in the same order as the raster stack:

```r
data(biomes_information)
biomes_information[1, ]
```

For a human-readable summary of one or more biome schemes:

```r
biomes_info(1)              # info for layer 1
biomes_info(c(1, 14, 21))   # info for several layers
biomes_info()               # info for all 31 layers
```

---

## 2. Classify occurrences into biomes

`biomes_classify()` takes a data frame of points (or an `sf` /
`SpatVector`) and returns the **input data with the biome assignment
appended on the right**. Pick the layer by index (`1:31`); no need to
handle `SpatRaster` objects yourself. Records that fall outside every
biome polygon are labelled `"no_biome"` so they are never silently
dropped.

```r
data(biomes_example)

# Default: append the biome-name column for the chosen layer
biomes_example_class <- biomes_classify(biomes_example, layer = 1)
head(biomes_example_class)   # original cols + Biome_Inventory_layer_01_name
table(biomes_example_class$Biome_Inventory_layer_01_name, useNA = "ifany")

# Two layers at once
biomes_classify(biomes_example, layer = c(1, 25))

# Return only the classification columns
biomes_classify(biomes_example, layer = 1, append = FALSE)

# Keep NA for off-polygon points instead of the "no_biome" label
biomes_classify(biomes_example, layer = 1, na = NA)

# Escape hatch for custom rasters: pass a SpatRaster via `biome`
# biomes_classify(my_occ, biome = my_custom_raster)
```

Appended columns are named after the input layers with the suffixes
`_value` (raster value) and `_name` (biome name); use `value = "both"`
to get both.

---

## 3. Pick the best layer for your data

`biomes_rank()` scores all 31 layers on coverage, effective number of
classes and granularity, and proposes a single best layer:

```r
r       <- biomes_rank(biomes_example, verbose = FALSE)
best_id <- attr(r, "best_layer")
best_id
head(r)
```

Diagnostic plots for the ranking:

```r
biomes_show_rank(r, type = "composite")   # composite score bar plot
biomes_show_rank(r, type = "na")          # % unclassified per layer
biomes_show_rank(r, type = "criteria")    # heatmap of all criteria
```

### Rank within a scheme type

The 31 definitions follow very different methodologies (climate-based,
vegetation/DGVM, remote-sensing land cover, ecoregion, integrative
climate-vegetation, and anthropogenic land use), recorded in the
`scheme_type` column of `biomes_information`. Comparing across types can
be misleading: for widely distributed datasets, fine-grained,
full-coverage schemes (e.g. anthropogenic land-use maps) tend to win on
the data-driven criteria. Use the `scheme_type` argument to rank only
within a conceptually comparable group; the output then contains just
the layers of that type:

```r
# rank only the vegetation / potential-natural-vegetation layers
r_veg <- biomes_rank(biomes_example, scheme_type = "vegetation")
attr(r_veg, "best_layer")

table(biomes_information$scheme_type)   # how many layers per type
```

`scheme_type = "all"` (the default) ranks all 31 layers, i.e. the
behaviour above. Other values are `"climate"`, `"vegetation"`,
`"land_cover"`, `"ecoregion"`, `"integrative"` and `"anthropogenic"`.

---

## 4. Tabulate occurrences per biome

```r
library(dplyr)

biomes_example |>
  biomes_classify(layer = best_id) |>
  biomes_tab()
```

`biomes_tab()` counts **occurrence records** (one row of the input =
one occurrence) per biome and layer, returning a long table with one
row per (layer, biome) pair. Because `biomes_classify()` labels
off-polygon points as `"no_biome"` by default, every record is counted
(set `na = NA` in `biomes_classify()` to drop them instead). It also
handles multi-layer classifications in one go:

```r
biomes_classify(biomes_example, layer = c(1, 25)) |>
  biomes_tab()
```

To count unique species per biome rather than records, deduplicate by
`species` before tabulating.

---

## 5. Visualize

`biomes_visualise()` draws an occurrence map over a chosen biome layer:
the layer is rendered as a categorical raster, occurrence points are
overlaid in red, and the per-biome record counts are appended to the
legend labels (so they match `biomes_tab()` exactly).

```r
# map for the best layer (legend on, no pie inset)
biomes_visualise(biomes_example, layer = best_id)

# any specific layer
biomes_visualise(biomes_example, layer = 1)

# add the pie inset showing the share of records per biome
biomes_visualise(biomes_example, layer = 1, pie = TRUE)

# save to disk
p <- biomes_visualise(biomes_example, layer = 1)
ggplot2::ggsave("map_layer_01.jpg", p, width = 13, height = 8, dpi = 600)
```

The optional pie inset is **off by default** (`pie = FALSE`); set
`pie = TRUE` to add it. Use `legend = FALSE` to drop the colour legend
for clean publication figures.

---

## Optional: occurrences from GBIF

If you do not already have an occurrence dataset, `biomes_occ()` can
fetch one from GBIF for a taxon (species, genus, family, …) and run
basic coordinate cleaning. It asks GBIF how many records exist and, for
up to 100,000, downloads them via `occ_search()` (no login). Larger
queries prompt you to either cap at 100,000 or switch to
`occ_download()` (GBIF credentials, returns a citable DOI).

```r
occ <- biomes_occ(taxon = "Fagus sylvatica")
```

`biomes_full()` wires this in for you, so a taxon name is enough for the
full workflow:

```r
res <- biomes_full(taxon = "Fagus sylvatica")
res$table
print(res$map)
```

This GBIF path is a convenience add-on; the core of the package is the
classify, rank, tabulate and visualize workflow above, which works on
any occurrence dataset.

---

## Vignettes

Three vignettes walk through the package step by step:

1. [Biome layers and occurrence data](https://azizka.github.io/biomes/articles/biome-data.html):
   load the layers, inspect their metadata, get occurrences, and rank
   the layers for your data.
2. [Classify, summarize and map](https://azizka.github.io/biomes/articles/classify-summarize-map.html):
   assign occurrences to biomes, tabulate them, and draw a map.
3. [The one-call workflow](https://azizka.github.io/biomes/articles/one-call-workflow.html):
   do all of the above in a single `biomes_full()` call.

From an R session they are also available offline:

```r
browseVignettes("biomes")
vignette("biome-data", package = "biomes")
```

## Citation

Please cite these two references when using the `biomes` package:

1. Fischer J-C, Walentowitz A, Beierkuhnlein C (2022) The biome
   inventory: Standardizing global biogeographical units.
   *Global Ecology and Biogeography* 31(11): 2172-2183.
   <https://doi.org/10.1111/geb.13574>
   Cite this for the compilation of the biome layers.

2. Groß H, Zizka A (2025): biomes: Analysis of Taxon Distributions in
   Global Biomes. R package, Version 0.9.
   <https://github.com/azizka/biomes>. Cite this for the R package.

```r
citation("biomes")
```
