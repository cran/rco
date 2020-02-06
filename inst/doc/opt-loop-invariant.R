## ----echo=FALSE, message=FALSE------------------------------------------------
library("rco")
library("microbenchmark")
library("ggplot2")
autoplot.microbenchmark <- function(obj) {
  levels(obj$expr) <- paste0("Expr_", seq_along(levels(obj$expr)))
  microbenchmark:::autoplot.microbenchmark(obj)
}
speed_up <- function(obj) {
  levels(obj$expr) <- paste0("Expr_", seq_along(levels(obj$expr)))
  obj <- as.data.frame(obj)
  summaries <- do.call(rbind, by(obj$time, obj$expr, summary))
  res <- c()
  for (i in seq_len(nrow(summaries) - 1) + 1) {
    res <- rbind(res, summaries[1, ] / summaries[i, ])
  }
  rownames(res) <- levels(obj$expr)[-1]
  return(res)
}

## ----eval=FALSE---------------------------------------------------------------
#  i <- 0
#  n <- 1000
#  y <- rnorm(1)
#  z <- rnorm(1)
#  a <- c()
#  while (i < n) {
#    x <- y + z
#    a[i] <- 6 * i + x * x
#    i <- i + 1
#  }

## -----------------------------------------------------------------------------
code <- paste(
  "i <- 0",
  "n <- 1000",
  "y <- rnorm(1)",
  "z <- rnorm(1)",
  "a <- c()",
  "while (i < n) {",
  "  x <- y + z",
  "  a[i] <- 6 * i + x * x",
  "  i <- i + 1",
  "}",
  sep = "\n"
)
cat(code)

## -----------------------------------------------------------------------------
opt_code <- opt_loop_invariant(list(code))
cat(opt_code$codes[[1]])

## ----message=FALSE------------------------------------------------------------
bmark_res <- microbenchmark({
  eval(parse(text = code))
}, {
  eval(parse(text = opt_code))
})
autoplot(bmark_res)
speed_up(bmark_res)

## ----eval=FALSE---------------------------------------------------------------
#  while (i < n) {
#    if (n > 3) {
#      something_without_i
#    }
#  }

## ----eval=FALSE---------------------------------------------------------------
#  if (i < n) {
#    if (n > 3) {
#      something_without_i
#    }
#  }
#  while (i < n) {
#  }

## ----eval=FALSE---------------------------------------------------------------
#  while (i < n) {
#    i <- (x * y) + 1
#  }

## ----eval=FALSE---------------------------------------------------------------
#  is_1 <- (x * y)
#  while (i < n) {
#    i <- is_1 + 1
#  }

## ----eval=FALSE---------------------------------------------------------------
#  y <- 1
#  repeat{
#    if (y > 4) {
#      break
#    }
#    x <- 8 * 8
#    y <- y + 1
#  }

## ----eval=FALSE---------------------------------------------------------------
#  y <- 1
#  if (y <= 4) {
#    x <- 8 * 8
#  }
#  repeat{
#    if (y > 4) {
#      break
#    }
#    y <- y + 1
#  }

