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

## -----------------------------------------------------------------------------
code <- paste(
  "hours_vector <- runif(1000, 0, 24)",
  "ms_vector <- numeric(1000)",
  "# of course it would be much efficient to do vectorized operations xP",
  "for (i in seq_along(hours_vector)) {",
  "  ms_vector[i] <- 1000 * 60 * 60 * hours_vector[i]",
  "}",
  sep = "\n"
)
cat(code)

## -----------------------------------------------------------------------------
opt_code <- opt_constant_folding(list(code))
cat(opt_code$codes[[1]])

## ----message=FALSE------------------------------------------------------------
bmark_res <- microbenchmark({
  eval(parse(text = code))
}, {
  eval(parse(text = opt_code))
})
autoplot(bmark_res)
speed_up(bmark_res)

## ----echo=FALSE---------------------------------------------------------------
rco:::ops
rco:::constants
rco:::precedence_ops

## -----------------------------------------------------------------------------
x <- 1 / (2 + 1)
y <- 1 / (2 + 1)
z <- 1 / (2 + 1)
x + y + z == 1

## -----------------------------------------------------------------------------
code <- paste(
  "x <- 1/(2+1)",
  "y <- 1/(2+1)",
  "z <- 1/(2+1)",
  "x + y + z == 1",
  sep = "\n"
)
opt_code <- opt_constant_folding(list(code), fold_floats = TRUE)$codes[[1]]
cat(opt_code)

## -----------------------------------------------------------------------------
eval(parse(text = code))

## -----------------------------------------------------------------------------
eval(parse(text = opt_code))

## -----------------------------------------------------------------------------
opt_code <- opt_constant_folding(list(code), fold_floats = FALSE)$codes[[1]]
cat(opt_code)

## -----------------------------------------------------------------------------
opt_code <- opt_constant_folding(list(paste(
  "x <- 1/(2+1)", # will not fold it because we lose precision
  "y <- 1/(2+1) > 3", # however, folded or not, it is not > 3, so folds it
  sep = "\n"
)), fold_floats = FALSE)$codes[[1]]
cat(opt_code)

