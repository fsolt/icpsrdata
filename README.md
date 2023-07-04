[![CRAN version](https://www.r-pkg.org/badges/version/icpsrdata)](https://cran.r-project.org/package=icpsrdata) ![](https://cranlogs.r-pkg.org/badges/grand-total/icpsrdata)
------------------------------------------------------------------------
icpsrdata
=========

`icpsrdata` is an R package that provides reproducible, programmatic access to datasets stored in the [Inter-university Consortium for Political and Social Research archive](https://www.icpsr.umich.edu/web/pages/).

To install:

* the latest released version: `install.packages("icpsrdata")`
* the latest development version:

```R
if (!require(remotes)) install.packages("remotes")
remotes::install_github("fsolt/icpsrdata")
```

The Inter-university Consortium for Political and Social Research, [in its own words,](https://www.icpsr.umich.edu/web/pages/about/) "provides leadership and training in data access, curation, and methods of analysis for the social science research community."
The ICPSR data archive stores thousands of datasets on a wide range of topics. Researchers taking advantage of these datasets, however, are caught in a bind.
The terms and conditions for downloading any ICPSR dataset state that one agrees "not to redistribute data or other materials without the written agreement of ICPSR."
But to ensure that one's work can be reproduced, assessed, and built upon by others, one must provide access to the raw data one employed.
The `icpsrdata` package cuts this knot by providing programmatic, reproducible access to ICPSR's datasets from within R.

For more details, check out [the vignette](https://fsolt.org/icpsrdata/articles/icpsrdata-vignette.html).
