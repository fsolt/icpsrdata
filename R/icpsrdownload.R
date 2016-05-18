#' Download datasets from ICPSR at University of Michigan
#'
#' \code{icpsr_download} provides a programmatic and reproducible means to download survey datasets from the Pew Research Center 
#'
#' @param file_id The unique identifier (or optionally a vector of these identifiers)
#'  for the dataset(s) to be downloaded (see details).
#' @param user email and password to submit to Pew Research Center (see details)
#' @param download_dir The directory (relative to your working directory) to
#'   which files from the Pew Research Center will be downloaded.
#' @param msg If TRUE, outputs a message showing which data set is being downloaded.
#' @param unzip If TRUE, the downloaded zip files will be unzipped.
#' @param delete_zip If TRUE, the downloaded zip files will be deleted.
#'
#' @details 
#'  To avoid requiring others to edit your scripts to insert their own contact 
#'  information, the default is set to fetch this information from the user's 
#'  .Rprofile.  Before running \code{icpsr_download}, then, you should be sure to
#'  add these options to your .Rprofile substituting your info for the example below:
#'
#'  \code{
#'   options("icpsr_email" = "juanita-herrara@uiowa.edu",
#'          "icpsr_pass" = "password123!")
#'  }
#'
#' @return The function returns downloaded files.
#'
#' @examples
#' \dontrun{
#'  icpsr_download(file_id = c(35119, 34348))
#' }
#'
#' @export
icpsr_download <- function(file_id, 
                         email = getOption("icpsr_email"),
                         pass = getOption("icpsr_pass"),
                         download_dir = "icpsr_data",
                         msg = TRUE,
                         unzip = TRUE,
                         delete_zip = TRUE) {
  
  # Set Firefox properties to not open a download dialog
  fprof <- RSelenium::makeFirefoxProfile(list(
    browser.download.dir = paste0(getwd(), "/", download_dir),
    browser.download.folderList = 2L,
    browser.download.manager.showWhenStarting = FALSE,
    browser.helperApps.neverAsk.saveToDisk = "application/zip"))
  
  # Set up server as open initial window
  RSelenium::checkForServer()
  RSelenium::startServer()
  remDr <- RSelenium::remoteDriver(extraCapabilities = fprof)
  remDr$open(silent = TRUE)
  
  # Get list of current download directory contents
  if (!dir.exists(download_dir)) dir.create(download_dir)
  dd_old <- list.files(download_dir)
  
  # Loop through files
  for (item in file_id) {  
    if(msg) message("Downloading ICPSR file: ", item, sprintf(" (%s)", Sys.time()))
    
    # build url
  url <- paste0("http://www.icpsr.umich.edu/cgi-bin/terms?path=ICPSR&study=", item, "&
bundle=all&ds=1&dups=yes")
    
  
  ####### DOWN BELOW HERE #######
  ### order of ops: navigate to download page, click ###
  ### "I agree" button, provide credentials, click   ###  
  ### "Submit" button                                ###
  
    # navigate to download page and fill in required contact information
    remDr$navigate(url)

    remDr$findElement(using = "name", ".submit")$clickElement()
      
    remDr$findElement(using = "name", "email")$sendKeysToElement(list(email))
    remDr$findElement(using = "name","password")$sendKeysToElement(list(pass))
    remDr$findElement(using = "name", "Log In")$clickElement()    
  
    
    # Switch back to first window
    remDr$switchToWindow(remDr$getWindowHandles()[[1]])
  }
  
  # Confirm that downloads are completed, then close driver
  dd_new <- list.files(download_dir)[!list.files(download_dir) %in% dd_old]
  while (any(grepl("\\.zip\\.part", dd_new))) {
    Sys.sleep(1)
    dd_new <- list.files(download_dir)[!list.files(download_dir) %in% dd_old]
  }
  remDr$close()
  
  if (unzip == TRUE) {
    lapply(dd_new, function(x) unzip(paste0(download_dir, "/", x), exdir = paste0(download_dir, "/")))
  }
  if (delete_zip == TRUE) {
    invisible(file.remove(paste0(download_dir, "/", dd_new)))
  }
}