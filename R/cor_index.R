#' Corrected indices
#'
#' Use tree-level host ring-width indices and a single master
#' nonhost chronology to create corrected indices for each
#' host tree.
#'
#' @param host df: ring-width indices
#' @param nonhost df: master chronology
#' @param format c('wide', 'long'): input data format
#' @param scale logical: flag to normalize
#' @param years_as_rownames logical: flag for dplR format
#'
#' @return
#' @export
#'
#' @importFrom magrittr %>%
#' @examples
#' \dontrun{
#' cor_index(ob_host, ob_nonhost)
#' cor_index(ob_host %>%
#'             gather('id', 'rwi', -Year),
#'           ob_nonhost,
#'           format = 'long')
#'}
cor_index <- function(host, nonhost, format = 'wide', scale = TRUE, years_as_rownames = FALSE) {

  if (!format %in% c('wide', 'long', 'w', 'l')) {

    stop("Select an input host data format ('wide', 'long')")

  }

  ## Create temporary function for extracting year columns
  year_rename <- function(x) {
    x %>%
      rename( year = matches( str_to_lower( c('Year', 'Yr', 'Years', 'Yrs'))))
  }

  if ( years_as_rownames == TRUE) {
    ## Create year variable if in dplR format
    print("Please avoid using years as rownames.")
    nonhost$year <- as.numeric( rownames( nonhost))
    host$year <- as.numeric( rownames( host))
  }

  ## Prepare nonhost chronology
  nonhost2 <- nonhost %>%
    year_rename() %>%
    rename( nonhost = !matches( 'year'))

  ### Extract nonhost standard deviation and mean
  nonhost_sd <- sd( nonhost2$nonhost,
                   na.rm = TRUE)
  nonhost_mean <- mean( nonhost2$nonhost,
                       na.rm = TRUE)

  if (format == 'wide') {
    host2 <- host %>%
      # rename year column for consistency
      year_rename() %>%
      # changes dplR's wide-format data to narrow
      gather( "tree_id", "host",
              -year,
              na.rm = TRUE)
  } else {
    host2 <- host %>%
      year_rename() %>%
      rename( tree_id = ends_with( str_to_lower( 'ID'))) %>%
      rename( host = !matches( str_to_lower( c('year', 'tree_id')))) %>%
      filter( !is.na(host))
  }


  host2 <- host2 %>%
    # merges with nonhost data
    right_join( nonhost2, by = "year") %>%
    # ensures next line's equation performed uniquely for each tree
    group_by( tree_id) %>%
    # calculate corrected indices
    mutate( ci = host - ( sd( host) / nonhost_sd) *
              ( nonhost - nonhost_mean))

  # option to normalize the corrected indices
  if( scale == TRUE) {
    host2 <- host2 %>%
      group_by( tree_id) %>%
      mutate( ci = scale(ci))
  } else {
    host2
  }

  host <- host2 %>%
    arrange(tree_id, year) %>%
    filter(!is.na(ci))
  rm(host2); rm(nonhost2); rm(year_rename)
  host

}
