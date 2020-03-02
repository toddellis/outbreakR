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
#'             tidyr::gather('id', 'rwi', -Year),
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
      dplyr::rename( year = dplyr::matches(stringr::str_to_lower( c('Year', 'Yr', 'Years', 'Yrs'))))
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
    dplyr::rename( nonhost = !dplyr::matches( 'year'))

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
      tidyr::gather( "tree_id", "host",
              -year,
              na.rm = TRUE)
  } else {
    host2 <- host %>%
      year_rename() %>%
      dplyr::rename( tree_id = ends_with( stringr::str_to_lower( 'ID'))) %>%
      dplyr::rename( host = !dplyr::matches( stringr::str_to_lower( c('year', 'tree_id')))) %>%
      dplyr::filter( !is.na(host))
  }


  host2 <- host2 %>%
    # merges with nonhost data
    dplyr::right_join( nonhost2, by = "year") %>%
    # ensures next line's equation performed uniquely for each tree
    dplyr::group_by( tree_id) %>%
    # calculate corrected indices
    dplyr::mutate( ci = host - ( sd( host) / nonhost_sd) *
              ( nonhost - nonhost_mean))

  # option to normalize the corrected indices
  if( scale == TRUE) {
    host2 <- host2 %>%
      dplyr::group_by( tree_id) %>%
      dplyr::mutate( ci = scale(ci))
  } else {
    host2
  }

  host <- host2 %>%
    dplyr::arrange(tree_id, year) %>%
    dplyr::filter(!is.na(ci))
  rm(host2); rm(nonhost2); rm(year_rename)
  host

}
