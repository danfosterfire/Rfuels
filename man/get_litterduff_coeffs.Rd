% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_fuels_coeffs.R
\name{get_litterduff_coeffs}
\alias{get_litterduff_coeffs}
\title{Calculate coefficients}
\usage{
get_litterduff_coeffs(dataset, species_list, fuel_type)
}
\arguments{
\item{dataset}{A tidy data table with a row for each observation (brown's
transect), and columns for the plot identifier ('plot_id'), the inventory
date ('inv_date'), the proportion of basal area occupied by each species
('pBA_species'), the azimuth for the Brown's transect ('azimuth'),
tallies for 1-hour, 10-hour, and 100-hour fuels ('count_1h', 'count_10h',
'count_100h'), transect-average litter and duff depths in centimeters
('duff_depth_cm' and 'litter_depth_cm'), and the sum-of-squared-diameters
for the rotten and sound 1000-hour fuels on the transect ('sum_d2_1000r_cm2'
and 'sum_d2_1000s_cm2').}

\item{species_list}{A characters vector giving the unique species codes
present in the dataset. Generated by calling get_spp_codes(dataset).}

\item{fuel_type}{A string, either 'duff_coeff' or 'litter_coeff', identifying
the targeted average coefficient.}
}
\value{
A weighted-average coefficient to predict litter or duff weight from
litter or duff depth for each observation, based on the overstory present
for that observation.
}
\description{
Van Wagtendonk et al. (1998) table 7 gives the fitted coefficients for a
linear relationship predicting measured fuelbed weight (kg / m^2) for
the litter and/or duff of 19 Sierra Nevada conifers as a function of
litter and/or duff depth (cm). Following Stephens et al. (2001), we
estimate the linear coefficient between litter/duff depth and litter/duff
fuelbed weight by taking the average of the coefficients for each
species present on the plot. The various coefficients  are weighted by the
proportion of total plot basal area occupied by each species. For more
details, see the vignette.
}
