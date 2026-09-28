test_that(".minmax rescales to [0, 1] and drops constant criteria", {
  expect_equal(biomes:::.minmax(c(0, 2, 4)), c(0, 0.5, 1))
  expect_true(all(is.na(biomes:::.minmax(c(3, 3, 3)))))
  expect_equal(biomes:::.minmax(c(1, NA, 3)), c(0, NA, 1))
})

test_that("a single compared scheme has no composite score but is best", {
  skip_if_no_raster()
  data("bombacoideae_occurrences")
  occ <- bombacoideae_occurrences[seq(1, nrow(bombacoideae_occurrences), by = 20), ]
  r <- suppressMessages(suppressWarnings(
    biomes_rank(occ, scheme = 25, verbose = FALSE)
  ))
  expect_equal(nrow(r), 1L)
  expect_true(is.na(r$composite_score))
  expect_true(r$is_best)
  expect_equal(r$rank, 1L)
  expect_equal(attr(r, "best_scheme"), 25L)
  expect_length(attr(r, "criteria_used"), 0)
})

test_that("minmax scaling maps the extremes of two schemes to 0 and 1", {
  skip_if_no_raster()
  data("bombacoideae_occurrences")
  occ <- bombacoideae_occurrences[seq(1, nrow(bombacoideae_occurrences), by = 20), ]
  r <- suppressMessages(suppressWarnings(
    biomes_rank(occ, scheme = c(9, 25), verbose = FALSE)
  ))
  expect_equal(sort(r$coverage_scaled), c(0, 1))
  expect_equal(attr(r, "criteria_used"),
               c("coverage", "effective_biomes", "granularity"))
  expect_true(all(r$composite_score >= 0 & r$composite_score <= 1))
})

test_that("only the three documented criteria are accepted", {
  data("bombacoideae_occurrences")
  expect_error(
    biomes_rank(bombacoideae_occurrences, criteria = "evenness", verbose = FALSE),
    "criteria"
  )
})
