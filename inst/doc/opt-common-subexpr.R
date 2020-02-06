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
#  a <- 1 / (8 + 8 + 1 + 9 * 1 ^ 8)
#  b <- (8 + 8 + 1 + 9 * 1 ^ 8) * 2

## ----eval=FALSE---------------------------------------------------------------
#  cs_1 <- (8 + 8 + 1 + 9 * 1 ^ 8)
#  a <-  1 / cs_1
#  b <- cs_1 * 2

## -----------------------------------------------------------------------------
code <- paste(
  "a <- b <- c <- 1",
  "for (i in 1:1000) {",
  "  a <- a ^ i ^ c",
  "  b <- b * i ^ c",
  "  c <- c + i ^ c",
  "}",
  sep = "\n"
)
cat(code)

## -----------------------------------------------------------------------------
opt_code <- opt_common_subexpr(list(code))
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
#  a <-rnorm(1) * 8
#  b <-rnorm(1) * 18

## ----eval=FALSE---------------------------------------------------------------
#  cs_1 <- rnorm(1)
#  a <-cs_1 * 8
#  b <-cs_1 * 18

