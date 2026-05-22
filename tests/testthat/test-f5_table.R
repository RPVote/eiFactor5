test_that("f5_indicators returns correct structure", {
  ind <- f5_indicators()
  expect_s3_class(ind, "data.frame")
  expect_equal(nrow(ind), 12)
  expect_true(all(c("id", "label", "summary_type", "acs_table") %in% names(ind)))
  expect_equal(ind$summary_type[1], "median")
  expect_true(all(ind$summary_type[-1] == "proportion"))
})

test_that("indicator_meta returns same info as f5_indicators", {
  meta <- eiFactor5:::indicator_meta()
  ind <- f5_indicators()
  expect_equal(meta$id, ind$id)
  expect_equal(meta$label, ind$label)
})

test_that("safe_div handles zero and NA denominators", {
  expect_equal(eiFactor5:::safe_div(10, 2), 5)
  expect_true(is.na(eiFactor5:::safe_div(10, 0)))
  expect_true(is.na(eiFactor5:::safe_div(10, NA)))
  expect_true(is.na(eiFactor5:::safe_div(NA, 5)))
})

test_that("fmt_pct formats correctly", {
  expect_equal(eiFactor5:::fmt_pct(0.5), "50%")
  expect_equal(eiFactor5:::fmt_pct(0.123, digits = 1), "12.3%")
  expect_equal(eiFactor5:::fmt_pct(NA), "NA")
})

test_that("fmt_dollar formats correctly", {
  expect_equal(eiFactor5:::fmt_dollar(50000), "$50,000")
  expect_equal(eiFactor5:::fmt_dollar(NA), "NA")
})

test_that("group_display_name maps correctly", {
  expect_equal(eiFactor5:::group_display_name("white"), "White")
  expect_equal(eiFactor5:::group_display_name("black"), "Black")
  expect_equal(eiFactor5:::group_display_name("hispanic"), "Hispanic")
  expect_equal(eiFactor5:::group_display_name("aapi"), "AAPI")
  expect_equal(eiFactor5:::group_display_name("native"), "Native Am.")
})

test_that("get_acs_vars returns expected variable codes", {
  vars <- eiFactor5:::get_acs_vars(groups = c("white", "black"))
  expect_true(length(vars) > 50)
  expect_true("B01003_001" %in% vars)
  expect_true("B19013H_001" %in% vars)
  expect_true("B19013B_001" %in% vars)
  # AAPI vars should NOT be present
  expect_false("B19013D_001" %in% vars)
})
