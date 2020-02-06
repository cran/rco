## ----eval=FALSE---------------------------------------------------------------
#  texts <- list(
#    paste(
#      "i <- 320 * 200 * 32",
#      "x <- i * 20 + 100",
#      sep = "\n"
#    )
#  )

## ----eval=FALSE---------------------------------------------------------------
#  #' Optimizer: **New Optimizer Name**
#  #'
#  #' **New optimizer description**
#  #' Carefully examine the results after running this function!
#  #'
#  #' @param texts A list of character vectors with the code to optimize.
#  #' **Other parameters description**
#  #'
#  #' @examples
#  #' **New optimizer example of use**
#  #'
#  #' @export
#  #'
#  opt_**optimizer_name** <- function(texts) {
#    # todo: **list of possible improvements for the optimizer**
#    res <- list()
#    **new optimizer code**
#    res$codes <- **...**
#    return(res)
#  }

## ----eval=FALSE---------------------------------------------------------------
#  context("opt_**optimizer_name**")
#  
#  test_that("**test name**", {
#    **...**
#  })
#  
#  **more test cases**

## ----eval=FALSE---------------------------------------------------------------
#  ---
#  output: rmarkdown::html_vignette
#  title: **New Optimizer Name**
#  vignette: >
#    %\VignetteIndexEntry{**New Optimizer Name**}
#    %\VignetteEngine{knitr::rmarkdown}
#    %\VignetteEncoding{UTF-8}
#  ---
#  
#  # **New Optimizer Name**
#  
#  ## Background
#  
#  ## Example
#  
#  ## Implementation
#  
#  ## **Additional headings** (optional)
#  
#  ## To-Do (optional)

## ----eval=FALSE---------------------------------------------------------------
#  # rco **x.y.(z+1)**
#  
#    - Adding **New Optimizer Name** optimizer.
#  
#  **...**

