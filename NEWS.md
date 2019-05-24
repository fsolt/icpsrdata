## Version 0.4.0
1. Update for revisions to ICPSR website
1. Allows email and password to be stored in `.Renviron` for those with a strong preference for keeping account information there.  Saving login information in `.Rprofile` still works as before.

## Version 0.3.0
Provides better default for `delete_zip` argument; corrects documentation.

## Version 0.2.0
1. User-facing revisions
    + Allows, if the needed login information has not been saved in the user's `.Rprofile`, for this information to be entered interactively; the information is then saved for the duration of the current session
    + Permits users to reset any login information saved for the current session by switching the argument `reset` to `TRUE`
    + No longer depends on the Firefox browser
1. Internal revisions
    + Uses `rvest` rather than `RSelenium` to navigate the ICPSR download process
    + Uses `purrr::walk` rather than a `for` loop to iterate over multiple file requests

## Version 0.1.1
Allows nested directories to be automatically created if necessary when specified using the `download_dir` argument

## Version 0.1.0
First release.
