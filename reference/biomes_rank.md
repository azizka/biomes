# Rank biome schemes for a given occurrence dataset

Compares the biome schemes for a user-supplied set of occurrence records
and proposes a single "best" scheme for that dataset. Each scheme is
scored on several data-driven criteria that are combined into one
`composite_score`, which drives the ranking.

## Usage

``` r
biomes_rank(
  x,
  scheme = NULL,
  biome = NULL,
  lon = "decimalLongitude",
  lat = "decimalLatitude",
  definition = "all",
  criteria = c("coverage", "effective_biomes", "granularity"),
  tiebreaker = c("year", "biomes", "none"),
  verbose = TRUE
)
```

## Arguments

- x:

  A data frame with longitude / latitude columns, an `sf` spatial
  object, or a
  [`terra::SpatVector`](https://rspatial.github.io/terra/reference/SpatVector-class.html)
  of point geometries.

- scheme:

  Optional integer vector in `1:31` (biome scheme numbers) to restrict
  the ranking to a subset of the packaged schemes (e.g.
  `scheme = c(1, 5, 25)`). `NULL` (default) ranks all 31 schemes.
  Ignored when `biome` is supplied.

- biome:

  Optional
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html)
  stack of biome schemes. Use this for custom rasters; for the packaged
  stack prefer `scheme = <int>` instead.

- lon:

  Column name of longitude in `x` (only used if `x` is a non-spatial
  data frame). Default `"decimalLongitude"`.

- lat:

  Column name of latitude in `x` (only used if `x` is a non-spatial data
  frame). Default `"decimalLatitude"`.

