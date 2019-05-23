[![CRAN version](http://www.r-pkg.org/badges/version/icpsrdata)](https://cran.r-project.org/package=icpsrdata) ![](http://cranlogs.r-pkg.org/badges/grand-total/icpsrdata) [![Travis-CI Build Status](https://travis-ci.org/fsolt/icpsrdata.svg?branch=master)](https://travis-ci.org/fsolt/icpsrdata)
------------------------------------------------------------------------
icpsrdata
=========

`icpsrdata` is an R package that provides reproducible, programmatic access to datasets stored in the [Inter-university Consortium for Political and Social Research archive](http://www.icpsr.umich.edu).


To install:

* the latest released version: `install.packages("icpsrdata")`
* the latest development version:

```R
if (!require(remotes)) install.packages("remotes")
remotes::install_github("fsolt/icpsrdata")
```

`icpsr_download` also requires the Chrome browser to be installed on your machine.  Get it from <https://www.google.com/chrome/>

For more details, check out [the vignette](https://cran.r-project.org/package=icpsrdata/vignettes/icpsrdata-vignette.html).
