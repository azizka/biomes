test_that("biomer_compare (input = x) returns valid summary list", {
  df <- data.frame(
    decimalLongitude = c(-60.1, -60.2),
    decimalLatitude  = c(-3.2,  -3.3),
    species          = c("spA", "spA")
  )

  res <- biomer_compare(
    x = df,
    lon = "decimalLongitude",
    lat = "decimalLatitude",
    layer = 1
  )

  expect_true(is.list(res))
  expect_true("biomer_GBIF_data" %in% names(res))
  expect_true("biomer_taxon_summary" %in% names(res) | "layer_1" %in% names(res))

  res_multi <- biomer_compare(
    x = df,
    lon = "decimalLongitude",
    lat = "decimalLatitude",
    layer = c(1, 2)
  )
  expect_true("layer_1" %in% names(res_multi))
  expect_true("layer_2" %in% names(res_multi))
  expect_true("biomer_GBIF_data" %in% names(res_multi))
  expect_s3_class(res_multi$biomer_GBIF_data, "data.frame")
})

test_that("biomer_compare (input = taxon) returns valid summary list", {

  res <- biomer_compare(
    taxon = "Talpa europaea",
    lon = "decimalLongitude",
    lat = "decimalLatitude",
    layer = 1,
    limit = 10
  )

  skip_if(is.null(res), "GBIF query returned NULL (potentially no internet in test)")

  expect_true(is.list(res))
  expect_true("biomer_GBIF_data" %in% names(res))
  expect_true("biomer_taxon_summary" %in% names(res) | "layer_1" %in% names(res))
  expect_s3_class(res$biomer_GBIF_data, "data.frame")
})
