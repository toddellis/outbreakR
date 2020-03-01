<!-- README.md is generated from README.Rmd. Please edit that file -->

outbreakR
=========

<!-- badges: start -->
<!-- badges: end -->

outbreakR provides simple tools to extract corrected indices and insect
outbreak reconstruction data from dendrochronological time series data.

Installation
------------

Install the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("toddellis/outbreakR")
```

Using outbreakR
---------------

``` r
library(outbreakR)
head(ob_host)
#> # A tibble: 6 x 69
#>    year MPD01 MPD02 MPD03 MPD04 MPD05  MPD06 MPD07
#>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl> <dbl>
#> 1  1685 0.696    NA    NA    NA    NA NA        NA
#> 2  1686 0.690    NA    NA    NA    NA NA        NA
#> 3  1687 1.09     NA    NA    NA    NA NA        NA
#> 4  1688 0.844    NA    NA    NA    NA  0.547    NA
#> 5  1689 1.15     NA    NA    NA    NA  0.813    NA
#> 6  1690 0.695    NA    NA    NA    NA  0.264    NA
#> # ... with 61 more variables: MPD08 <dbl>,
#> #   MPD09 <dbl>, MPD10 <dbl>, MPD11 <dbl>,
#> #   MPD12 <dbl>, MPD14 <dbl>, MPD15 <dbl>,
#> #   MPD16 <dbl>, SMD01 <dbl>, SMD02 <dbl>,
#> #   SMD03 <dbl>, SMD04 <dbl>, SMD05 <dbl>,
#> #   SMD06 <dbl>, SMD07 <dbl>, SMD08 <dbl>,
#> #   SMD09 <dbl>, SMD10 <dbl>, SMD11 <dbl>,
#> #   SMD12 <dbl>, SMD13 <dbl>, SMD14 <dbl>,
#> #   SMD15 <dbl>, SMD16 <dbl>, SMD17 <dbl>,
#> #   SMD18 <dbl>, TMD01 <dbl>, TMD02 <dbl>,
#> #   TMD03 <dbl>, TMD04 <dbl>, TMD05 <dbl>,
#> #   TMD06 <dbl>, TMD07 <dbl>, TMD08 <dbl>,
#> #   TMD09 <dbl>, TMD10 <dbl>, TMD11 <dbl>,
#> #   TMD12 <dbl>, TMD13 <dbl>, TMD14 <dbl>,
#> #   TMD15 <dbl>, TMD16 <dbl>, TMD17 <dbl>,
#> #   TMD18 <dbl>, TMD19 <dbl>, TMD20 <dbl>,
#> #   VLD01 <dbl>, VLD02 <dbl>, VLD03 <dbl>,
#> #   VLD04 <dbl>, VLD05 <dbl>, VLD06 <dbl>,
#> #   VLD07 <dbl>, VLD08 <dbl>, VLD09 <dbl>,
#> #   VLD10 <dbl>, VLD11 <dbl>, VLD12 <dbl>,
#> #   VLD13 <dbl>, VLD14 <dbl>, VLD15 <dbl>
```
