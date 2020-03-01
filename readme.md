# OutbreakR

Contact
------
If you have any questions, comments, suggestions, or find any bugs to fix, please send me an e-mail at toddellis.wa AT gmail.com. Thank you!

Synopsis 
------
Included are two custom-built scripts, `corIndex()` and `outbreak()` for use with dendrochronological records in R, with the intent that insect outbreak records can be created using host and non-host data.

`corIndex()` uses host ring-width indices and a non-host chronology in order to create 'corrected' indices: This extracts a growth response (presumably climatic) between host ring-width indices and a single non-host chronology. The output shows positive or negative growth as caused by, e.g., insects.

`outbreak()` uses the output of `corIndex()` in order to create a record of insect outbreaks. There are multiple customization options with this function, including the minimum duration for insect outbreaks and the standard deviation each outbreak's lowest year of growth must be below (see the associated RMarkdown file for further details). Additionally, users can create a new data column that shows the percent of trees impacted by insect outbreaks by year.

Code Example
------
See the RMarkdown file for extensive examplex, explanations, and some graphic ideas. Included are four host sample sites (MPD.rwi, SMD.rwi, TMD.rwi, and VLD.rwi), and one non-host chronology (OHP_PC1.csv) for generating outbreak records.

>   VLD.ci <- corIndex( rwi = VLD.rwi, crn = PIPO.crn, scale = TRUE)
>
>   VLD.ob <- outbreak( ci = VLD.ci, min = 4, sd = -1.28, perc = TRUE)
>
>   plot( VLD.ob$perc, type = "l")

Motivation
------
These methods have previously been unavailable to researchers except through heavily complex custom spreadsheet functions, or through Holmes and Swetnam's (1996) OUTBREAK software. 

The OUTBREAK software, unfortunately, lacks customization options (e.g., outbreak duration), and its settings are modeled after the American Southwest. This heavily biases the results of resultant outbreak reconstructions outside of the region. 

The complexity of the spreadsheet method requires the user to keep track of 10+ connected spreadsheets all fulfilling minor roles. This ultimately makes the likelihood of user-error much too high. 

I also wanted to better understand what these methods were accomplishing, and this seemed like a great step towards doing that!

Installation
------
I advise using the most recent versions of R and RStudio. Additionally, the packages `dplR` and `data.table` are used within these functions, with `ggplot2` used for example images.

(2016-10-16)