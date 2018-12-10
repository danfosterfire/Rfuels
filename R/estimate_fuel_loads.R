
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

    # calculate fuels coefficients

    # calculate fuel loads

    # return the fuel load estimates

  }
