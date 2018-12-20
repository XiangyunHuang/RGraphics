if(identical(.Platform$OS.type, "windows")){
  # rstan
  dotR <- file.path(Sys.getenv("HOME"), ".R")
  if (!file.exists(dotR)) dir.create(dotR)
  M <- file.path(dotR, "Makevars.win")
  if (!file.exists(M)) {
    file.create(M)
    cat("\nCXX14FLAGS = -O3 -march=native -mtune=native -fPIC",
        "CXX14 = $(BINPREF)g++ -O2 -march=native -mtune=native",
        file = M, sep = "\n", append = TRUE)
  }
  rm(list = c("dotR", "M"))
  Sys.setenv(BINPREF = "C:/Rtools/mingw_$(WIN)/bin/")
}

options(
  dplyr.print_min = 6, 
  dplyr.print_max = 6,
  citation.bibtex.max = 999,
  bitmapType = "cairo",
  reprex.styler = TRUE,
  stringsAsFactors = FALSE,
  knitr.graphics.auto_pdf = FALSE,
  tidyverse.quiet = TRUE,
  tidymodels.quiet = TRUE,
  memory.profiling = TRUE,
  width = 79,
  str = utils::strOptions(strict.width = "cut")
)
