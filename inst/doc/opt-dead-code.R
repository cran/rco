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
#    a <- 24
#    if (a > 25) {
#      return(25)
#      a <- 25 # dead code
#    }
#    return(a)
#    b <- 24 # dead code
#    return(b) # dead code
#  }

## ----eval=FALSE---------------------------------------------------------------
#  foo <- function() {
#    a <- 24
#    if (a > 25) {
#      return(25)
#    }
#    return(a)
#  }

## ----eval=FALSE---------------------------------------------------------------
#  foo <- function() {
#    a <- 24
#    if (FALSE) { # dead code
#      return(25) # dead code
#    } # dead code
#    return(a)
#  }

## ----eval=FALSE---------------------------------------------------------------
#  foo <- function() {
#    a <- 24
#    return(a)
#  }

## -----------------------------------------------------------------------------
code <- paste(
  "i <- 0",
  "n <- 1000",
  "while (i < n) {",
  "  if (TRUE) {",
  "    i <- i + 1",
  "  } else {",
  "    i <- i - 1",
  "  }",
  "}",
  sep = "\n"
)
cat(code)

## -----------------------------------------------------------------------------
opt_code <- opt_dead_code(list(code))
cat(opt_code$codes[[1]])

## ----message=FALSE------------------------------------------------------------
bmark_res <- microbenchmark({
  eval(parse(text = code))
}, {
  eval(parse(text = opt_code))
})
autoplot(bmark_res)
speed_up(bmark_res)

