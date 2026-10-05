## Update to version 0.9.5

This is an update of the package currently on CRAN (0.9.4). The package
accompanies a manuscript that is now available as a preprint, and this
release aligns the package with the terminology, the worked example and
the figure of that manuscript. The main changes (see NEWS.md for the
full list):

* Maintainer e-mail address: the maintainer started a new position. The
  address changed from `hc.gross@gmx.de` (CRAN 0.9.4) to
  `grossha@uni-marburg.de`. The maintainer is the same person (Hans
  Christian Groß); the old address is still active for the confirmation
  e-mail.
* Terminology: the package now uses one consistent vocabulary, matching
  the manuscript. A "biome scheme" is one of the 31 classification
  systems, a "biome" is a category within a scheme (formerly "biome
  class"), and a "biome definition" is the concept a scheme is based on
  (climate, vegetation, land_cover, ecoregion, integrative,
  anthropogenic; formerly "scheme type"). Accordingly, the argument
  `scheme_type` of `biomes_rank()` and `biomes_visualise()` is now
  `definition`; the ranking criterion `effective_classes` is now
  `effective_biomes` and `tiebreaker = "classes"` is now `"biomes"`;
  and `biomes_information` has the columns `biome_definition`,
  `number_of_biomes_zonal_azonal` and `criteria_for_biome_assignment`
  (formerly `scheme_type`, `number_of_classes_zonal_azonal`,
  `criteria_for_class_assignment`). Two vignettes were renamed to
  match the four workflow steps of the manuscript.
* Example data: the previous example dataset `biomes_example` has been
  removed and replaced by `bombacoideae_occurrences`, the worked example
  of the manuscript (17,030 occurrence records of 185 Bombacoideae
  species from Zizka et al. 2020). It is used in the README, the
  vignettes and all function examples.
* Ranking: `biomes_rank()` uses exactly the three criteria of the
  manuscript (`coverage`, `effective_biomes`, `granularity`), min-max
  rescaled and averaged with equal weights. The experimental criteria
  `evenness`, `informativeness` and `agreement` and the `scaling`
  argument have been removed.
* Figure: `biomes_visualise()` and `biomes_full(plot = )` now reproduce
  the workflow figure of the manuscript (rank, map and barplot panels;
  new arguments `top_n` and `titles`; `legend_counts` defaults to
  `FALSE`).
* Citation: `inst/CITATION` and the README now cite the preprint
  (Groß, Fischer, Walentowitz & Zizka 2026, bioRxiv,
  <https://doi.org/10.64898/2026.09.25.754345>).

All changes are documented in NEWS.md.

## R CMD check results

Local check: 0 errors | 0 warnings | 0 notes
(Windows 11 x64, R 4.6.0, `devtools::check()`).

win-builder check: 0 errors | 0 warnings | 1 note
(R-release and R-devel).

NOTE: checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Hans Christian Groß <grossha@uni-marburg.de>'

  New maintainer:
    Hans Christian Groß <grossha@uni-marburg.de>
  Old maintainer(s):
    Hans Christian Groß <hc.gross@gmx.de>

* The "New maintainer" note reflects the change of e-mail address
  described above; the maintainer is unchanged.
* The word "Reproducibly" (Description) may be flagged as possibly
  misspelled. It is a correctly spelled English adverb; this is a false
  positive.

## Test environments

- local: Windows 11 x64, R 4.6.0 (`devtools::check()`)
- win-builder: Windows Server 2022, R-release
- win-builder: Windows Server 2022, R-devel
