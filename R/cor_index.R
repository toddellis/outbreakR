#' Title
#'
#' @param host
#' @param nonhost
#' @param scale
#'
#' @return
#' @export
#'
#' @examples
corIndex <- function( host, nonhost, scale = TRUE) {

  require( tidyverse)

  # assumes dplR format with years as rowname data
  # n.b. not compatible with tidy pipes
  nonhost$year <- as.numeric( rownames( nonhost))

  host2 <- host %>%
    # again, assuming dplR format
    mutate( year = as.numeric( rownames( host))) %>%
    # changes dplR's wide-format data to narrow
    gather( "treeID", "host", -year, na.rm = TRUE) %>%
    # merges with nonhost data
    merge( nonhost, by = "year") %>%
    # reorders data
    arrange( treeID, year) %>% ## unnecessary?
    # ensures next line's equation performed uniquely for each tree
    group_by( treeID) %>%
    # calculate corrected indices
    mutate( ci = host - ( sd( host) / sd( nonhost)) *
              ( nonhost - mean( nonhost)))

  # option to normalize the corrected indices
  if( scale == TRUE) {
    host2 <- host2 %>%
      group_by( treeID) %>%
      mutate( ci = scale(ci))
  } else {
    host2
  }

  host <- host2
  rm(host2)
  host

}
