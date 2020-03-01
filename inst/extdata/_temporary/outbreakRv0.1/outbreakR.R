corIndex <- function( rwi, crn, scale = TRUE) {
  
  ## ensure inputs are same size
  if (nrow( rwi) != nrow( crn)) {
    stop( "host rwi and nonhost crn need to be same size")
  }
  
  ## create matrices
  rwi2 <- as.matrix( rwi)
  crn2 <- matrix( NA_real_, nrow = nrow( rwi2), ncol = ncol( rwi2))
  
  ## fill crn2 with common period control chronology
  for( i in 1:dim( crn2)[1]) {
    for( j in 1:dim( crn2)[2]) {
      if( is.na( rwi2[i, j]) == TRUE) {
        crn2[i, j] <- NA
      } else {
        crn2[i, j] <- crn[i, ]
      }
    }
  }
  
  ## generate empty matrix to fill with CIs
  res <- matrix( NA_real_, nrow = nrow( rwi2), ncol = ncol( rwi2))
  
  ## fill res with unscaled CIs
  for( i  in 1:dim( res)[1]) {
    for( j in 1:dim( res)[2]) {
      res[i, j] <- rwi2[i, j] - (sd( rwi2[, j], na.rm = TRUE) / sd( crn2[, j], na.rm = TRUE)) * (crn2[i, j] - mean(crn2[, j], na.rm = TRUE))
    }
  }
  
  ## normalize CIs if desired
  if( scale == TRUE) {
    res2 <- matrix( NA_real_, nrow = nrow( res), ncol = ncol( res))
    for( i in 1:dim( res2)[1]) {
      for( j in 1:dim( res2)[2]) {
        res2[i, j] <- (res[i, j] - mean( res[, j], na.rm = TRUE)) / sd( res[, j], na.rm = TRUE)
      }
    }
    res <- res2
  } else {
    res
  }
  
  ## return dataframe
  res[is.nan( res)] <- NA_real_
  res <- as.data.frame( res, row.names = rownames( rwi2))
  names( res) <- colnames( rwi2)
  class( res) <- ( "data.frame")
  res
  
}

