
<!-- README.md is generated from README.Rmd. Please edit that file -->
Introduction
============

Rfuels is a small package for estimating surface fuel loads from Brown's transects (a.k.a. line-intercept transects) in forests dominated by Sierra Nevada conifer species.

The common protocols for sampling surface fuels in forest ecosystems directly describe the fuel load in terms of duff/litter depth, counts of fine woody fuels, and surveys of coarse woody debris. However, many uses of these data (e.g. fire behavior models and carbon accounting) require the fuel load to be expressed in terms of mass of surface fuels per unit area.

Brown (1974) described a general-purpose set of equations to estimate fuel loads from transect data. Rfuels uses the species composition of the local overstory to improve the fuel load estimates from Brown's transects.

See "Using Rfuels" for information about data requirements and using the package, and see "Background Information" for a more detailed description of the estimation method.

Installing Rfuels
=================

Someday, Rfuels may appear on the CRAN repository. For now, you can install Rfuels from the GitHub repo:

``` r
# install the 'devtools' package
install.packages("devtools")

# load the 'devtools' package
library(devtools)

# install Rfuels
devtools::install_github('danfosterfire/Rfuels')
```

Then you can load the Rfuels package with:

``` r
library(Rfuels)
```

Using Rfuels
============

Rfuels provides a high-level wrapper function, **estimate\_fuel\_loads()**, which
takes three arguments:

-   *fuels\_data*, a properly-formatted dataframe containing the observed fuels data
-   *trees\_data*, a properly-formatted containg the observed tree data
-   *results\_type*, either 'full', 'results\_only', or 'fuels\_only'. This sets the verbosity of the results dataframe.

**estimate\_fuel\_loads()** will return a tidy dataframe, with each row a unique observation (a fuels transect sampled on a specific date) and columns describing the surface fuel load in various subcategories.

Data Requirements
-----------------

Rfuels imposes very specific requirements on the type and format of input data, so read this section carefully!

### Fuels Data

Surface fuels should be recorded in the field following Brown (1974) or a similar method. The specifics of transect lengths, number of transects per plot, and the number of litter and duff samples per transect are variable, but the broad outline is common:

-   Each sampling location (plot) will have one or more transects starting at the plot center

-   All measurements are collected along all transects

-   Litter and duff depths are sampled at fixed location(s) along each transect

-   For predefined distances along the transect, the number of fine woody fuel particles that intersect the transect is recorded as a count. Fine woody fuel particles are categorized by size into 1-hour, 10-hour, and 100-hour fuels, and recorded separately.

-   Each 1000-hour fuel intersecting the transect has its diameter and decay class recorded individually

-   Most versions of the protocol also call for measuring the depth of the entire fuelbed, but this information is not used for estimating the fuel load represented by the sample

Rfuels requires the input fuels data to be formatted as a dataframe with a row for each observation (a transect on a specific date). The dataframe must have at least these columns (column names are exact):

-   **plot\_id**: Plot IDs identify the sampling location. If you have a nested study design with "stand A plot 1" and "stand B plot 1", use "A-1" and "B-1" as PlotIDs. (This will be helpful when running statistical analyses later.) There may be multiple inventory dates per plot\_id and/or multiple transects sharing a plot\_id. plot\_id will be coerced to a character vector on import.

-   **inv\_date**: The date of measurement, in mm/dd/YYYY format. There must be a 1:1 match between the dates of fuels measurements and dates of trees data.

-   **azimuth**: Integer in the range 0-359 (inclusive) giving the azimuth from plot center for the transect. Rfuels uses the azimuth as an identifier for individual transects within plots. Must be unique within a (plot\_id:inv\_date). Will be coerced to character.

-   **x1h\_length\_m**, **x10h\_length\_m**, **x100h\_length\_m**, and **x1000h\_length\_m**: Numeric(s) greater than 0. The length (in meters) of the sampling transects for 1-hour, 10-hour, 100-hour, and 1000-hour fuels, respectively. Transect lengths may vary by plot\_id and/or year, for example if sampling protocols changed over time, or 1000-hour transects were extended until at least one intersection was found.

-   **count\_x1h, count\_x10h, count\_x100h**: Integers greater than or equal to 0. Transect counts of the number of intersections for 1-, 10-, and 100-hour fuels, respectively.

-   **duff\_depth\_cm** and **litter\_depth\_cm**: Numeric greater than 0. Average depth of duff / litter (in cm) on the transect. Users with multiple measurements per transect of litter and/or duff should average them together before import. Depths must be recorded in cm.

-   **sum\_d2\_1000r\_cm2** and **sum\_d2\_1000s\_cm2** The sum-of-squared-diameters for 1000-hour fuels on the transect, for rotten and sound fuels respectively. Users must aggregate their large fuels (1000-hour) into sound or rotten classes, and sum the squared diameters (in cm) for all 1000-s or 1000-r intersections on the transect.

Additionally, the dataframe *may* have a column for **slope\_percent**, the slope (in percent) along the transect. Brown's equations include the option to correct for the slope effect on horizontal length of transects. *Keep in mind that this correction factor applies to the transect slope, not the plot slope.* If a slope\_percent is not supplied, we set the slope correction factor to 1 (no slope).

### Trees Data

The dataframe must have a row for each observation of each individual tree on each sampling date (this format is commonly called a "treelist"). The treelist must have at least these columns:

