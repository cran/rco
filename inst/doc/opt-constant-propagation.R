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
#  x <- 14
#  y <- 7 - x / 2
#  z <- y * (28 / x + 2) - x

## ----eval=FALSE---------------------------------------------------------------
#  x <- 14
#  y <- 7 - 14 / 2
#  z <- y * (28 / 14 + 2) - 14

## -----------------------------------------------------------------------------
code <- paste(
  "n <- 1000",
  "hours_vector <- runif(n, 0, 24)",
  "ms_vector <- numeric(n)",
  "hs_to_mins <- 60",
  "mins_to_secs <- 60",
  "secs_to_ms <- 1000",
  "# of course it would be much efficient to do vectorized operations xP",
  "for (i in 1:n) {",
  "  ms_vector[i] <- secs_to_ms * mins_to_secs * hs_to_mins * hours_vector[i]",
  "}",
  sep = "\n"
)
cat(code)

## -----------------------------------------------------------------------------
opt_code <- opt_constant_propagation(list(code))
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
#  x <- 3
#  y <- 1 + 1
#  while (y < 5) {
#    y <- x
#    x <- x + 1
#  }

## ----eval=FALSE---------------------------------------------------------------
#  x <- 3
#  y <- 1 + 1
#  while (y < 5) {
#    y <- 3
#    x <- 3 + 1
#  }

## ----eval=FALSE---------------------------------------------------------------
#  x <- 1
#  assign("x", 3)
#  y <- x

## ----eval=FALSE---------------------------------------------------------------
#  x <- 1
#  assign("x", 3)
#  y <- 1

## ----eval=FALSE---------------------------------------------------------------
#  rm_all <- function() {
#  env <- .GlobalEnv
#  rm(list = ls(envir = env), envir = env)
#  }

## ----eval=FALSE---------------------------------------------------------------
#  # o @edits_env rm_all
#  ...

## ----eval=FALSE---------------------------------------------------------------
#  rm_all() # o @edits_env

## ----eval=FALSE---------------------------------------------------------------
#  opt_constant_propagation(list(code), env_edit = c("rm_all", ...))

