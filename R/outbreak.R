#' Outbreak reconstruction tools
#'
#' Using corrected indices produced by cor_index, this
#' function produces defoliating insect outbreak
#' reconstructions at the tree level.
#'
#' @param ci df: corrected indices
#' @param min int: minimum length of outbreaks
#' @param sd dbl: minimum standard deviation
#' @param prop logical: controls output format
#'
#' @return
#' @export
#'
#' @importFrom magrittr %>%
#' @examples
#' \dontrun{
#' outbreak( cor_index( ob_host, ob_nonhost))
#'
#' foo <- cor_index( ob_host, ob_nonhost))
#' sites <- foo %>%
#'   dplyr::mutate( site = substr( tree_id, 1, 3)) %>%
#'   .$site %>%
#'   unique()
#' bar <- list()
#' for (i in 1:length(sites)) {
#'   bar[[i]] <- foo %>%
#'     dplyr::mutate(site = substr(tree_id, 1, 3)) %>%
#'     dplyr::filter(site == groups[i]) %>%
#'     outbreak() %>%
#'     dplyr::mutate(site = groups[i])
#' }
#' outbreaks <- dplyr::bind_rows(bar)
#'}
outbreak <- function( ci, min = 4, sd = -1.28, prop = TRUE) {

  # ensure minimum outbreak duration falls within correct range
  if( !is.na( min) && ( min < 2 || min > 10)) {

    stop( "minimum outbreak duration must be >= 2 years and <= 10 years")

  }

  # create running count w/ 2-year consecutive outbreak record
  ci2 <- ci %>%
    group_by( tree_id) %>%
    # creates binary low-growth timeseries
    dplyr::mutate( conYrs = ifelse( ( ci < 0 | data.table::shift( ci, 1, type = "lag") < 0) *
                               ( ci < 0 | data.table::shift( ci, 1, type = "lead") < 0),
                             1, 0)) %>%
    # creates running count from binary data
    dplyr::mutate( conYrs = sequence( rle( conYrs)$lengths) * conYrs)

  ## n.b. the following corrects for a possible bug,
  ## where a handful of NAs are created at the earliest year
  ## of recorded growth for a small number of tree_ids
  ## these NAs *should not* be outbreak years on any of the datasets I've tried,
  ## so this fix may be enough to avoid issues
  ## I suspect it's caused by grouping by tree_id and rolling between the most
  ## recent year (w/ an outbreak) to the earliest year of a new tree
  ci2[ is.na(ci2["conYrs"]), "conYrs"] <- 0

  if( is.na( min)) {

    # should probably combine earlier duration stop-point here
    stop( "minimum outbreak duration must be >= 2 years and <= 10 years")

  } else if( min >= 2 && min <= 10) {

    # if minimum outbreak duration is 2 years
    # reminder: this 2-year setting may not work!
    if( min == 2) {
      ci2 <- ci2 %>%
        group_by( tree_id) %>%
        dplyr::mutate( outbreakBinary = ifelse( conYrs > 2 - 1 ||
                                           data.table::shift( conYrs, 1, type = "lead") >= 2,
                                         1, 0))
    }

    # if minimum outbreak duration is 3 years
    if( min == 3) {
      ci2 <- ci2 %>%
        group_by( tree_id) %>%
        dplyr::mutate( outbreakBinary = ifelse( conYrs > 3 - 1 |
                                           data.table::shift( conYrs, 1, type = "lead") >= 3 |
                                           data.table::shift( conYrs, 2, type = "lead") >= 3,
                                         1, 0))
    }

    # if minimum outbreak duration is 4 years -- DEFAULT
    if( min == 4) {
      ci2 <- ci2 %>%
        group_by( tree_id) %>%
        dplyr::mutate( outbreakBinary = ifelse( conYrs > 4 - 1 |
                                           data.table::shift( conYrs, 1, type = "lead") >= 4 |
                                           data.table::shift( conYrs, 2, type = "lead") >= 4 |
                                           data.table::shift( conYrs, 3, type = "lead") >= 4,
                                         1, 0))
    }

    # if minimum outbreak duration is 5 years
    if( min == 5) {
      ci2 <- ci2 %>%
        group_by( tree_id) %>%
        dplyr::mutate( outbreakBinary = ifelse( conYrs > 5 - 1 |
                                           data.table::shift( conYrs, 1, type = "lead") >= 5 |
                                           data.table::shift( conYrs, 2, type = "lead") >= 5 |
                                           data.table::shift( conYrs, 3, type = "lead") >= 5 |
                                           data.table::shift( conYrs, 4, type = "lead") >= 5,
                                         1, 0))
    }

    # if minimum outbreak duration is 6 years
    if( min == 6) {
      ci2 <- ci2 %>%
        group_by( tree_id) %>%
        dplyr::mutate( outbreakBinary = ifelse( conYrs > 6 - 1 |
                                           data.table::shift( conYrs, 1, type = "lead") >= 6 |
                                           data.table::shift( conYrs, 2, type = "lead") >= 6 |
                                           data.table::shift( conYrs, 3, type = "lead") >= 6 |
                                           data.table::shift( conYrs, 4, type = "lead") >= 6 |
                                           data.table::shift( conYrs, 5, type = "lead") >= 6,
                                         1, 0))
    }

    # if minimum outbreak duration is 7 years
    if( min == 7) {
      ci2 <- ci2 %>%
        group_by( tree_id) %>%
        dplyr::mutate( outbreakBinary = ifelse( conYrs > 7 - 1 |
                                           data.table::shift( conYrs, 1, type = "lead") >= 7 |
                                           data.table::shift( conYrs, 2, type = "lead") >= 7 |
                                           data.table::shift( conYrs, 3, type = "lead") >= 7 |
                                           data.table::shift( conYrs, 4, type = "lead") >= 7 |
                                           data.table::shift( conYrs, 5, type = "lead") >= 7 |
                                           data.table::shift( conYrs, 6, type = "lead") >= 7,
                                         1, 0))
    }

    # if minimum outbreak duration is 8 years
    if( min == 8) {
      ci2 <- ci2 %>%
        group_by( tree_id) %>%
        dplyr::mutate( outbreakBinary = ifelse( conYrs > 8 - 1 |
                                           data.table::shift( conYrs, 1, type = "lead") >= 8 |
                                           data.table::shift( conYrs, 2, type = "lead") >= 8 |
                                           data.table::shift( conYrs, 3, type = "lead") >= 8 |
                                           data.table::shift( conYrs, 4, type = "lead") >= 8 |
                                           data.table::shift( conYrs, 5, type = "lead") >= 8 |
                                           data.table::shift( conYrs, 6, type = "lead") >= 8 |
                                           data.table::shift( conYrs, 7, type = "lead") >= 8,
                                         1, 0))
    }

    # if minimum outbreak duration is 9 years
    if( min == 9) {
      ci2 <- ci2 %>%
        group_by( tree_id) %>%
        dplyr::mutate( outbreakBinary = ifelse( conYrs > 9 - 1 |
                                           data.table::shift( conYrs, 1, type = "lead") >= 9 |
                                           data.table::shift( conYrs, 2, type = "lead") >= 9 |
                                           data.table::shift( conYrs, 3, type = "lead") >= 9 |
                                           data.table::shift( conYrs, 4, type = "lead") >= 9 |
                                           data.table::shift( conYrs, 5, type = "lead") >= 9 |
                                           data.table::shift( conYrs, 6, type = "lead") >= 9 |
                                           data.table::shift( conYrs, 7, type = "lead") >= 9 |
                                           data.table::shift( conYrs, 8, type = "lead") >= 9,
                                         1, 0))
    }

    # if minimum outbreak duration is 10 years
    if( min == 10) {
      ci2 <- ci2 %>%
        group_by( tree_id) %>%
        dplyr::mutate( outbreakBinary = ifelse( conYrs > 10 - 1 |
                                           data.table::shift( conYrs, 1, type = "lead") >= 10 |
                                           data.table::shift( conYrs, 2, type = "lead") >= 10 |
                                           data.table::shift( conYrs, 3, type = "lead") >= 10 |
                                           data.table::shift( conYrs, 4, type = "lead") >= 10 |
                                           data.table::shift( conYrs, 5, type = "lead") >= 10 |
                                           data.table::shift( conYrs, 6, type = "lead") >= 10 |
                                           data.table::shift( conYrs, 7, type = "lead") >= 10 |
                                           data.table::shift( conYrs, 8, type = "lead") >= 10 |
                                           data.table::shift( conYrs, 9, type = "lead") >= 10,
                                         1, 0))
    }

  }

  ## n.b. in this case, the outbreaks during the most recent years
  ## may have been called NA due to the inability to look beyond
  ## the coring year
  ## e.g., min == 4 with a tree cored in 2014 that started recording an outbreak in 2012
  ci2[ is.na( ci2[ "outbreakBinary"]), "outbreakBinary"] <- 0

  # determine outbreaks using set standard deviation
  if( !is.na( sd)) {

    ci2 <- ci2 %>%
      # personal learning experience: prior tree_id grouping carried over!
      ungroup() %>%
      # uses binary outbreak data to group periods of outbreak and non-outbreak
      dplyr::mutate( obGroups = cumsum( c( 0, abs( diff( outbreakBinary))))) %>%
      group_by( obGroups) %>%
      # at least one year of each outbreak period must fall below the set standard deviation
      dplyr::mutate( outbreak = ( as.numeric( any( ci < sd)) * outbreakBinary)) %>%
      ungroup()

  } else {

    stop( "set a minimum standard deviation threshold one outbreak year must fall below")

  }

  # determine proportion of site trees with outbreak conditions by year
  # may need tinkering depending on needs: use of summarize removes all other outbreak data
  if( prop == TRUE) {

    ci2 <- ci2 %>%
      group_by( year) %>%
      summarize( outbreakProp = mean( outbreak) * 100)

  } else if( prop == FALSE) {

    ci2 <- ci2  %>%
      dplyr::select(-conYrs, -outbreakBinary, -obGroups)

  }

  ci <- ci2
  rm( ci2)
  ci

}