-   **plot\_id**: Plot IDs identify the sampling location. If you have a nested study design with "stand A plot 1" and "stand B plot 1", use full nested identifiers (e.g. "A-1" and "B-1"). This will be helpful when running statistical analyses later.) There may be multiple inventory dates per plot\_id and/or multiple transects sharing a plot\_id. plot\_id will be coerced to a character vector on import.

-   **inv\_date**: The date of measurement, in mm/dd/YYYY format. There must be a 1:1 match between the dates of fuels measurements and dates of trees data.

-   **species**: A species identifier code for the individual tree. Generally follows 4-letter scientific abbreviation format (e.g. Abies concolor is "ABCO", not "WF", "White fir", "Abies\_concolor", etc.). Compare your species codes to those included in the Van Wagtendonk constant tables (see "Background Information") to ensure correct matching. Note that singleleaf pinyon (Pinus monophylla) and western white pine (Pinus monticola) would share the code "PIMO" - these should be labeled "PIMO1" and "PIMO2", respectively.

-   **dbh\_cm**: The diameter at breast height (4.5', 1.37m) of the tree in centimeters.

Load Data
---------

Our nice example data are .csv files which are already properly formatted:

``` r
# load the example fuels data from the .csv file
example_fuels_data = read.csv(file = 'path/to/your/data/fuels.csv',
                              stringsAsFactors = TRUE)

# load the example trees data from the .csv file
example_trees_data = read.csv(file = 'path/to/your/data/trees.csv',
                              stringsAsFactors = TRUE)
```

And here's what the example data look like:

``` r
head(example_fuels_data)
#>      plot_id inv_date azimuth x1h_length_m x10h_length_m x100h_length_m
#> 1 0040-00007 6/1/2001     224         1.83          1.83           3.05
#> 2 0040-00007 6/1/2001     336         1.83          1.83           3.05
#> 3 0040-00002 6/1/2001     129         1.83          1.83           3.05
#> 4 0040-00002 6/1/2001     190         1.83          1.83           3.05
#> 5 0040-00003 6/1/2001     228         1.83          1.83           3.05
#> 6 0040-00003 6/1/2001     296         1.83          1.83           3.05
#>   x1000h_length_m count_x1h count_x10h count_x100h duff_depth_cm
#> 1           11.34        47          4           0           4.5
#> 2           11.34        32          5           1           4.0
#> 3           11.34        32          6           0           3.5
#> 4           11.34        35          5           1           2.0
#> 5           11.34         5          0           1           1.5
#> 6           11.34         4          0           0           1.0
#>   litter_depth_cm sum_d2_1000r_cm2 sum_d2_1000s_cm2
#> 1             3.5                0                0
#> 2             3.5              421                0
#> 3             3.0              196                0
#> 4             2.0              361                0
#> 5             2.5              565                0
#> 6             3.5              121                0

head(example_trees_data)
#>      plot_id inv_date species dbh_cm
#> 1 0040-00002 6/1/2001    PSME   11.4
#> 2 0040-00002 6/1/2001    ABCO   13.2
#> 3 0040-00002 6/1/2001    ABCO   23.9
#> 4 0040-00002 6/1/2001    CADE   28.7
#> 5 0040-00002 6/1/2001    PSME   34.5
#> 6 0040-00002 6/1/2001    PSME   35.1
```

Call estimate\_fuel\_loads()
----------------------------

Once your input data are properly formatted, you can call estimate\_fuel\_loads() and assign the resulting dataframe to a variable:

``` r
transect_fuel_loads =  
  
  estimate_fuel_loads(fuels_data = example_fuels_data,
                      trees_data = example_trees_data,
                      results_type = 'results_only')
#> Warning in validate_treelist(trees_data = trees_data): 
#>   Not all species codes were recognized. Unrecognized codes were
#>     converted to "OTHER" and will receive generic coefficients. Try
#>     "help(validate_treelist)" for more info.
#> 
#>     Unrecognized codes:  QUKE
#> Return results table with observation ID, fuel loads, and overstory info
```

We got a message about the type of results returned, and also a warning about our input treelist. Our dataset includes *Quercus kelloggii*, which isn't one of the tree species for which we have empirical data to plug into the fuel load estimations. **estimate\_fuel\_loads()** makes a best-guess and counts all unrecognized tree species as 'OTHER', and applies the "All species" generic coefficients from Van Wagtendonk et al. (1996) and (1998).

(How appropriate it is to apply an 'all species' constant for Sierra Nevada conifers to black oak fuels is another question; hopefully in the future we can expand the empirical dataset Rfuels draws upon.)

Now we have a dataframe with the fuel load (and some overstory information) for each transect in each year:

``` r
head(transect_fuel_loads)
#>      plot_id   inv_date  pBA_ABCO  pBA_CADE pBA_OTHER pBA_PILA pBA_PIPO
#> 1 0040-00002 2001-06-01 0.3869356 0.3039741         0        0        0
#> 2 0040-00002 2001-06-01 0.3869356 0.3039741         0        0        0
#> 3 0040-00002 2003-06-01 0.3914813 0.2977289         0        0        0
#> 4 0040-00002 2003-06-01 0.3914813 0.2977289         0        0        0
#> 5 0040-00002 2009-06-01 0.2629361 0.3097439         0        0        0
#> 6 0040-00002 2009-06-01 0.2629361 0.3097439         0        0        0
#>    pBA_PSME pBA_(all) azimuth fuelload_litter_Mgha fuelload_duff_Mgha
#> 1 0.3090903         1     129             31.83622          52.647524
#> 2 0.3090903         1     190             21.22415          30.084299
#> 3 0.3107898         1     190             21.18960           7.514481
#> 4 0.3107898         1     129             21.18960          30.057926
#> 5 0.4273200         1     190             10.40521          59.263724
#> 6 0.4273200         1     129              0.00000          51.855759
#>   fuelload_1h_Mgha fuelload_10h_Mgha fuelload_100h_Mgha
#> 1        0.9705900          3.031870           0.000000
#> 2        1.0615829          2.526558           3.435257
#> 3        0.8781526          5.562356           0.000000
#> 4        2.2408033          6.068024           3.422609
#> 5        0.9017438          5.653288           3.537134
#> 6        2.0220922          5.182181           0.000000
#>   fuelload_1000s_Mgha fuelload_1000r_Mgha fuelload_fwd_Mgha
#> 1                   0            7.942901          4.002460
#> 2                   0           14.629528          7.023398
#> 3                   0           12.397520          6.440508
#> 4                   0            4.902287         11.731437
#> 5                   0            0.000000         10.092167
#> 6                   0            0.000000          7.204273
#>   fuelload_1000h_Mgha fuelload_surface_Mgha fuelload_total_Mgha
#> 1            7.942901             43.781582            96.42911
#> 2           14.629528             42.877073            72.96137
#> 3           12.397520             40.027625            47.54211
#> 4            4.902287             37.823321            67.88125
#> 5            0.000000             20.497373            79.76110
#> 6            0.000000              7.204273            59.06003
```

Results details
---------------

The results\_only dataframe (the default) includes the following columns:

-   **plot\_id**: A factor with the plot\_id (location in space and/or study design) for each observation.

-   **inv\_date**: The date of the observation.

-   **pBA\_\[species\]**: For each \[species\], the proportion of total plot basal area occupied by that species. For example, if a plot has many small white fir totalling 0.06 ![m^2](https://latex.codecogs.com/png.latex?m%5E2 "m^2") basal area, and a few large ponderosa pine totalling 0.14 ![m^2](https://latex.codecogs.com/png.latex?m%5E2 "m^2") basal area, *pBA\_ABCO* = 0.3 and *pBA\_PIPO* = 0.7. These columns describe the species composition of the overstory for the transect.

-   **pBA\_(all)**: The total proportional basal area of all species on the plot, which should always be equal to 1. (Or nearly so, within a small rounding error.)

-   **azimuth**: The azimuth from plot center used for the transect. This can (and should) be used as a nested observation identifier within a plot\_id.

-   **fuelload\_litter\_Mgha**: The fuel load of litter, in metric tons per hectare, as sampled on a single transect. Robust stand-level estimates should include many transects.

-   **fuelload\_duff\_Mgha**: The fuel load of duff, in metric tons per hectare.

-   **fuelload\_1h\_Mgha**: The fuel load of 1-hour fuels (0 - 0.64 cm diameter), in metric tons per hectare.

-   **fuelload\_10h\_Mgha**: The fuel load of 10-hour fuels (0.64 - 2.54 cm diameter), in metric tons per hectare.

-   **fuelload\_100h\_Mgha**: The fuel load of 100-hour fuels (2.54 - 7.62 cm diameter), in metric tons per hectare.

-   **fuelload\_1000s\_Mgha**: The fuel load of sound 1000-hour fuels (7.62+ cm diameter) in metric tons per hectare.

-   **fuelload\_1000r\_Mgha**: The fuel load of rotten 1000-hour fuels (7.62+ cm diameter) in metric tons per hectare.

-   **fuelload\_fwd\_Mgha**: The total 'fine woody debris' fuel load (1-hour, 10-hour, and 100-hour fuels combined) in metric tons per hectare.

-   **fuelload\_1000h\_Mgha**: The total 1000-hour fuel load (sound and rotten combined) in metric tons per hectare.

-   **fuelload\_surface\_Mgha**: The total surface fuel load, in metric tons per hectare. This is the sum of the litter, fine woody debris, and 1000-hour fuel loads.

-   **fuelload\_total\_Mgha**: The total fuel load, in metric tons per hectare. This is the sum of the litter, duff, fine woody debris, and 1000-hour fuel loads.

The *results\_full* dataframe includes all of the above, plus these additonal columns describing the directly observed values and some intermediate calculations:

-   **x1h\_length\_m**, **x10h\_length\_m**, **x100h\_length\_m**, and **x\_1000h\_length\_m**: Relevant transect lengths in meters.

-   **count\_x1h**, **count\_x10h**, **count\_x100h**, **duff\_depth\_cm**, **litter\_depth\_cm**, **sum\_d2\_1000r\_cm2**, and **sum\_d2\_1000s\_cm2**: The empirical observations for each fuel category, as supplied by the input data.

-   **slp\_c**: The slope correction factor used for the transect. Defaults to 1 if no transect-level slope information is available. See "Background Information" for more details.

-   **litter\_coeff** and **duff\_coeff**: Plot-specific estimates of the linear coefficient between duff / litter depth (in cm) and duff / litter fuel load (in kg / ![m^2](https://latex.codecogs.com/png.latex?m%5E2 "m^2")). Derived by averaging species-specific empirical values according to the species composition of the plot overstory. See "Background Information" for more details. When multiple transects share the same plot\_id, they will have the same overstory, and will share these coefficients.

-   **x1h\_coeff**, **x10h\_coeff**, and **x100h\_coeff**: Plot-specific coefficients derived by averaging species-specific empirical values according to the species composition of the plot overstory. See "Background Information" for more details. When multiple transects share the same plot\_id, they will have the same overstory, and will share these coefficients.

-   **x1000s\_coeff** and **x1000r\_coeff**: A plot-specific coefficients derived by averaging species-specific empirical values according to the species composition of the plot overstory. See "Background Information" for more details. When multiple transects share the same plot\_id, they will have the same overstory, and will share these coefficients.

Finally, the *fuels\_only* dataframe includes only the observation identification columns (*plot\_id*, *inv\_date*, and *azimuth*) and the columns for the various fuel load categories.

Working with fuel load data
---------------------------

*under construction*

Background Information
======================

This method for calculating fuel loads from Brown's transects was originally described in Stephens (2001). Specifically:

> "Surface and ground fuel loads were calculated by using appropriate equations developed for Sierra Nevada forests (van Wagtendonk et al. 1996, 1998). Coefficients required to calculate all surface and ground fuel loads were arithmetically weighted by the basal area fraction (percentage of total basal area by species) to produce accurate estimates of fuel loads (Jan van Wagtendonk, personal communication, 1999)."

Since then, the method has been used repeatedly in other publications, particularly those related to the Fire-Fire-Surrogate study at Blodgett Forest Reserach Station, e.g. Stephens and Moghaddas (2005) and Stephens et al. (2012). At some point, Jason Moghaddas constructed an excel workbook (with included macros) to facilitate use of the method for new datasets.

The this package implements the method in R, using Moghaddas' implementation (and various publications) for reference. The goal of this effort is to make the method more accessible, transparent, and reproducible for use in future research.

This method requires Brown's transect data and plot (or stand) level overstory data. Brown (1974) describes the widely used fuels transect sampling protocol and provides equations used to calculate fuel loads for woody debris from the transect samples.

The general idea of Stephens's modification of the method is to refine the fuel load estimates by using overstory data to improve the accuracy of coefficents used in Brown's equations to calculate fuel loads from transect data. Specifically, QMD, SEC, and SG are coefficients which vary by the species that is the fuel source, and so better estimates can (presumably) be derived by using species-weighted-average values for QMD, SEC, and SG rather than using Brown's given values, which are generalized for entire regions. (See below for definitions of QMD, SEC, and SG.)

**Note:** This implementation of the method assumes the user is working in the Sierra Nevada. Any species not included in the Van Wagtendonk et al. tables below is assigned their "All Species" value by default. Also, per the usage of Moghaddas' spreadsheet for previous studies, I have elected to include both live and dead trees in the basal-area calculations for the purposes of calculating fuel loads.

This method breaks forest fuels into three main categories, each of which has a particular implementation for calculating the fuel load represented by transect samples.

Litter and Duff
---------------

Litter and duff are measured as depths as specific points along a sampling transect. Van Wagtendonk (1998) developed regressions for litter, Duff, and combined-litter-and-duff loading (kg/![m^2](https://latex.codecogs.com/png.latex?m%5E2 "m^2")) as a function of depth (cm) for 19 different Sierra Nevada conifer species:

| species            | spp    |  litter\_coeff|  duff\_coeff|  litterduff\_coeff|
|:-------------------|:-------|--------------:|------------:|------------------:|
| Douglas-fir        | PSME   |          0.864|        1.319|              1.295|
| Foothill pine      | PISA   |          0.111|        1.448|              1.220|
| Foxtail pine       | PIBA   |          0.886|        2.504|              2.360|
| Giant sequoia      | SEGI   |          0.990|        1.648|              1.632|
| Incense-cedar      | CADE   |          1.276|        1.675|              1.664|
| Jeffrey pine       | PIJE   |          0.358|        1.707|              1.496|
| Knobcone pine      | PIAT   |          0.339|        1.646|              1.274|
| Limber pine        | PIFL   |          0.889|        2.337|              2.255|
| Lodgepole pine     | PICO   |          0.951|        1.671|              1.612|
| Mountain hemlock   | TSME   |          1.102|        1.876|              1.848|
| Ponderosa pine     | PIPO   |          0.276|        1.402|              1.233|
| Red fir            | ABMA   |          0.530|        1.727|              1.722|
| Singleleaf pinyon  | PIMO1  |          0.906|        2.592|              2.478|
| Sugar pine         | PILA   |          0.304|        1.396|              1.189|
| Washoe pine        | PIWA   |          0.600|        1.870|              1.719|
| Western juniper    | JUOC   |          0.832|        1.798|              1.763|
| Western white pine | PIMO2  |          0.542|        1.422|              1.485|
| White fir          | ABCO   |          1.050|        1.518|              1.572|
| Whitebark pine     | PIAL   |          0.540|        1.895|              1.802|
| All species        | ALLSPP |          0.363|        1.750|              1.624|
| Unknown            | OTHER  |          0.363|        1.750|              1.624|

The fuel load represented by a depth measurement under a mixed-species overstory can be estimated using the equation

![F\_{d,plot} = d \* Coeff\_{plot}](https://latex.codecogs.com/png.latex?F_%7Bd%2Cplot%7D%20%3D%20d%20%2A%20Coeff_%7Bplot%7D "F_{d,plot} = d * Coeff_{plot}")

where:

-   ![F\_{d,plot}](https://latex.codecogs.com/png.latex?F_%7Bd%2Cplot%7D "F_{d,plot}") is the fuel load (in kg/![m^2](https://latex.codecogs.com/png.latex?m%5E2 "m^2"))

-   ![d](https://latex.codecogs.com/png.latex?d "d") is the depth of litter, duff, or litter and duff together (in cm) at some point along the transect. If depth was taken at multiple points along the transect, average them together to calculate *d*.

-   ![Coeff\_{plot}](https://latex.codecogs.com/png.latex?Coeff_%7Bplot%7D "Coeff_{plot}") is the best estimate coefficient for the linear relationship between depth and fuel load for a fuel bed generated by the overstory present at *plot*

We can calculate ![Coeff\_{plot}](https://latex.codecogs.com/png.latex?Coeff_%7Bplot%7D "Coeff_{plot}") by averaging together the different species-specific coefficients for each tree species contributing fuel to the plot, weighted by their local prevalence. Specifically, we weight each species' coefficient by the proportion of total basal area contributed by that species:

![Coeff\_{plot} = \\sum\_{spp}{\[(\\frac{BA\_{spp}}{BA\_{total}})\*Coeff\_{spp}\]}](https://latex.codecogs.com/png.latex?Coeff_%7Bplot%7D%20%3D%20%5Csum_%7Bspp%7D%7B%5B%28%5Cfrac%7BBA_%7Bspp%7D%7D%7BBA_%7Btotal%7D%7D%29%2ACoeff_%7Bspp%7D%5D%7D "Coeff_{plot} = \sum_{spp}{[(\frac{BA_{spp}}{BA_{total}})*Coeff_{spp}]}")

Where

-   ![Coeff\_{spp}](https://latex.codecogs.com/png.latex?Coeff_%7Bspp%7D "Coeff_{spp}") is the species-specific coefficient for species *spp*,

-   ![Coeff\_{plot}](https://latex.codecogs.com/png.latex?Coeff_%7Bplot%7D "Coeff_{plot}") is the best estimate multiple-species coefficient we will use to estimate the fuel load for transects taken in the plot

-   ![BA\_{spp}](https://latex.codecogs.com/png.latex?BA_%7Bspp%7D "BA_{spp}") and ![BA\_{total}](https://latex.codecogs.com/png.latex?BA_%7Btotal%7D "BA_{total}") are the basal area occupied by species *spp* and the total overstory basal area (respectively) in the plot.

-   ![\\frac{BA\_{spp}}{BA\_{total}}](https://latex.codecogs.com/png.latex?%5Cfrac%7BBA_%7Bspp%7D%7D%7BBA_%7Btotal%7D%7D "\frac{BA_{spp}}{BA_{total}}") is proportion of the plot's basal area occupied by species *spp*.

This esimate of the fuel load represented by the transect can be averaged with other transects at the same plot (which will have the same value for ![Coeff\_{plot}](https://latex.codecogs.com/png.latex?Coeff_%7Bplot%7D "Coeff_{plot}"), but different values for *d*) to generate plot-level estimates of fuel load, which can themselves be averaged to generate unit-level estimates of fuel load, depending on the user's study design.

Fine Woody Debris: 1-hour, 10-hour, and 100-hour fuels
------------------------------------------------------

Calculating fuel loads represented by transect counts of 1-hour, 10-hour, and 100-hour fuels is more complicated, but follows the same principle as described for litter and duff above. The different timelag classes (which correspond to size classes of 0.0-0.64cm, 0.64-2.54cm, and 2.54-7.62cm, respectively) must be calculated separately but in a common manner.

Van Wagtendonk et al. (1996) give the equation (modified from Brown 1974):

![W = \\frac{const\*QMD\*SEC\*SLP\*SG\*n}{length}](https://latex.codecogs.com/png.latex?W%20%3D%20%5Cfrac%7Bconst%2AQMD%2ASEC%2ASLP%2ASG%2An%7D%7Blength%7D "W = \frac{const*QMD*SEC*SLP*SG*n}{length}")

Where:

-   ![W](https://latex.codecogs.com/png.latex?W "W") is the estimated weight (in tons/acre, kg/ha, etc.) of fine woody debris size class *f* on the plot

-   ![const](https://latex.codecogs.com/png.latex?const "const") is a constant composed of various unit conversion factors (e.g., to get to tons/acre in the end), described by some authers as *k*

-   ![QMD](https://latex.codecogs.com/png.latex?QMD "QMD") is the quadratic mean diameter of the fuels recorded in the transect

-   ![SEC](https://latex.codecogs.com/png.latex?SEC "SEC") is the correction for the nonhorizontal angle of the fuels

-   ![SLP](https://latex.codecogs.com/png.latex?SLP "SLP") is the slope correction factor, which allows corrected for the effect of a non-horizontal transect on the horizontal distance sampled

-   ![SG](https://latex.codecogs.com/png.latex?SG "SG") is the specific gravity of the fuels in the transect

-   ![n](https://latex.codecogs.com/png.latex?n "n") is the number of fuel particles intersecting the transect,

-   and ![length](https://latex.codecogs.com/png.latex?length "length") is the length of the transect.

Procedures for calculating these values are described below. *QMD*, *SEC*, and *SG* all vary by timelag classification, and so *W* is calculated individually for each timelag (1h, 10h, and 100h).

### Const (k-values)

Equation constant *k* ("const" in van Wagtendonk 1996 and Brown 1974) for sampled units and output units. These values for *k* are from van Wagner (1982), and these are used by forest service per Woodall and Williams (2008). (These values are also consistent with Moghaddas' work.)

| fuel\_diam | transect\_length | volume\_fuel\_per\_area       | weight\_fuel\_per\_area |          k|
|:-----------|:-----------------|:------------------------------|:------------------------|----------:|
| cm         | m                | m<sup>3</sup>/m<sup>2</sup>   | NA                      |  1.234e-04|
| cm         | m                | m<sup>3</sup>/ha              | NA                      |  1.234e+00|
| cm         | m                | NA                            | kg/m<sup>2</sup>        |  1.234e-01|
| cm         | m                | NA                            | tons/ha                 |  1.234e+00|
| in         | ft               | ft<sup>3</sup>/ft<sup>2</sup> | NA                      |  8.567e-03|
| in         | ft               | ft<sup>3</sup>/ac             | NA                      |  3.733e+02|
| in         | ft               | NA                            | lb/ft<sup>2</sup>       |  5.348e-01|
| in         | ft               | NA                            | tons/ac                 |  1.165e+01|

### QMD (Quadratic mean diameter in centimeters squared)

QMD, SEC, and SG vary by species and timelag classification of the fuel being totaled. Values for specific species/timelag for fine woody fuels are drawn from van Wagtendonk (1996).

| species                  | spp    |   x1h|  x10h|  x100h|  x1000h|
|:-------------------------|:-------|-----:|-----:|------:|-------:|
| Abies concolor           | ABCO   |  0.08|  1.32|  11.56|  162.56|
| Abies magnifica          | ABMA   |  0.10|  1.32|  16.24|  219.93|
| Calocedrus decurrens     | CADE   |  0.09|  1.23|  20.79|   74.30|
| Juniperus occidentalis   | JUOC   |  0.08|  1.61|  13.92|   61.62|
| Pinus albicaulis         | PIAL   |  0.13|  1.21|  14.75|   92.74|
| Pinus attenuata          | PIAT   |  0.10|  1.25|   9.68|   70.39|
| Pinus balfouriana        | PIBA   |  0.12|  0.92|  12.82|  127.24|
| Pinus contorta           | PICO   |  0.10|  1.44|  13.39|  138.06|
| Pinus flexilis           | PIFL   |  0.21|  1.28|  17.72|  115.78|
| Pinus jeffreyi           | PIJE   |  0.15|  1.25|  17.31|  135.49|
| Pinus lambertiana        | PILA   |  0.12|  1.46|  13.61|  169.52|
| Pinus monophylla         | PIMO1  |  0.09|  1.41|  11.56|  129.96|
| Pinus monticola          | PIMO2  |  0.08|  0.79|   9.92|  127.24|
| Pinus ponderosa          | PIPO   |  0.23|  1.56|  19.36|  101.81|
| Pinus sabiniana          | PISA   |  0.14|  0.94|  12.91|  127.24|
| Pinus washoensis         | PIWA   |  0.22|  1.37|  13.47|  122.77|
| Pseudotsuga menziesii    | PSME   |  0.06|  1.37|  12.04|   75.69|
| Seguoiadendron giganteum | SEGI   |  0.14|  1.28|  17.06|  167.70|
| Tsuga mertensiana        | TSME   |  0.05|  1.46|  13.61|  115.99|
| All Species              | ALLSPP |  0.12|  1.28|  14.52|  127.24|
| Other                    | OTHER  |  0.12|  1.28|  14.52|  127.24|

These constants are used in combination with overstory data to create an aggregate estimate of QMD, an average of the various species' QMD estimates (from Van Wagtendonk et al.) weighted by the proportion of stand basal area occupied by each species. See the following formula:

![QMD\_{plot,timelag} = \\sum\_{species=spp}{PropBA\_{spp,plot}\*QMD\_{spp,timelag}}](https://latex.codecogs.com/png.latex?QMD_%7Bplot%2Ctimelag%7D%20%3D%20%5Csum_%7Bspecies%3Dspp%7D%7BPropBA_%7Bspp%2Cplot%7D%2AQMD_%7Bspp%2Ctimelag%7D%7D "QMD_{plot,timelag} = \sum_{species=spp}{PropBA_{spp,plot}*QMD_{spp,timelag}}")

Where

-   ![QMD\_{plot}](https://latex.codecogs.com/png.latex?QMD_%7Bplot%7D "QMD_{plot}") is the estimated quadratic mean diameter of fuels in the *timelag* class in the *plot* across all species

-   ![PropBA\_{spp,plot}](https://latex.codecogs.com/png.latex?PropBA_%7Bspp%2Cplot%7D "PropBA_{spp,plot}") is the proportion of total basal area in *plot* occupied by the species *spp*, calculated from the measurement data

-   ![QMD\_{spp,timelag}](https://latex.codecogs.com/png.latex?QMD_%7Bspp%2Ctimelag%7D "QMD_{spp,timelag}") is the QMD of fuels in the *timelag* class for species *spp*, as reported by Van Wagtendonk et al. (1996) Table 3.

### SEC (secant of acute angle)

| species                  | spp    |   x1h|  x10h|  x100h|  x1000h|
|:-------------------------|:-------|-----:|-----:|------:|-------:|
| Abies concolor           | ABCO   |  1.03|  1.02|   1.02|    1.01|
| Abies magnifica          | ABMA   |  1.03|  1.02|   1.01|    1.00|
| Calocedrus decurrens     | CADE   |  1.02|  1.02|   1.03|    1.06|
| Juniperus occidentalis   | JUOC   |  1.03|  1.04|   1.04|    1.04|
| Pinus albicaulis         | PIAL   |  1.02|  1.02|   1.02|    1.02|
| Pinus attenuata          | PIAT   |  1.03|  1.02|   1.00|    1.02|
| Pinus balfouriana        | PIBA   |  1.02|  1.02|   1.01|    1.02|
| Pinus contorta           | PICO   |  1.02|  1.02|   1.01|    1.05|
| Pinus flexilis           | PIFL   |  1.02|  1.02|   1.01|    1.01|
| Pinus jeffreyi           | PIJE   |  1.03|  1.03|   1.04|    1.05|
| Pinus lambertiana        | PILA   |  1.04|  1.04|   1.03|    1.03|
| Pinus monophylla         | PIMO1  |  1.02|  1.01|   1.01|    1.05|
| Pinus monticola          | PIMO2  |  1.03|  1.02|   1.06|    1.02|
| Pinus ponderosa          | PIPO   |  1.02|  1.03|   1.02|    1.01|
| Pinus sabiniana          | PISA   |  1.05|  1.03|   1.02|    1.02|
| Pinus washoensis         | PIWA   |  1.02|  1.02|   1.01|    1.05|
| Pseudotsuga menziesii    | PSME   |  1.03|  1.02|   1.03|    1.04|
| Seguoiadendron giganteum | SEGI   |  1.02|  1.02|   1.02|    1.01|
| Tsuga mertensiana        | TSME   |  1.04|  1.02|   1.02|    1.00|
| All Species              | ALLSPP |  1.03|  1.02|   1.02|    1.02|
| Other                    | OTHER  |  1.03|  1.02|   1.02|    1.02|

A propotion-BA-weighted average of SEC is generated in the same way as QMD above.

### SG (specific gravity)

Note that van Wagtendonk et al. found that "species was not significant for the 7.62+cm (3+ in) rotten fuels." and that the average specific gravity for rotten fuels was .36, which is here included as a value.

| species                  | spp    |   x1h|  x10h|  x100h|  x1000s|
|:-------------------------|:-------|-----:|-----:|------:|-------:|
| Abies concolor           | ABCO   |  0.53|  0.54|   0.57|    0.32|
| Abies magnifica          | ABMA   |  0.57|  0.56|   0.47|    0.38|
| Calocedrus decurrens     | CADE   |  0.59|  0.54|   0.55|    0.41|
| Juniperus occidentalis   | JUOC   |  0.67|  0.65|   0.62|    0.47|
| Pinus albicaulis         | PIAL   |  0.55|  0.49|   0.48|    0.42|
| Pinus attenuata          | PIAT   |  0.59|  0.55|   0.39|    0.47|
| Pinus balfouriana        | PIBA   |  0.59|  0.61|   0.53|    0.47|
| Pinus contorta           | PICO   |  0.53|  0.48|   0.54|    0.58|
| Pinus flexilis           | PIFL   |  0.57|  0.57|   0.54|    0.63|
| Pinus jeffreyi           | PIJE   |  0.53|  0.55|   0.55|    0.47|
| Pinus lambertiana        | PILA   |  0.59|  0.59|   0.52|    0.43|
| Pinus monophylla         | PIMO1  |  0.65|  0.64|   0.53|    0.47|
| Pinus monticola          | PIMO2  |  0.56|  0.56|   0.49|    0.47|
| Pinus ponderosa          | PIPO   |  0.55|  0.56|   0.48|    0.40|
| Pinus sabiniana          | PISA   |  0.64|  0.61|   0.43|    0.47|
| Pinus washoensis         | PIWA   |  0.53|  0.52|   0.44|    0.35|
| Pseudotsuga menziesii    | PSME   |  0.60|  0.61|   0.59|    0.35|
| Seguoiadendron giganteum | SEGI   |  0.57|  0.57|   0.56|    0.54|
| Tsuga mertensiana        | TSME   |  0.67|  0.65|   0.62|    0.66|
| All Species              | ALLSPP |  0.58|  0.57|   0.53|    0.47|
| Other                    | OTHER  |  0.58|  0.57|   0.53|    0.47|

A propotion-BA-weighted average of SEC is generated in the same way as QMD above.

### SLP (slope correction factor)

*SLP* varies by the plot location and transect azimuth, ![SLP = c = \\sqrt{1+(\\frac{percentslope}{100})^2}](https://latex.codecogs.com/png.latex?SLP%20%3D%20c%20%3D%20%5Csqrt%7B1%2B%28%5Cfrac%7Bpercentslope%7D%7B100%7D%29%5E2%7D "SLP = c = \sqrt{1+(\frac{percentslope}{100})^2}") per Brown 1974. This is a simple adjustment for the influence of slope on transect length.

### length

*length* is the length of the sampling transect, and varies by the sampling protocol (which may vary from year-to-year) and the timelag class.

### n

*n* is the number of intersections of the given timeclass in the plane of the transect.

Coarse Woody Debris: 1000-hour fuels
------------------------------------

Brown (1974) gives:

![W\_{1000h} = \\frac{11.64\*\\sum{d^2}\*s\*a\*c}{N\*l}](https://latex.codecogs.com/png.latex?W_%7B1000h%7D%20%3D%20%5Cfrac%7B11.64%2A%5Csum%7Bd%5E2%7D%2As%2Aa%2Ac%7D%7BN%2Al%7D "W_{1000h} = \frac{11.64*\sum{d^2}*s*a*c}{N*l}")

and notes:

> "For material 3 inches and larger, square the diameter of each intersected piece and sum the squared values (![\\sum{d^2}](https://latex.codecogs.com/png.latex?%5Csum%7Bd%5E2%7D "\sum{d^2}")) for all pieces in the sampled area. Compute ![\\sum{d^2}](https://latex.codecogs.com/png.latex?%5Csum%7Bd%5E2%7D "\sum{d^2}") separately for sound and rotten categories. To obtain weights or volumes for certain diameter ranges (3 to 9 inches, for example), compute ![\\sum{d^2}](https://latex.codecogs.com/png.latex?%5Csum%7Bd%5E2%7D "\sum{d^2}") for the specified range."

This equation is just a special case of the equations given above for 1-100 hour fuels. 11.64 is a unit conversion factor for US units (*const* as above), *s* is the specific gravity of the fuel (*SG* as above), *a* is a value for the secant angle (*SEC* as above), and *c* is the slope correction factor (*SLP* as above). *N* is the number of transects represented in the calculation, and is assumed to be 1 in this method. *l* is the transect length, as described above.

The difference is that instead of counted intercepts and an average squared quadratic mean diameter, we have the actual sum of squared diameters from the measurements directly.

For sound 1000-hour fuels, we can substitute the BA-weighted-average for a specific transect's overstory and re-arrange the equation:

![W\_{1000S} = (\\sum{d^2})\*(\\frac{const\*SLP}{length})\*\\sum\_{spp}{(\\frac{BA\_{spp}}{BA\_{total}})\*SEC\_{spp,1000s})}\*(\\sum\_{spp}{(\\frac{BA\_{spp}}{BA\_{total}})\*SG\_{spp,1000s}})](https://latex.codecogs.com/png.latex?W_%7B1000S%7D%20%3D%20%28%5Csum%7Bd%5E2%7D%29%2A%28%5Cfrac%7Bconst%2ASLP%7D%7Blength%7D%29%2A%5Csum_%7Bspp%7D%7B%28%5Cfrac%7BBA_%7Bspp%7D%7D%7BBA_%7Btotal%7D%7D%29%2ASEC_%7Bspp%2C1000s%7D%29%7D%2A%28%5Csum_%7Bspp%7D%7B%28%5Cfrac%7BBA_%7Bspp%7D%7D%7BBA_%7Btotal%7D%7D%29%2ASG_%7Bspp%2C1000s%7D%7D%29 "W_{1000S} = (\sum{d^2})*(\frac{const*SLP}{length})*\sum_{spp}{(\frac{BA_{spp}}{BA_{total}})*SEC_{spp,1000s})}*(\sum_{spp}{(\frac{BA_{spp}}{BA_{total}})*SG_{spp,1000s}})")

van Wagtendonk 1998 give species-specific values for QMD, SEC, and SG, for both 1000-hour sound and 1000-hour rotten fuels.

Users who have diameter measurements for 1000-hour fuels (which is a standard sampling protocol) have actual diameter measurements, and don't need the by-species QMD averages from Van Wagtendonk et al. (1996).

Van Wagtendonk et al. (1996) do not discuss sound vs. rotten 1000-hour fuels, stating only that "The average secant of the acute angle to the horizontal for the 7.62+ cm (3+in) size class for all species was 2.67 (Table 6)." However, actually referring to table six gives very different data, with by-species averages recorded and varying from 1.00 to 1.06, with an average of 1.02. I believe the text is in error (2.67 bears no resemblance to the data given in the table, but it is 7.62 reversed.)

For SG, "The average specific gravity for rotten fuels was .36." and "species was not significant for the 7.62+ cm (3+ in) rotten fuels." Specific gravities by species for sound 1000-hour fuels are given in Van Wagtendonk et al. (1996), Table 8.

References
==========

-   Brown, J. K. *Handbook for Inventorying Downed Woody Material.* USDA For. Serv. Gen. Tech. Rep. 24 (1974). <https://www.fs.usda.gov/treesearch/pubs/28647>

-   Stephens, S. L. *Fire history differences in adjacent Jeffrey pine and upper montane forests in the eastern Sierra Nevada.* Int. J. Wildl. Fire 10, 161–167 (2001). <https://doi.org/10.1071/WF01008>

-   Stephens, S. L. & Moghaddas, J. J. *Experimental fuel treatment impacts on forest structure, potential fire behavior, and predicted tree mortality in a California mixed conifer forest.* For. Ecol. Manage. 215, 21–36 (2005). <https://doi.org/10.1016/j.foreco.2005.03.070>

-   Stephens, S. L., Collins, B. M. & Roller, G. *Fuel treatment longevity in a Sierra Nevada mixed conifer forest.* For. Ecol. Manage. 285, 204–212 (2012). <https://doi.org/10.1016/j.foreco.2012.08.030>

-   Van Wagner, C. E. *Practical aspects of the line intersect method.* Forestry 18 (1982). <http://www.cfs.nrcan.gc.ca/pubwarehouse/pdfs/6862.pdf>

-   Van Wagtendonk, J. W., Benedict, J. M. & Sydoriak, W. M. *Physical properties of woody fuel particles of Sierra Nevada conifers.* Int. J. Wildl. Fire 6, 117–123 (1996). <https://doi.org/10.1071/WF9960117>

-   Van Wagtendonk, J. W., Benedict, J. M. & Sydoriak, W. M. *Fuel bed characteristics of Sierra Nevada conifers.* West. J. Appl. For. 13, 73–84 (1998). <https://doi.org/10.1093/wjaf/13.3.73>
