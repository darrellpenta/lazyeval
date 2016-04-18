context("expr")

# expr_find ---------------------------------------------------------------

test_that("doesn't go pass lazy loaded objects", {
  expect_identical(expr_find(mtcars), quote(mtcars))
})

test_that("follows multiple promises", {
  f <- function(x) g(x)
  g <- function(y) h(y)
  h <- function(z) expr_find(z)

  expect_identical(f(x + y), quote(x + y))
})

# expr_text ---------------------------------------------------------------

test_that("always returns single string", {
  out <- expr_text({
    a + b
  })
  expect_length(out, 1)
})


# expr_label --------------------------------------------------------------

test_that("quotes strings", {
  expect_equal(expr_label("a"), '"a"')
  expect_equal(expr_label("\n"), '"\\n"')
})

test_that("backquotes names", {
  expect_equal(expr_label(x), "`x`")
})

test_that("converts atomics to strings", {
  expect_equal(expr_label(0.5), "0.5")
})

test_that("truncates long calls", {
  expect_equal(expr_label({ a + b }), "{\n    ...\n}")
})