- definition:

  Character. Restrict the ranking to the schemes that share one biome
  definition: one of `"all"` (default; rank all 31 schemes),
  `"climate"`, `"vegetation"`, `"land_cover"`, `"ecoregion"`,
  `"integrative"`, or `"anthropogenic"`. The grouping is taken from the
  `biome_definition` column of
  [biomes_information](https://azizka.github.io/biomes/reference/biomes_information.md).
  When a specific definition is chosen, only the schemes of that
  definition are classified, scored and returned, so the scaled scores
  and the best scheme are determined within that group. Ignored when
  `biome` is supplied.

- criteria:

  Character vector with one or more of `"coverage"`,
  `"effective_biomes"`, `"granularity"`. Default: all three.

- tiebreaker:

  How tied `composite_score`s are resolved: `"year"` (default, more
  recent publication ranks higher), `"biomes"` (more biomes ranks
  higher), or `"none"` (do not break ties; tied schemes share a rank,
  dense ranking). With `"year"` and `"biomes"` the other key serves as a
  further fallback, alphabetical `scheme_name` resolves any remaining
  ties, and ranks are strict 1..N. With `"none"` multiple schemes may
  carry `is_best = TRUE`.

- verbose:

  Logical. Print progress messages? Default `TRUE`.

## Value

A data frame of classes `biomes_rank` and `data.frame`, with one row per
compared biome scheme. Columns: `scheme` (the biome scheme number,
1-31), `scheme_name`, `year` (publication year of the scheme),
`n_total`, `n_hit` and `n_na` (number of records in total, classified,
and unclassified), `pct_na` (percentage of unclassified records), then
one `*_raw` and one `*_scaled` column per requested criterion (the raw
score and its rescaled version), `composite_score` (mean of the scaled
criteria, drives the ranking), `rank` (1 = best), and `is_best` (`TRUE`
for the top-ranked scheme). The result carries the attributes `criteria`
(requested), `criteria_used` (those that entered the composite),
`tiebreaker`, `definition`, and `best_scheme` (the biome scheme number
of the top-ranked scheme, ready to be used as the `scheme` argument of
[`biomes_classify()`](https://azizka.github.io/biomes/reference/biomes_classify.md)
or
[`biomes_full()`](https://azizka.github.io/biomes/reference/biomes_full.md)).

## Details

Three equally weighted criteria are used:

1.  **coverage**: fraction of records that the scheme places in a biome
    at all (the rest fall on unclassified, NA cells).

2.  **effective_biomes**: \\\exp(H')\\ (Hill number of order 1), i.e.
    the effective number of biomes the records spread across, weighted
    by evenness.

3.  **granularity**: biomes actually used, divided by the biomes
    available in the scheme.

## Note

`biomes_rank()` gives a data-driven ranking, not an authoritative "best"
classification. The criteria favour schemes that cover your records and
split them into many, evenly-used biomes, but the top-ranked scheme is
not necessarily the most suitable one for your question. For best
results, narrow the comparison to one biome definition via `definition`,
and treat the ranking as a shortlist rather than a verdict: inspect the
per-criterion columns in the result and use
[`biomes_info()`](https://azizka.github.io/biomes/reference/biomes_info.md)
to choose the scheme whose concept and resolution actually match your
data.

## Scaling and the composite score

Every criterion is min-max rescaled to \\\[0, 1\]\\ across the compared
schemes: the scheme with the lowest value gets 0, the one with the
highest gets 1. The `composite_score` is the equal-weight mean of the
rescaled criteria. Because the rescaling is relative to the compared
set, composite scores are comparable only among schemes that were ranked
together, and a rescaled 0 means "lowest among the compared schemes",
not zero. Two edge cases: a criterion that does not vary among the
compared schemes carries no information and is left out of the composite
(its `*_scaled` column is `NA`; see the attribute `criteria_used`), and
a single compared scheme gets no composite score (`NA`) but is still
returned as `best_scheme`.

Schemes are ordered by `composite_score` and ties resolved according to
`tiebreaker`.

## Examples

``` r
data("bombacoideae_occurrences")

# \donttest{
# Ranks the schemes of the biome raster (~36 MB), downloaded on first use.

# Default call: coverage + effective_biomes + granularity, equally weighted
r <- biomes_rank(bombacoideae_occurrences, verbose = FALSE)
head(r)
#>   scheme
#> 1      1
#> 2      2
#> 3      3
#> 4      4
#> 5      5
#> 6      6
#>                                                                                                                  scheme_name
#> 1                                                                       Global vegetation patterns of the past 140,000 years
#> 2                                                  Dataset of the global component of the Copernicus Land Monitoring Service
#> 3                                            Present and future Köppen-Geiger climate classification maps at 1-km resolution
#> 4 Global mapping of potential natural vegetation: an assessment of machine learning algorithms for estimating land potential
#> 5                                                       An ecoregion-based approach to protecting half the terrestrial realm
#> 6                                              A global classification of vegetation based on NDVI, rainfall and temperature
#>   year n_total n_hit n_na pct_na coverage_raw coverage_scaled
#> 1 2020   17030 15999 1031   6.05    0.9394598       0.3369938
#> 2 2019   17030 16175  855   5.02    0.9497945       0.4577900
#> 3 2018   17030 16497  533   3.13    0.9687023       0.6787920
#> 4 2018   17030 16183  847   4.97    0.9502642       0.4632807
#> 5 2017   17030 16488  542   3.18    0.9681738       0.6726150
#> 6 2017   17030 15928 1102   6.47    0.9352907       0.2882636
#>   effective_biomes_raw effective_biomes_scaled granularity_raw
#> 1             4.721102              0.10251879       0.7142857
#> 2             6.556205              0.31649699       0.7500000
#> 3             5.818907              0.23052595       0.5000000
#> 4             5.324543              0.17288175       0.7000000
#> 5             4.329130              0.05681376       0.8666667
#> 6             3.841888              0.00000000       0.6428571
#>   granularity_scaled composite_score rank is_best
#> 1          0.5142857       0.3179328   28   FALSE
#> 2          0.5750000       0.4497623   19   FALSE
#> 3          0.1500000       0.3531060   25   FALSE
#> 4          0.4900000       0.3753875   23   FALSE
#> 5          0.7733333       0.5009207   16   FALSE
#> 6          0.3928571       0.2270402   31   FALSE
attr(r, "best_scheme")
#> [1] 16

# Restrict to a subset of criteria
r2 <- biomes_rank(
  bombacoideae_occurrences,
  criteria = c("coverage", "effective_biomes"),
  verbose  = FALSE
)

# }
```
