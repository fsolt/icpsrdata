<!-- badges: start -->
[![CRAN version](https://www.r-pkg.org/badges/version/icpsrdata)](https://cran.r-project.org/package=icpsrdata) ![](https://cranlogs.r-pkg.org/badges/grand-total/icpsrdata)
[![R-CMD-check](https://github.com/fsolt/icpsrdata/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/fsolt/icpsrdata/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

------------------------------------------------------------------------
icpsrdata
=========

`icpsrdata` is an R package that provides reproducible, programmatic access to datasets stored in the Inter-university Consortium for Political and Social Research archive.

To install:

* the latest released version: `install.packages("icpsrdata")`
* the latest development version:

```R
if (!require(remotes)) install.packages("remotes")
remotes::install_github("fsolt/icpsrdata")
```

The Inter-university Consortium for Political and Social Research, in its own words, "provides leadership and training in data access, curation, and methods of analysis for the social science research community."
The ICPSR data archive stores thousands of datasets on a wide range of topics. Researchers taking advantage of these datasets, however, are caught in a bind.
The terms and conditions for downloading any ICPSR dataset state that one agrees "not to redistribute data or other materials without the written agreement of ICPSR."
But to ensure that one's work can be reproduced, assessed, and built upon by others, one must provide access to the raw data one employed.
The `icpsrdata` package cuts this knot by providing programmatic, reproducible access to ICPSR's datasets from within R.

For more details, check out [the vignette](https://fsolt.org/icpsrdata/articles/icpsrdata-vignette.html).
