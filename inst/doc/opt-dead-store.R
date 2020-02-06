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
#  foo <- function(x) {
#    i <- 8818
#    return(x ^ 3)
#  }

## ----eval=FALSE---------------------------------------------------------------
#  foo <- function(x) {
#    8818 # this line can be removed by Dead Expression Elimination
#    return(x ^ 3)
#  }

## ----eval=FALSE---------------------------------------------------------------
#  foo <- function(x) {
#    i <- 0
#    n <- 8818
#    res <- 0
#    while (i < n) {
#      res <- res + i
#      i <- i + 1
#    }
#    return(res)
#  }

## ----eval=FALSE---------------------------------------------------------------
#  foo <- function(x) {
#    i <- 0
#    n <- 8818
#    res <- 0
#    while (i < 8818) {
#      res <- res + i
#      i <- i + 1
#    }
#    return(res)
#  }

## -----------------------------------------------------------------------------
code <- paste(
  "foo <- function(n) {",
  "  i <- 0",
  "  res <- 0",
  "  while (i < n) {",
  "    res <- res + i",
  "    i <- i + 1",
  "    a <- i + 1",
  "  }",
  "  res",
  "}",
  "foo(10000)",
  sep = "\n"
)
cat(code)

## -----------------------------------------------------------------------------
opt_code <- opt_dead_store(list(code))
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
#  foo <- function() {
#    a <- 8
#    a <- 8818
#    return(a ^ 2)
#  }

## ----eval=FALSE---------------------------------------------------------------
#  foo <- function() {
#    8
#    a <- 8818
#    return(a ^ 2)
#  }

## ----eval=FALSE---------------------------------------------------------------
#  foo <- function() {
#    a <- 8818
#    b <- 0
#    c <- 1000
#    res <- 0
#    for (b < c) {
#      b <- b + 1
#      res <- res + b
#    }
#    return(a ^ 2)
#  }

## ----eval=FALSE---------------------------------------------------------------
#  foo <- function() {
#    a <- 8818
#    return(a ^ 2)
#  }

