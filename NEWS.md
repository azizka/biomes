# biomes 0.9.5

* The example dataset is now `bombacoideae_occurrences`: 17,030 occurrence
  records of 185 Bombacoideae species (Zizka et al. 2020), the worked
  example of the companion paper. It is used in the README, the vignettes
  and all function examples; the previous dataset `biomes_example` has
  been removed.
* `biomes_information` gains the column `biome_definition` (climate,
  vegetation, land_cover, ecoregion, integrative, anthropogenic); the
  `definition` argument of `biomes_rank()`, `biomes_visualise()` and
  `biomes_full(scheme = )` ranks within one biome definition. Scheme 6
  (Zhang et al. 2017, climate and NDVI clustering) is `integrative`.
* `biomes_rank()`: the criterion is called `effective_biomes`
  (columns `effective_biomes_raw` / `_scaled`); `tiebreaker = "biomes"`.
  The ranking uses exactly the three criteria of the companion paper
  (`coverage`, `effective_biomes`, `granularity`), min-max rescaled and
  averaged with equal weights; the experimental criteria `evenness`,
  `informativeness` and `agreement` and the `scaling` argument have been
  removed. A criterion without variation among the compared
  schemes is left out of the composite (attribute `criteria_used`), and
  a single compared scheme gets no composite score (`NA`) but is still
  returned as `best_scheme`.
* `biomes_visualise()`: the `rank` panel labels schemes as
  `25 (Ramankutty & Foley, 1999)`, shows all compared schemes (or the
  `top_n` best) on one 0 to 1 axis (the rescaled criterion values that
  enter the composite score; axis titles carry the symbols of the paper,
  `Coverage (C)`, `Effective biomes (E)`, `Granularity (G)`) and outlines the best composite score and
  the best value of each criterion in red; panels carry left-aligned titles with the
  panel letter and the reference of the chosen scheme (`titles`); the map
  legend lists biome names only (`legend_counts = FALSE`); the barplot
  uses the map colours per biome, grey for off-map records, and thousands
  separators.
* Maintainer e-mail updated.

# biomes 0.9.4

* CRAN resubmission addressing reviewer comments.

# biomes 0.9.3

* Initial CRAN submission.
* Provides raster layers of 31 global biome schemes from Fischer et al.
  (2022, *Global Ecology and Biogeography* 31(11): 2172-2183) at
  10 x 10 km resolution globally.
* Terminology: schemes are addressed by their **biome scheme number**
  (1-31). The `scheme` argument of `biomes_classify()`, `biomes_rank()`,
  `biomes_visualise()` and `biomes_full()` replaces the former `layer`
  argument; `biomes_rank()` returns the columns `scheme`/`scheme_name`
  and the attribute `best_scheme`; `biomes_tab()` returns a `scheme`
  column; `biomes_information` uses the column `scheme_number`.
* Core functions: `biomes_classify()` (assign occurrence records to
  biome classes), `biomes_rank()` (rank schemes by coverage, effective
  number of classes, and granularity), `biomes_tab()` (tabulate records
  per biome class), `biomes_visualise()` (combined figure with `rank`,
  `map` and `barplot` panels, selectable via `panels`), `biomes_full()`
  (one-call wrapper), `biomes_get()` (load the raster stack),
  `biomes_info()` (per-scheme metadata), `biomes_occ()` (optional GBIF
  download with coordinate cleaning).
* `biomes_visualise()` now reproduces the full workflow figure: the
  `rank` panel shows the composite score plus the raw criteria it averages
  (coverage, effective classes, granularity), the `map` panel shows the
  occurrence map (with an adaptive legend), and the `barplot` panel shows
  records and species per biome class back-to-back with centred labels.
  With `combine = FALSE` the individual panels are returned as a named
  list instead of one lettered figure. The former `biomes_show_rank()`
  has been removed (its ranking view is the `rank` panel).
* `biomes_full()`: the `scheme` argument also accepts a scheme type
  (`"climate"`, `"vegetation"`, `"land_cover"`, `"ecoregion"`,
  `"integrative"`, `"anthropogenic"`) to pick the best-fitting scheme
  within that group, in addition to an integer `1:31` and `"best"`. A new
  `plot` argument controls which figure(s) are built: `"none"` (default,
  no figure, the fastest option), `"all"` (the combined lettered figure in
  `$plot`), or a subset of `c("rank", "map", "barplot")` (returned
  individually, without panel letters, in `$rank`, `$map` and `$barplot`).
* The ~36 MB biome raster stack is not bundled inside the package. It
  is hosted as a GitHub release asset and downloaded once into a
  per-user cache directory (`tools::R_user_dir()`) on first use;
  `biomes_download()` performs (or refreshes) this download explicitly.
  This keeps the installed package well under CRAN's size limit.
* Four vignettes follow the four-step workflow (`step1-` .. `step4-`):
  (1) assembling occurrence records and biome schemes, (2) choosing a
  biome scheme, (3) occurrences-to-biome classification, and (4) output
  and visualisation.
