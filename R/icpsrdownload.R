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
#' @param unzip If TRUE, the downloaded zip files will be unzipped.
#' @param delete_zip If TRUE, the downloaded zip files will be deleted.
#'
#' @details 
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
#' @importFrom rvest html_session html_form set_values submit_form jump_to follow_link
#' @importFrom purrr walk "%>%"
#' @importFrom httr content
#' 
#' @export
icpsr_download <- function(file_id, 
                           email = getOption("icpsr_email"),
                           password = getOption("icpsr_password"),
                           reset = FALSE,
                           download_dir = "icpsr_data",
                           msg = TRUE,
                           unzip = TRUE,
                           delete_zip = unzip) {
    
    # Detect login info
    if (reset){
        email <- password <- NULL
    }
    
    if (is.null(email)){
        icpsr_email <- readline(prompt = "ICPSR requires your user account information.  Please enter your email address: \n")
        options("icpsr_email" = icpsr_email)
        email <- getOption("icpsr_email")
    }
    
    if (is.null(password)){
        icpsr_password <- readline(prompt = "Please enter your ICPSR password: \n")
        options("icpsr_password" = icpsr_password)
        password <- getOption("icpsr_password")
    }
    
    # Get list of current download directory contents
    if (!dir.exists(download_dir)) dir.create(download_dir, recursive = TRUE)
    dd_old <- list.files(download_dir)
    
    # Loop through files
    file_id %>% walk(function(item) {
        # show process
        if(msg) message("Downloading ICPSR file: ", item, sprintf(" (%s)", Sys.time()))
        
        # build url
        url <- paste0("http://www.icpsr.umich.edu/cgi-bin/bob/zipcart2?path=ICPSR&study=", item, "&bundle=all&ds=&dups=yes")
        
        s <- html_session(url)
        form <- html_form(s)[[3]] %>% 
            set_values(email = email,
                       password = password)
        
        suppressMessages(agree_terms <- submit_form(s, form) %>% 
            jump_to(url))
        suppressMessages(output <- submit_form(agree_terms, 
                                               html_form(agree_terms)[[3]]) %>% 
            follow_link("download your files here"))
        
        file_name <- paste0("ICPSR_", sprintf("%05d", item), ".zip")
        file_dir <- file.path(download_dir, file_name)
        writeBin(httr::content(output$response, "raw"), file_dir)
        
        if (unzip == TRUE) unzip(file_dir, exdir = download_dir)
        
        if (delete_zip == TRUE) invisible(file.remove(file_dir))
        
    })
}
