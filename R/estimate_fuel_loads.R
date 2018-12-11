
# top-level function to estimate fuel loads from browns transect data
# and tree data
estimate_fuel_loads =

  function(fuels_location,
           treelist_location){

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
                            target = 'litter_coeff')

    combined_data[,'duff_coeff'] =
      get_litterduff_coeffs(dataset = combined_data,
                            species_list = species_present,
                            target = 'duff_coeff')

    combined_data[,'x1h_coeff'] =
      get_fwd_coeffs(dataset = combined_data,
                     species_list = species_present,
                     target = 'x1h')

    combined_data[,'x10h_coeff'] =
      get_fwd_coeffs(dataset = combined_data,
                     species_list = species_present,
                     target = 'x10h')

    combined_data[,'x100h_coeff'] =
      get_fwd_coeffs(dataset = combined_data,
                     species_list = species_present,
                     target = 'x100h')

    combined_data[,'x1000s_coeff'] =
      get_1000h_coeffs(dataset = combined_data,
                       species_list = species_present,
                       type = 'sound')

    combined_data[,'x1000r_coeff'] =
      get_1000h_coeffs(dataset = combined_data,
                       species_list = species_present,
                       type = 'rotten')


    # calculate fuel loads

    # return the fuel load estimates

  }
