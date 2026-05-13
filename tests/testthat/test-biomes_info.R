test_that("biomes_info invisibly returns the indices it printed", {
  out <- NULL
  utils::capture.output(out <- biomes_info(c(1, 5)))
  expect_equal(out, c(1, 5))
})

test_that("biomes_info defaults to all 31 layers", {
  out <- NULL
  utils::capture.output(out <- biomes_info())
  expect_equal(out, 1:31)
})

test_that("biomes_info validates the input range", {
  expect_error(biomes_info(0),  "x")
  expect_error(biomes_info(32), "x")
})
