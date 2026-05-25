# 3. The one-call workflow with biomes_full()

## Goal

The first two vignettes ran the workflow step by step:

1.  [Biome layers and occurrence
    data](https://azizka.github.io/biomes/articles/biome-data.md): load
    layers, get occurrences, rank the layers.
2.  [Classify, summarize and
    map](https://azizka.github.io/biomes/articles/classify-summarize-map.md):
    classify, tabulate, visualize.

[`biomes_full()`](https://azizka.github.io/biomes/reference/biomes_full.md)
chains all of those steps into a **single call**. Give it an occurrence
dataset (or a taxon name) and it picks a layer, classifies the records,
tabulates them, and builds a map, returning everything in one object.

------------------------------------------------------------------------

## 1. From an occurrence dataset

The simplest entry point: pass a data frame as `x`. With the default
`layer = "best"`,
[`biomes_full()`](https://azizka.github.io/biomes/reference/biomes_full.md)
runs
[`biomes_rank()`](https://azizka.github.io/biomes/reference/biomes_rank.md)
internally and uses the top-ranked layer.

``` r

data(biomes_example)

res <- biomes_full(x = biomes_example)   # layer = "best" (default)
res
```

    #> <biomes_full result>
    #>   occurrences : 29104 records
    #>   layer       : 16
    #>   picked by   : biomes_rank() (composite = 0.986)
    #>   table rows  : 20 (biomes used)
    #> Components: $occ, $layer, $ranking, $classified, $table, $map

The result is a `biomes_full` object, really just a list with named
components you can pull apart:

``` r

res$layer       # which layer biomes_rank() picked
res$ranking     # the full ranking table (NULL when layer is fixed)
res$classified  # the occurrences with the biome column appended
res$table       # occurrences per biome on the chosen layer
res$occ         # the occurrence data that went in
res$map         # the ggplot / cowplot map
print(res$map)
```

To use a fixed layer instead of ranking, pass an integer in `1:31`:

``` r

biomes_full(x = biomes_example, layer = 31)
```

[`biomes_full()`](https://azizka.github.io/biomes/reference/biomes_full.md)
returns its result **invisibly** and does not print anything by default.
Set `show = TRUE` to also print the map and table as a side effect:

``` r

biomes_full(x = biomes_example, layer = 1, show = TRUE)
```

> **Note:** the map produced by
> [`biomes_full()`](https://azizka.github.io/biomes/reference/biomes_full.md)
> follows the
> [`biomes_visualise()`](https://azizka.github.io/biomes/reference/biomes_visualise.md)
> default, so it has **no pie inset**. If you want one, build the map
> yourself with `biomes_visualise(..., pie = TRUE)` (see vignette 2).

------------------------------------------------------------------------

## 2. From a taxon name

Instead of `x`, pass a scientific name as `taxon`.
[`biomes_full()`](https://azizka.github.io/biomes/reference/biomes_full.md)
then calls
[`biomes_occ()`](https://azizka.github.io/biomes/reference/biomes_occ.md)
to download and clean GBIF occurrences first, and proceeds exactly as
above. This needs a network connection (and the `rgbif` /
`CoordinateCleaner` packages), so it is not run here:

``` r

res <- biomes_full(taxon = "Fagus sylvatica")
res$table
print(res$map)

# multiple taxa, fixed layer
biomes_full(taxon = c("Suricata suricatta", "Mustela lutreola"), layer = 1)
```

Extra arguments are forwarded to
[`biomes_occ()`](https://azizka.github.io/biomes/reference/biomes_occ.md),
e.g. `year_min`, `year_max`, `limit`, `use_download`, or GBIF
credentials:

``` r

biomes_full(taxon = "Fagus sylvatica", year_min = 2000)
```

Provide **either** `x` **or** `taxon`, never both.

------------------------------------------------------------------------

## 3. How it maps onto the building blocks

`biomes_full(x = data, layer = "best")` is equivalent to:

``` r

ranking <- biomes_rank(data, verbose = FALSE)        # vignette 1
best_id <- attr(ranking, "best_layer")

classified <- biomes_classify(data, layer = best_id) # vignette 2
tab        <- biomes_tab(classified)                 # vignette 2
map        <- biomes_visualise(data, layer = best_id)# vignette 2
```

Use
[`biomes_full()`](https://azizka.github.io/biomes/reference/biomes_full.md)
when you want the standard pipeline with one call; reach for the
individual functions when you need to tweak a step, e.g. a different
ranking criterion, custom classification columns, or a map with the pie
inset or without the legend.
