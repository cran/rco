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
#  foo <- function() {
#    val <- rnorm(1)
#    e <- exp(1)
#    val
#    res <- e ^ val
#  }

## -----------------------------------------------------------------------------
code <- paste(
  "foo <- function(n) {",
  "  i <- 0",
  "  res <- 0",
  "  while (i < n) {",
  "    res <- res + i",
  "    i <- i + 1",
  "    res",
  "  }",
  "  res",
  "}",
  "foo(10000)",
  sep = "\n"
)
cat(code)

## -----------------------------------------------------------------------------
opt_code <- opt_dead_expr(list(code))
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
#    x
#    return(8818)
#  }

## ----eval=FALSE---------------------------------------------------------------
#  foo <- function() {
#    return(8818)
#  }

## ----eval=FALSE---------------------------------------------------------------
#  foo()
#  ## Error in foo() : object 'x' not found

