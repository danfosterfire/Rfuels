
# TOP LEVEL FUNCTION -----------------------------------------------------------

# top-level function to estimate fuel loads from browns transect data
# and tree data
estimate_fuel_loads =

  function(fuels_location,
           treelist_location,
           results_type = 'full'){

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
        "fuels_only", and "results_only". Returning full results by default.')
      return(combined_data)

    }

  }


# litter and duff loads --------------------------------------------------------

estimate_litterduff_load = function(dataset, fuel_type){

  # fuel_type must be either 'litter' or 'duff'
  if (!is.element(fuel_type, c('litter', 'duff'))){
    error('fuel_type must be either "litter" or "duff"')
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

estimate_fwd_load = function(dataset, timelag_class, k_value){

  # timelag_class must be either 'x1h', 'x10h', or 'x100h'
  if (!is.element(timelag_class, c('x1h','x10h','x100h'))){
    error('timelag_class must be either "x1h", "x10h", or "x100h"')
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

estimate_cwd_load = function(dataset, type, k_value){

  # type must be either rotten or sound
  if (!is.element(type, c('rotten', 'sound'))){
    error('type must be either "rotten" or "sound"')
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