outbreak <- function( ci, min = 4, sd = -1.28, perc = TRUE) {
  
  ## Create empty data frames to fill
  res <- matrix( NA_real_, nrow = nrow( ci), ncol = ncol( ci))
  res2 <- res; res3 <- res
  ci2 <- ci
  
  ## create -1 leading and +1 lagging dataframes
  require( data.table) ## shift() function requires 'data.table' package
  lag <- as.data.frame( shift( ci, 1, fill = NA, type  = "lag", give.names = TRUE), 
                        row.names = row.names( ci)); names( lag) <- colnames( ci) 
  lead <- as.data.frame( shift( ci, 1, fill = NA, type = "lead", give.names = TRUE), 
                         row.names = row.names( ci)); colnames( lead) <- colnames( ci)
  
  ## create 2-year consecutive outbreak record
  for( i in 1:dim( ci2)[1]) {
    for( j in 1:dim( ci2)[2]) {
      if( is.na( ci2[i,j])) {
        ci2[i,j] <- 0
        res[i,j] <- 0
        res2[i,j] <- 0
      }
      if( is.na( lag[i,j])) {
        lag[i,j] <- 0
      }
      if( is.na( lead[i,j])) {
        lead[i,j] <- 0
      }
      if( ci2[i,j] < 0 || lag[i,j] < 0) {
        res[i,j] <- 1
      } else {
        res[i,j] <- 0
      }
      if( ci2[i,j] < 0 || lead[i,j] < 0) {
        res2[i,j] <- 1
      } else {
        res2[i,j] <- 0
      }
      res3 <- res * res2
      res <- res3
      res <- as.data.frame( res, row.names = rownames( ci2))
      names( res) <- colnames( ci2)
    }
  }
  
  ## REMNANT CODE:
  ## 'count = TRUE' was former default input in function
  ## Can be added back into function to return length of each outbreak period
  #if( count == TRUE) { 
  #  res[] <- lapply(res, function( x) sequence( rle( x)$lengths) * x)
  #  res
  #} else {
  #  res
  #}
  
  ## Get outbreak record based on minimum outbreak length
  if( !is.na(min) && (min < 4 || min > 8)) {
    stop(" min must be >= 4 years and <= 8 years")
  } 
  
  ## No duration set
  if( is.na(min)) {
    res 
  } else if( min >= 4 && min <= 8) {
    ## print("setting minimum outbreak duration ignores count = TRUE") ## remnant from 'count = TRUE' being default setting
    res[] <- lapply(res, function( x) sequence( rle( x)$lengths) * x) ## creates running count
    leads <- function(x) { ## creates function to look ahead multiple years
      as.data.frame( shift( res, n = x, fill = 0, type = "lead", 
                            give.names = TRUE), row.names = row.names( res)) >= min 
    }
    
    ## if minimum outbreak duration is 4 years -- DEFAULT
    if( min == 4) {
      leads1 <- leads(1); leads2 <- leads(2); leads3 <- leads(3)
      for( i in 1:dim( res)[1]) {
        for( j in 1:dim( res)[2]) {
          if( res[i,j] > min - 1 || leads1[i,j] || leads2[i,j] || leads3[i,j]) {
            res[i,j] <- 1
          } else { res[i,j] <- 0 }
        }
      }
    }
    
    ## if minimum outbreak duration is 5 years
    if( min == 5) {
      leads1 <- leads(1); leads2 <- leads(2); leads3 <- leads(3); leads4 <- leads(4)
      for( i in 1:dim( res)[1]) {
        for( j in 1:dim( res)[2]) 
          if( res[i,j] > min - 1 || leads1[i,j] || leads2[i,j] || leads3[i,j] || leads4[i,j]) {
            res[i,j] <- 1
          } else { res[i,j] <- 0 }
      }
    }
    
    ## if minimum outbreak duration is 6 years
    if( min == 6) {
      leads1 <- leads(1); leads2 <- leads(2); leads3 <- leads(3); leads4 <- leads(4); leads5 <- leads(5)
      for( i in 1:dim( res)[1]) {
        for( j in 1:dim( res)[2]) 
          if( res[i,j] > min - 1 || leads1[i,j] || leads2[i,j] || leads3[i,j] || leads4[i,j] || leads5[i,j]) {
            res[i,j] <- 1
          } else { res[i,j] <- 0 }
      }
    }
    
    ## if minimum outbreak duration is 7 years
    if( min == 7) {
      leads1 <- leads(1); leads2 <- leads(2); leads3 <- leads(3); leads4 <- leads(4); leads5 <- leads(5); leads6 <- leads(6)
      for( i in 1:dim( res)[1]) {
        for( j in 1:dim( res)[2]) 
          if( res[i,j] > min - 1 || leads1[i,j] || leads2[i,j] || leads3[i,j] || leads4[i,j] || leads5[i,j] || leads6[i,j]) {
            res[i,j] <- 1
          } else { res[i,j] <- 0 }
      }
    }
    
    ## if minimum outbreak duration is 8 years
    if( min == 8) {
      leads1 <- leads(1); leads2 <- leads(2); leads3 <- leads(3); leads4 <- leads(4); leads5 <- leads(5); leads6 <- leads(6); leads7 <- leads(7)
      for( i in 1:dim( res)[1]) {
        for( j in 1:dim( res)[2]) 
          if( res[i,j] > min - 1 || leads1[i,j] || leads2[i,j] || leads3[i,j] || leads4[i,j] || leads5[i,j] || leads6[i,j] || leads7[i,j]) {
            res[i,j] <- 1
          } else { res[i,j] <- 0 }
      }
    }
  }
  
  ## Determine outbreaks using set standard deviation
  if( !is.na(sd)) {
    res.split <- lapply( res, function(x) cumsum( c( 0, abs( diff( x)))))
    res.keep <- Map(
      ave, ci2, res.split, MoreArgs = list( FUN = function( x) !!any( x < sd))
    )
    
    res <- res * res.keep
    
  } else { res }
  
  ## Determine perecnt of site trees with outbreak conditions by year
  if( perc == TRUE) {
    res$perc <- round( rowSums( res) / rowSums( !is.na( ci)) * 100, 1)
  } else { res }
  
  res
}