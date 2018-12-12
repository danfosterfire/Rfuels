#' Unit conversion constants.
#'
#' Unit conversion constants used by Brown's Transects equations (variable 'k'
#' or 'const' depending on the source). These constants are used
#' to translate between the various units possible for the inputs (fuel
#' diameters, transect lengths) and outputs (volume of fuel per area,
#' weight of fuel per area).
#'
#' @format A data frame with 5 columns and 8 rows:
#' \describe{
#'    \item{fuel_diam}{Whether the measurement data describe fuel diameters in
#'    inches or meters}
#'    \item{transect_length}{whether the measurement data describe the length of
#'    the sampling transects in feet or meters}
#'    \item{volume_fuel_per_area}{the desired output units for describing the
#'    volume of fuel per unit area (e.g. 'ft^3 / ac", "m^2 / ha", etc.)}
#'    \item{weight_fuel_per_area}{the desired output units for describing the
#'    weight of fuel per unit area (e.g. "kg / m^2", "tons / ac", etc.).
#'    "tons / ac" indicates the North American ton, ie 2,000 pounds. "Tons / ha"
#'    indicates metric tons, ie 1,000 kilograms.}
#'    \item{k}{Unitless conversion constant used to map from the input units
#'    associated with the measurements to the desired output units. For example,
#'    if fuel diameters are recorded in cm and transect lengths in meters, and
#'    we want to estimate the fuel load in metric tons per hectare, k = 1.234}
#'
#' }
#'
#' @source Values and table format are drawn from
#' Van Wagner (1982) "Practical Aspects of the Line Intercept Method" (Petawa
#' National Forestry Institute, Canadian Forestry Service; Chalk River, Ontario
#' Information Report PI-X-12).
#' \url{http://www.cfs.nrcan.gc.ca/pubwarehouse/pdfs/6862.pdf}
#'
"kvals"

#' Litter and Duff Coefficients
#'
#' Regression coefficients for litter, Duff, and litter&Duff weight (kg/m^2) as
#' a function of fuelbed depth (cm) for the 19 Sierra Nevada conifers listed.
#' Fuels were collected from 4 pure stands of each of the 22 species listed to
#' fit the regressions. Each regression went through the origin, was based on 80
#' observations, and was significant at the 0.05 level.
#'
#' @format A dataframe with 5 columns and 21 rows:
#' \describe{
#'   \item{species}{Common names of the Sierran conifer species included in the
#'   study}
#'   \item{spp}{Abbreviated species codes for each species, commonly a 4-letter
#'   code constructed from the first two names of the genus and the first two
#'   letters of the specific epithet. These codes are used by Rfuels functions
#'   and should be used to describe overstory composition in users' input
#'   data.}
#'   \item{litter_coeff}{The fitted coefficient for litter weight (kg / m^2)
#'   as a function of litter depth (cm) for each tree species.}
#'   \item{duff_coeff}{The fitted coefficient for duff weight (kg / m^2)
#'   as a function of duff depth (cm) for each tree species.}
#'   \item{litterduff_coeff}{The fitted coefficient for litter and duff
#'   combined weight (kg / m^2) as a function of the combined depth of the
#'   litter and duff layers (cm) for each tree species. Note that fuelbed
#'   weights predicted by the "litter and duff" coefficient are NOT equal to
#'   the summed predictions for litter and duff individually.}
#' }
#'
#' @source Table 7, Van Wagtendonk, Benedict, and Sydoriak (1998) West. J. Appl.
#' For. 13(3):73-84 \url{https://academic.oup.com/wjaf/article/13/3/73/4663215}
"litterduff_coeffs"

#' Average squared quadratic mean diameter (QMD^2) by fuel size class for 19
#' Sierra Nevada conifers
#'
#' When using Brown's Transects, fine woody fuels are recorded as tallies
#' of the number of fuel particales (sticks) crossing a sampling transect. Fine
#' woody fuels are stratified into size classes of 0-0.64cm (1-hour fuels),
#' 0.64-2.54cm (10-hour fuels), 2.54-7.62cm (100-hour fuels), and 7.62+ cm
#' (1000-hour fuels). (These "timelag classifications" are related to the amount
#' of time for fuels of each size to gain or lose moisture in response to changes
#' in the relative humidity of the surrounding air - smaller fuels will respond
#' more quickly to changes in the moisture of the surrounding environment.)
#' Van Wagtendonk et al. (1996) sampled fuels from pure stands of each tree
#' species, and recorded summary statistics for each species and timelag
#' class. From the paper: "Diameter was calculated for each fuel particle by
#' averaging two perpendicular measurements made at the point the particle
#' intersected with the sampling plane. Squared quadratic mean diameter
#' was calculated by squaring each particle's average diameter and taking the
#' average of the sum for each stand and size class."
#'
#' @format A dataframe with 6 columns and 21 rows:
#' \describe{
#'   \item{Species}{The latin name of each of the 19 conifer species included
#'   in the study.}
#'   \item{spp}{Abbreviated species codes for each species, commonly a 4-letter
#'   code constructed from the first two names of the genus and the first two
#'   letters of the specific epithet. These codes are used by Rfuels functions
#'   and should be used to describe overstory composition in users' input
#'   data.}
#'   \item{x1h}{The average squared quadratic mean diameter (in cm^2) of a
#'   1-hour fuel (a woody particle between 0cm and 0.64cm in diameter at the
#'   point of intersection with the sampling transect) for each species.}
#'   \item{x10h}{The average squared quadratic mean diameter (in cm^2) of a
#'   10-hour fuel (a woody particle between 0.64cm and 2.54cm in diameter
#'   at the point of intersection with the sampling transect) for each species.}
#'   \item{x100h}{The average squared quadratic mean diameter (in cm^2) of a
#'   100-hour fuel (a woody particle between 2.54cm and 7.62cm in diameter at
#'   the point of intersection with the sampling transect) for each species.}
#'   \item{x1000h}{The average squared quadratic mean diameter (in cm^2) of a
#'   1000-hour fuel (a woody particle greater than 7.62cm in diameter at the
#'   point of intersection with the sampling transect) for each species. Most
#'   sampling protocols call for direct measurement of the diameter for any
#'   1000-hour fuels intersecting the transect; where the actual diameter is
#'   known it is not necessary to rely on these average values.}
#'}
#'
#' @source van Wagtendonk, Benedict, and Sydoriak (1996) "Physical Properties of
#' Woody Fuel Particles of Sierra Nevada Conifers" (Int. J. Wildland Fire 6(3):
#' 117-123); Table 3. \url{https://doi.org/10.1071/WF9960117}
#'
"QMDcm"

