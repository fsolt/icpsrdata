#' Download datasets from ICPSR
#'
#' \code{icpsr_download} provides a programmatic and reproducible means to download datasets from the Inter-university Consortium for Political and Social Research 
#'
#' @param file_id The unique identifier (or optionally a vector of these identifiers)
#'  for the dataset(s) to be downloaded (see details).
#' @param email,password Your ICPSR email and password (see details)
#' @param reset If TRUE, you will be asked to re-enter your ICPSR email and password.
#' @param download_dir The directory (relative to your working directory) to
#'   which files from the ICPSR will be downloaded.
#' @param msg If TRUE, outputs a message showing which data set is being downloaded.
#' @param delay If the speed of your connection to ICPSR is particularly slow, 
#'   \code{icpsr_download} may encounter problems.  Increasing the \code{delay} parameter
#'   may help.
#'
#' @details 
#'  \code{icpsr_download} requires the Chrome browser to be installed on your machine.  
#'  Get it from https://www.google.com/chrome/
#' 
#'  To avoid requiring others to edit your scripts to insert their own email and  
#'  password or to force them to do so interactively, the default is set to fetch 
#'  this information from the user's .Rprofile.  Before running \code{icpsr_download}, 
#'  then, you should be sure to add these options to your .Rprofile substituting your 
#'  info for the example below:
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
#' @import RSelenium
#' @importFrom purrr walk
#' @importFrom stringr str_detect
#' 
#' @export
icpsr_download <- function(file_id, 
                           email = getOption("icpsr_email"),
                           password = getOption("icpsr_password"),
                           reset = FALSE,
                           download_dir = "icpsr_data",
                           msg = TRUE,
                           delay = 2) {
    
    # Detect login info
    if (reset) {
        email <- password <- NULL
    }
    
    if (is.null(email)) {
        icpsr_email <- readline(prompt = "ICPSR requires your user account information.  Please enter your email address: \n")
        options("icpsr_email" = icpsr_email)
        email <- getOption("icpsr_email")
    }
    
    if (is.null(password)) {
        icpsr_password <- readline(prompt = "Please enter your ICPSR password: \n")
        options("icpsr_password" = icpsr_password)
        password <- getOption("icpsr_password")
    }
    
    # build path to chrome's default download directory
    if (Sys.info()[["sysname"]]=="Linux") {
        default_dir <- file.path("home", Sys.info()[["user"]], "Downloads")
    } else {
        default_dir <- file.path("", "Users", Sys.info()[["user"]], "Downloads")
    }
    
    # create specified download directory if necessary
    if (!dir.exists(download_dir)) dir.create(download_dir, recursive = TRUE)
    
    # initialize driver
    if(msg) message("Initializing RSelenium driver")
    rD <- RSelenium::rsDriver(browser = "chrome")
    remDr <- rD[["client"]]
    
    login_page <- "https://www.icpsr.umich.edu/rpxlogin?path=ICPSR&request_uri=https%3a%2f%2fwww.icpsr.umich.edu%2ficpsrweb%2findex.jsp"
    remDr$navigate(login_page)
    remDr$findElement(using = "name", "email")$sendKeysToElement(list(email))
    remDr$findElement(using = "name", "password")$sendKeysToElement(list(password))
    remDr$findElement(using = "name", "Log In")$clickElement()
    Sys.sleep(delay)
    
    # Loop through files
    purrr::walk(file_id, function(item) {
        # show process
        if(msg) message("Downloading ICPSR file: ", item, sprintf(" (%s)", Sys.time()))
        
        # get list of current default download directory contents
        dd_old <- list.files(default_dir)
        
        # navigate to download page  
        url <- paste0("http://www.icpsr.umich.edu/cgi-bin/bob/zipcart2?path=ICPSR&study=", item, "&bundle=all&ds=&dups=yes")
        remDr$navigate(url)
        Sys.sleep(delay)
        
        # agree to terms
        remDr$findElement(using = "name", ".submit")$clickElement()

        # check that download has completed
        dd_new <- list.files(default_dir)[!list.files(default_dir) %in% dd_old]
        wait <- TRUE
        tryCatch(
            while(all.equal(stringr::str_detect(dd_new, "\\.part$"), logical(0))) {
                Sys.sleep(1)
                dd_new <- list.files(default_dir)[!list.files(default_dir) %in% dd_old]
            }, error = function(e) 1 )
        while(any(stringr::str_detect(dd_new, "\\.crdownload$"))) {
            Sys.sleep(1)
            dd_new <- list.files(default_dir)[!list.files(default_dir) %in% dd_old]
        }
        
        # unzip into specified directory
        unzip(file.path(default_dir, dd_new), exdir = file.path(download_dir))
        unlink(file.path(default_dir, dd_new))
    })
    
    # Close driver
    remDr$close()
    rD[["server"]]$stop()
}
