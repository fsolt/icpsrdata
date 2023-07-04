## ----eval = FALSE-------------------------------------------------------------
#  options("icpsr_email" = "juanita-herrera@uppermidwest.edu",
#          "icpsr_password" = "password123!")

## ----eval=FALSE---------------------------------------------------------------
#  icpsr_download(file_id = 36138,
#                 download_dir = tempdir()) # remember to specify a directory for your download

## ----eval=FALSE---------------------------------------------------------------
#  icpsr_download(file_id = c(34715, 34973, 36138),
#                 download_dir = tempdir()) # remember to specify a directory for your download

