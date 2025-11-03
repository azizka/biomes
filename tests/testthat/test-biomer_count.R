test_that("biomer_count returns correct list structure for single and multiple layers", {
  df <- data.frame(
    decimalLongitude = c(-60.1, -60.2, -60.3),
    decimalLatitude  = c(-3.2, -3.3, -3.4),
    species          = c("spA", "spA", "spB")
  )


  res1 <- biomer_count(
    x = df,
    group_col = "species",
    lon = "decimalLongitude",
    lat = "decimalLatitude",
    layer = 1
  )
  expect_true(is.list(res1))
  expect_true(all(c("biomer_taxon_summary", "counts_per_biome") %in% names(res1)))
  expect_s3_class(res1$biomer_taxon_summary, "data.frame")
  expect_s3_class(res1$counts_per_biome, "data.frame")

  res_multi <- biomer_count(
    x = df,
    group_col = "species",
    lon = "decimalLongitude",
    lat = "decimalLatitude",
    layer = c(1, 2)
  )
  expect_true(is.list(res_multi))
  expect_true(all(c("biomer_taxon_summary", "counts_per_biome") %in% names(res_multi)))
  expect_true(all(grepl("^layer_", names(res_multi$biomer_taxon_summary))))
  expect_true(all(grepl("^layer_", names(res_multi$counts_per_biome))))
  expect_s3_class(res_multi$biomer_taxon_summary[["layer_1"]], "data.frame")
  expect_s3_class(res_multi$counts_per_biome[["layer_1"]], "data.frame")
})

test_that("biomer_count handles errors on malformed input", {

  expect_error(biomer_count(x = NULL), "must be a data.frame")

  df <- data.frame(x = 1:3, y = 1:3)
  expect_error(biomer_count(x = df, group_col = "species", lon = "decimalLongitude", lat = "decimalLatitude", layer = 1), "not found")
})
