#' Download datasets from ICPSR
#'
#' \code{icpsr_download} provides a programmatic and reproducible means to download datasets from the Inter-university Consortium for Political and Social Research 
#'
#' @param file_id The unique identifier (or optionally a vector of these identifiers)
#'  for the dataset(s) to be downloaded (see details).
#' @param email,password Your ICPSR email and password (see details)
#' @param download_dir The directory (relative to your working directory) to
#'   which files from the Pew Research Center will be downloaded.
#' @param msg If TRUE, outputs a message showing which data set is being downloaded.
#' @param unzip If TRUE, the downloaded zip files will be unzipped.
#' @param delete_zip If TRUE, the downloaded zip files will be deleted.
#'
#' @details 
#'  To avoid requiring others to edit your scripts to insert their own email and  
#'  password, the default is set to fetch this information from the user's 
#'  .Rprofile.  Before running \code{icpsr_download}, then, you should be sure to
#'  add these options to your .Rprofile substituting your info for the example below:
#'
#'  \code{
#'   options("icpsr_email" = "juanita-herrara@uppermidwest.edu",
#'          "icpsr_password" = "password123!")
#'  }
#'
#' @return The function returns downloaded files.
#'
#' @examples
#' \dontrun{
#'  icpsr_download(file_id = c(3730, 36138))
#' }
#'
#' @export
icpsr_download <- function(file_id, 
                         email = getOption("icpsr_email"),
                         password = getOption("icpsr_password"),
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
  for (i in seq(file_id)) { 
      item <- file_id[[i]]
      if(msg) message("Downloading ICPSR file: ", item, sprintf(" (%s)", Sys.time()))
      
      # build url
      url <- paste0("http://www.icpsr.umich.edu/cgi-bin/terms?path=ICPSR&study=", item)
      
      # navigate to download page
      remDr$navigate(url)
      
      # agree to terms
      remDr$findElement(using = "name", ".submit")$clickElement()
      
      # log in
      if (i == 1) { 
          Sys.sleep(2)
          remDr$findElement(using = "name", "email")$sendKeysToElement(list(email))
          remDr$findElement(using = "name","password")$sendKeysToElement(list(password))
          remDr$findElement(using = "name", "Log In")$clickElement()         
      }
      
      # check that download has completed
      file_id_name <- item 
      while (nchar(file_id_name) < 5) file_id_name <- paste0("0", file_id_name) # pad out with zeroes as needed
      zip_name <- paste0("ICPSR_", file_id_name, ".zip")
      dd_new <- list.files(download_dir)[!list.files(download_dir) %in% dd_old]
      while (!zip_name %in% dd_new) {
          Sys.sleep(1)
          dd_new <- list.files(download_dir)[!list.files(download_dir) %in% dd_old]          
      }

      # switch back to first window
      remDr$switchToWindow(remDr$getWindowHandles()[[1]])
  }
  
  # Close driver
  remDr$close()
  
  if (unzip == TRUE) {
    lapply(dd_new, function(x) unzip(paste0(download_dir, "/", x), exdir = paste0(download_dir, "/")))
  }
  if (delete_zip == TRUE) {
    invisible(file.remove(paste0(download_dir, "/", dd_new)))
  }
}