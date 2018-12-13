
# TOP LEVEL FUNCTION -----------------------------------------------------------

#' Estimate fuel loads
#'
#' A top-level wrapper function to estimate fuel loads from Brown's
#' transect data and a treelist describing the local
#' overstory for each observation. For details, see the vignette.
#'
#' @param fuels_location The full file path to the .csv file with the Brown's
#' transects data. See 'import_fuels()' for more info.
#'
#' @param treelist_location The full file path to the .csv file with the
#' treelist data. See 'import_treelist()' for more info.
#'
#' @param results_type Either 'full', 'results_only', or 'fuels_only'. Sets the
#' verbosity of the returned results dataframe. 'full' includes observation
#' ID information, all directly observed values, intermediate calculations,
#' overstory species composition, and the fuel load estimates.
#' 'results_only' returns the observation ID
#' information, the overstory species composition, and the fuel load estimates.
#' 'fuels_only' returns the observation ID information and the fuel load
#' estimates.
#'
#' @return A tidy data frame, with a row for each observation (where an
#' observation is a Brown's transect on a specific date), and columns for
#' the plot location (plot_id), the inventory date (inv_date), the transect
#' azimuth (azimuth), and the fuel load estimated for various subcategories
#' of surface and ground fuels (litter, duff, 1-hour, 10-hour, 100-hour, and
#' 1000-hour fuels). Users may opt to include columns for the directly observed
#' measurements, intermediate values, and the overstory species composition
#' using the parameter 'results_type'.
#'
#' @export
estimate_fuel_loads =

  function(fuels_location,
           treelist_location,
           results_type = 'results_only'){

    # script currently requires k = 1.234 (fuels in cm, transects in m, and
    # fuel loads in Mg / ha)
    k_value = 1.234

    # load and validate the input data
    fuels = import_fuels(file_path = fuels_location)
    trees = import_treelist(file_path = treelist_location)

    # make the pBA table for the overstory
    overstory = aggregate_treelist(treelist = trees)

    # merge fuels data nd overstory summary
    combined_data =
      merge(x = overstory,
            y = fuels,
            by = c('plot_id', 'inv_date'),
            all.y = TRUE) # we may have multiple fuels transects per plot_id

    # get the list of tree species included in the dataset
    species_present = get_spp_codes(overstory)

    # calculate fuels coefficients based on the overstory species composition
    combined_data[,'litter_coeff'] =
      get_litterduff_coeffs(dataset = combined_data,
                            species_list = species_present,
                            fuel_type = 'litter_coeff')

    combined_data[,'duff_coeff'] =
      get_litterduff_coeffs(dataset = combined_data,
                            species_list = species_present,
                            fuel_type = 'duff_coeff')

    combined_data[,'x1h_coeff'] =
      get_fwd_coeffs(dataset = combined_data,
                     species_list = species_present,
                     timelag_class = 'x1h')

    combined_data[,'x10h_coeff'] =
      get_fwd_coeffs(dataset = combined_data,
                     species_list = species_present,
                     timelag_class = 'x10h')

    combined_data[,'x100h_coeff'] =
      get_fwd_coeffs(dataset = combined_data,
                     species_list = species_present,
                     timelag_class = 'x100h')

    combined_data[,'x1000s_coeff'] =
      get_1000h_coeffs(dataset = combined_data,
                       species_list = species_present,
                       type = 'sound')

    combined_data[,'x1000r_coeff'] =
      get_1000h_coeffs(dataset = combined_data,
                       species_list = species_present,
                       type = 'rotten')


    # calculate fuel loads
    combined_data[,'fuelload_litter_Mgha'] =
      estimate_litterduff_load(dataset = combined_data,
                               fuel_type = 'litter')

    combined_data[,'fuelload_duff_Mgha'] =
      estimate_litterduff_load(dataset = combined_data,
                               fuel_type = 'duff')

    combined_data[, 'fuelload_1h_Mgha'] =
      estimate_fwd_load(dataset = combined_data,
                        timelag_class = 'x1h',
                        k_value = k_value)

    combined_data[, 'fuelload_10h_Mgha'] =
      estimate_fwd_load(dataset = combined_data,
                        timelag_class = 'x10h',
                        k_value = k_value)

    combined_data[, 'fuelload_100h_Mgha'] =
      estimate_fwd_load(dataset = combined_data,
                        timelag_class = 'x100h',
                        k_value = k_value)

    combined_data[, 'fuelload_1000s_Mgha'] =
      estimate_cwd_load(dataset = combined_data,
                        type = 'sound',
                        k_value = k_value)

    combined_data[, 'fuelload_1000r_Mgha'] =
      estimate_cwd_load(dataset = combined_data,
                        type = 'rotten',
                        k_value = k_value)

    # make columns for common aggregate fuel load categories
    combined_data[, 'fuelload_fwd_Mgha'] =
      combined_data[, 'fuelload_1h_Mgha'] +
      combined_data[, 'fuelload_10h_Mgha'] +
      combined_data[, 'fuelload_100h_Mgha']

    combined_data[, 'fuelload_1000h_Mgha'] =
      combined_data[, 'fuelload_1000s_Mgha'] +
      combined_data[, 'fuelload_1000r_Mgha']

    combined_data[, 'fuelload_surface_Mgha'] =
      combined_data[, 'fuelload_litter_Mgha'] +
      combined_data[, 'fuelload_fwd_Mgha'] +
      combined_data[, 'fuelload_1000h_Mgha']

    combined_data[, 'fuelload_total_Mgha'] =
      combined_data[, 'fuelload_litter_Mgha'] +
      combined_data[, 'fuelload_duff_Mgha'] +
      combined_data[, 'fuelload_fwd_Mgha'] +
      combined_data[, 'fuelload_1000h_Mgha']

    # return the fuel load estimates
    # if results_type == 'full', then return the whole table
    if (results_type == 'full'){

      message('Returning full results table with intermediate values')
      return(combined_data)

    } else if (results_type == 'fuels_only'){

      message('Returning results table with observation ID info and fuel loads')

      return(combined_data[, c('plot_id', 'inv_date', 'azimuth',
                               'fuelload_litter_Mgha', 'fuelload_duff_Mgha',
                               'fuelload_1h_Mgha', 'fuelload_10h_Mgha',
                               'fuelload_100h_Mgha', 'fuelload_1000s_Mgha',
                               'fuelload_1000r_Mgha', 'fuelload_1000h_Mgha',
                               'fuelload_fwd_Mgha', 'fuelload_surface_Mgha',
                               'fuelload_total_Mgha')])

    } else if (results_type == 'results_only'){

      message('Return results table with observation ID, fuel loads, and overstory info')

      to_drop = c('x1h_length_m', 'x10h_length_m', 'x100h_length_m', 'slp_c',
                  'x1000h_length_m', 'count_x1h', 'count_x10h', 'count_x100h',
                  'duff_depth_cm', 'litter_depth_cm', 'sum_d2_1000r_cm2',
                  'sum_d2_1000s_cm2', 'litter_coeff', 'duff_coeff',
                  'x1h_coeff', 'x10h_coeff', 'x100h_coeff', 'x1000s_coeff',
                  'x1000r_coeff')

      results_data = combined_data[, !(names(combined_data) %in% to_drop)]

      return(results_data)

    } else {

      message('Unrecognized results type requested - valid types are "full",
        "fuels_only", and "results_only". Returning results_only by default.')
      return(combined_data)

    }

  }


# litter and duff loads --------------------------------------------------------

#' Estimate litter and duff fuel loads
#'
#' Litter and duff are measured as depths at specific points along a sampling
#' transect. Van WAgtendonk et al. (1998) developed regressions for litter,
#' duff, and combined-litter-and-duff loading (kg / m^2) as a function of
#' depth (cm) for 19 different Sierra Nevada conifer species. See vignette
#' for details.
#'
#' @param dataset A tidy data frame with a row for each observation, and
#' columns for the observed litter or duff depth (in cm) and the observation-
#' specific coefficient between litter/duff depth and fuel load. The
#' observation-specific coefficient is given by get_litterduff_coeffs()
#'
#' @param fuel_type A string, either 'litter', or 'duff'.
#'
#' @return A numeric vector giving the estimated fuel loading (in Mg / ha) of
#' either litter or duff represented by the observed litter / duff depth on the
#' transect.
estimate_litterduff_load = function(dataset, fuel_type){

  # fuel_type must be either 'litter' or 'duff'
  if (!is.element(fuel_type, c('litter', 'duff'))){
    stop('fuel_type must be either "litter" or "duff"')
  }

  # load =
  #    litter/duff depth (cm) *
  #    litter/duff coefficient (kg / m2 load per cm depth) *
  #    10 (to convert from kg/m2 to Mg/ha)
  fuelload_Mgha =
    dataset[, paste0(fuel_type, '_depth_cm')] *
    dataset[, paste0(fuel_type, '_coeff')] *
    10

  # return the vector of litter fuel loads
  return(fuelload_Mgha)
}



# 1-h, 10-h, and 100-h loads ---------------------------------------------------

#' Estimate fine woody debris (1-hour, 10-hour, and 100-hour) fuel loads
#'
#' Fine woody debris is measured as tallies by timelag classification along
#' a transect. The timelag classifications are 1-hour (0 - 0.64cm diameter),
#' 10-hour (0.64 - 2.54 cm diameter), and 100-hour (2.54 - 7.62 cm diameter).
#' Van WAgtendonk et al. (1996) and Brown (1974) give equations to estimate
#' the fuel load (weight / area) represented by these tallies. For more details,
#' see the vignette.
#'
#' @param dataset A tidy data frame with a row for each observation, and
#' columns for the observed fine woody debris counts and the observation-
#' specific fuel coefficient. The
#' observation-specific coefficient is given by get_fwd_coeffs(), and
#' depends on the average quadratic mean diameter, secant of acute angle, and
#' specific gravity of the various species present in the overstory.
#'
#' @param timelag_class A string, either 'x1h', 'x10h', or 'x100h'. Describes
#' which columns to read and write.
#'
#' @param k_value Currentlly k_value must equalt 1.234. This is a
#' unit-conversion constant to relate the units of the observation data
#' (transect lengths, square centimeters of cross-sectional area per transect)
#' to the desired results units (metric tons per hectare). Brown's equations
#' allow for a variety of input and output unit types, with different k values
#' to translate between them. However, this code currently requires that all
#' input and output values be in metric - see import_fuels() for more details.
#'
#' @return A numeric vector giving the estimated fuel loading (in Mg / ha) of
#' the fine woody fuel represented by the tallied amount on the transect.
estimate_fwd_load = function(dataset, timelag_class, k_value){

  # timelag_class must be either 'x1h', 'x10h', or 'x100h'
  if (!is.element(timelag_class, c('x1h','x10h','x100h'))){
    stop('timelag_class must be either "x1h", "x10h", or "x100h"')
  }

  # load =
  #  (coefficient * number intersections * k_value * slope correction factor) /
  #  (transect length)
  # where 'coefficient' is the QMD * SEC * SG
  fuelload_Mgha =
    ((dataset[, paste0(timelag_class, '_coeff')] *
      dataset[, paste0('count_', timelag_class)] *
      k_value *
      dataset[, 'slp_c'])
    / (dataset[, paste0(timelag_class, '_length_m')]))

  # return the vector of fwd fuel loads
  return(fuelload_Mgha)
}


# 1000-hour loads --------------------------------------------------------------

#' Estimate coarse woody debris (1000-hour) fuel loads
#'
#' Coarse woody debris is measured by recording the diameter and decay class
#' of all 1000-hour fuels (7.62+ cm in diameter).
#' Van WAgtendonk et al. (1996) and Brown (1974) give equations to estimate
#' the fuel load (weight / area) represented by these data. For more details,
#' see the vignette.
#'
#' @param dataset A tidy data frame with a row for each observation, and
#' columns for the sum of squared diamters for all sound and rotten 1000-hour
#' fuels along the transect, and the observation-specific fuel coefficients. The
#' observation-specific coefficients are given by get_1000h_coeffs(), and
#' depend on the average secant of acute angle and
#' specific gravity of the various species present in the overstory. Because
#' the observed data include the sum of squared diameters of intersecting fuels,
#' we don't need to estimate the quadratic mean diameter of the 1000-hour fuels.
#'
#' @param type A string, either 'rotten' or 'sound' decribing which
#' values to read and write.
#'
#' @param k_value Currentlly k_value must equalt 1.234. This is a
#' unit-conversion constant to relate the units of the observation data
#' (transect lengths, square centimeters of cross-sectional area per transect)
#' to the desired results units (metric tons per hectare). Brown's equations
#' allow for a variety of input and output unit types, with different k values
#' to translate between them. However, this code currently requires that all
#' input and output values be in metric - see import_fuels() for more details.
#'
#' @return A numeric vector giving the estimated fuel loading (in Mg / ha) of
#' the coarse woody debris represented by the observed sum of squared
#' diameters on the transect.
estimate_cwd_load = function(dataset, type, k_value){

  # type must be either rotten or sound
  if (!is.element(type, c('rotten', 'sound'))){
    stop('type must be either "rotten" or "sound"')
  }

  # load = (coefficient * sum of squared dbhs * k_value * slope correction) /
  #        transect_length
  # where 'coefficient' = SEC * SG

  fuelload_Mgha =
    ((dataset[, paste0('x1000', substring(type, 1, 1), '_coeff')] *
      dataset[, paste0('sum_d2_1000', substring(type, 1, 1), '_cm2')] *
      k_value *
      dataset[, 'slp_c'])
     / dataset[, 'x1000h_length_m'])

  # return the vector of cwd fuel loads
  return(fuelload_Mgha)
}