#' Average secand of acute angles of inclination of nonhorizontal particles by
#' fuel size class for 19 Sierra Nevada conifers
#'
#' Brown's equations for estimating fuel loads from sampling transects call for
#' the "secant of acute angle," which accounts for the fact that most fuel
#' particles intersecting the transect do not lie exacatly horizontally when
#' estimating the volume (or weight) of fuels intersected by the transect. Van
#' Wagtendonk et al. report that "the acute angle that the intersected particle
#' formed with a horizontal plane was measured using a protractor level to the
#' nearest five degrees" and give average values for the secant of this angle
#' for each species and timelag class.
#'
#'@format A dataframe with 6 columns and 21 rows:
#' \describe{
#'   \item{Species}{The latin name of each of the 19 conifer species included
#'   in the study.}
#'   \item{spp}{Abbreviated species codes for each species, commonly a 4-letter
#'   code constructed from the first two names of the genus and the first two
#'   letters of the specific epithet. These codes are used by Rfuels functions
#'   and should be used to describe overstory composition in users' input
#'   data.}
#'   \item{x1h}{The average secant of actute angle of inclination of a
#'   1-hour fuel (a woody particle between 0cm and 0.64cm in diameter at the
#'   point of intersection with the sampling transect) for each species.}
#'   \item{x10h}{The average secant of actute angle of inclination of a
#'   10-hour fuel (a woody particle between 0.64cm and 2.54cm in diameter
#'   at the point of intersection with the sampling transect) for each species.}
#'   \item{x100h}{The average secant of actute angle of inclination of a
#'   100-hour fuel (a woody particle between 2.54cm and 7.62cm in diameter at
#'   the point of intersection with the sampling transect) for each species.}
#'   \item{x1000h}{The average secant of actute angle of inclination of a
#'   1000-hour fuel (a woody particle greater than 7.62cm in diameter at the
#'   point of intersection with the sampling transect) for each species.}
#'}
#'
#' @source van Wagtendonk, Benedict, and Sydoriak (1996) "Physical Properties of
#' Woody Fuel Particles of Sierra Nevada Conifers" (Int. J. Wildland Fire 6(3):
#' 117-123); Table 6. \url{https://doi.org/10.1071/WF9960117}
#'
"SEC"

#' Average secand of acute angles of inclination of nonhorizontal particles by
#' fuel size class for 19 Sierra Nevada conifers
#'
#' Brown's equations for estimating fuel loads from sampling transects call for
#' the specific gravity of the fuel particles. Van Wagtendonk et al. used a
#' Kraus Jolly specific gravity balance (comparing the weight of a sampling
#' in air to its weight immersed in water, sensu Eberbach 1979) to
#' determine the specific gravity of a subset of their woody fuel samples
#' for each species, and timelag class (with sound and rotten particles analyzed
#' separately).
#'
#'@format A dataframe with 6 columns and 21 rows:
#' \describe{
#'   \item{Species}{The latin name of each of the 19 conifer species included
#'   in the study.}
#'   \item{spp}{Abbreviated species codes for each species, commonly a 4-letter
#'   code constructed from the first two names of the genus and the first two
#'   letters of the specific epithet. These codes are used by Rfuels functions
#'   and should be used to describe overstory composition in users' input
#'   data.}
#'   \item{x1h}{The average specific gravity of a
#'   1-hour fuel (a woody particle between 0cm and 0.64cm in diameter at the
#'   point of intersection with the sampling transect) for each species.}
#'   \item{x10h}{The average specific gravity of a
#'   10-hour fuel (a woody particle between 0.64cm and 2.54cm in diameter
#'   at the point of intersection with the sampling transect) for each species.}
#'   \item{x100h}{The average specific gravity of a
#'   100-hour fuel (a woody particle between 2.54cm and 7.62cm in diameter at
#'   the point of intersection with the sampling transect) for each species.}
#'   \item{x1000h}{The average specific gravity of a
#'   1000-hour fuel (a woody particle greater than 7.62cm in diameter at the
#'   point of intersection with the sampling transect) for each species.}
#'}
#'
#' @source van Wagtendonk, Benedict, and Sydoriak (1996) "Physical Properties of
#' Woody Fuel Particles of Sierra Nevada Conifers" (Int. J. Wildland Fire 6(3):
#' 117-123); Table 8. \url{https://doi.org/10.1071/WF9960117}
#'
"SG"

