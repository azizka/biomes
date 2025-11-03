test_that("biomer_plot returns valid output for single and multiple layers", {
  df <- data.frame(
    decimalLongitude = c(-60.1, -60.2, -60.3),
    decimalLatitude  = c(-3.2, -3.3, -3.4),
    species          = c("spA", "spA", "spB")
  )

  out1 <- biomer_plot(
    x = df,
    lon = "decimalLongitude",
    lat = "decimalLatitude",
    plot_type = "both",
    layer = 1,
    save_path = NULL,
    show_plot = FALSE
  )

  expect_true(is.list(out1))
  expect_true("mapplot" %in% names(out1))
  expect_true("barplot" %in% names(out1))
  expect_true("layer_1" %in% names(out1$mapplot))
  expect_true("layer_1" %in% names(out1$barplot))

  out2 <- biomer_plot(
    x = df,
    lon = "decimalLongitude",
    lat = "decimalLatitude",
    plot_type = "both",
    layer = c(1, 2),
    save_path = NULL,
    show_plot = FALSE
  )

  expect_true("layer_2" %in% names(out2$mapplot))
  expect_true("layer_2" %in% names(out2$barplot))
  expect_true(length(out2$mapplot) == 2)
  expect_true(length(out2$barplot) == 2)
})

test_that("biomer_plot errors gracefully on malformed input", {
  expect_error(biomer_plot(x = NULL), "must be a data.frame")
  bad_df <- data.frame(x = 1:3, y = 1:3)
  expect_error(biomer_plot(x = bad_df, lon = "foo", lat = "bar"), "Column `foo` not found")
})
