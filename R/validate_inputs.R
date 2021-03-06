# Validate Fuels Data ------------------------------------------------------------

#' Validate fuels data
#'
#' Load, validate, and prepare fuels data. This function checks a data frame
#' containing the observations from the Brown's transects. We test whether
#' all necessary columns are present and labeled correctly, and return a
#' properly-typed tidy data frame with the observed data.
#'
#'The source data frame must have a row for each Brown's transect, and
#'at least these columns:
#' \describe{
#'   \item{plot_id}{Plot ids must be unique plot identifiers. (E.g.,
#'   if you have a nested study design with "stand A plot 1" and "stand B plot
#'   1", use "A-1" and "B-1" as PlotIDs.) There may be multiple inventory dates per
#'   plot_id, or multiple transects sharing a plot_id.}
#'
#'   \item{inv_date}{The date of measurement, in mm/dd/YYYY format.
#'   There must be a 1:1 match between the dates of fuels measurements and
#'   dates of trees data.}
#'
#'   \item{azimuth}{Integer in the range 0-359 (inclusive) giving the
#'   azimuth from plot center for the transect. Identifier for individual
#'   transects within plots. Must be unique within a (plot_id:inv_date). Will
#'   be coerced to character.}
#'
#'   \item{x1h_length_m, x10h_length_m, x100h_length_m, x1000h_length_m}{Numeric(s)
#'   greater than 0. The length (in meters) of the sampling transects for 1-hour,
#'   10-hour, 100-hour, and 1000-hour fuels, respectively.
#'   Transect lengths may vary by plot_id
#'   and/or year, for example if sampling protocols changed over time or
#'   called to extend 1000-hour transects until at least one intersection was
#'   found.}
#'
#'   \item{count_x1h, count_x10h, count_x100h}{Integers greater than or
#'   equal to 0. Transect counts of the number of intersections for 1-, 10-,
#'   and 100-hour fuels, respectively.}
#'
#'   \item{duff_depth and litter_depth}{Numeric greater than 0.
#'   Average depth of duff / litter (in cm) on the transect. Users with multiple
#'   measurements per transect of litter and/or duff should average them
#'   together before import. Depths must be recorded in cm.}
#'
#'   \item{sum_d2_1000r_cm2 and sum_d2_1000s_cm2}{The sum-of-squared-diameters
#'   for 1000-hour fuels on the transect, for rotten and sound fuels
#'   respectively. Users must aggregate their large fuels (1000-hour) into
#'   sound or rotten classes, and sum the squared diameters (in cm) for all
#'   1000-s or 1000-r intersections on the transect.}
#' }
#'
#' Additionally, the .csv file may have a column for 'slope_percent', the
#' slope (in percent) along the transect. Brown's equations include the
#' option to correct for the slope effect on horizontal length of transects.
#' Keep in mind that this correction factor applies to the transect slope,
#' not the plot slope. If a slope_percent is not supplied, we set the slope
#' correction factor to 1 (no slope).
#'
#' @param fuels_data A tidy data frame containing the observations
#' from the Brown's transects for surface fuels. Must meet the requirements
#' described above.
#'
#' @return A tidy dataframe with the observed fuels data. This is primarily
#' a validation function - the format and meaning of the data frame should
#' match that of the import file.
#'
#'
validate_fuels =

  function(fuels_data){

    # test that all columns are present
    test_fuels_all_columns(fuels_data)

    # test that transect counts and azimuths are whole numbers (within 0.0001)
    test_whole_numbers(fuels_data)

    # test for inappropriate negative values
    test_fuels_negatives(fuels_data)

    # test that the azimuth is in the range 0:359 (inclusive)
    test_azimuth_range(fuels_data)

    # test that the transect lengths are greater than 0
    test_transect_lengths_range(fuels_data)

    # coerce column classes; this should throw errors for a variety of issues
    # including unwanted 'character' values and ill-formatted dates
    fuels_data[,'plot_id'] =
      factor(as.character(fuels_data[,'plot_id']))
    fuels_data[,'inv_date'] =
      as.Date(fuels_data[,'inv_date'], '%m/%d/%Y')
    fuels_data[,'azimuth'] =
      as.integer(as.character(fuels_data[,'azimuth']))
    fuels_data[,'x1h_length_m'] =
      as.numeric(as.character(fuels_data[,'x1h_length_m']))
    fuels_data[,'x10h_length_m'] =
      as.numeric(as.character(fuels_data[,'x10h_length_m']))
    fuels_data[,'x100h_length_m'] =
      as.numeric(as.character(fuels_data[,'x100h_length_m']))
    fuels_data[,'x1000h_length_m'] =
      as.numeric(as.character(fuels_data[,'x1000h_length_m']))
    fuels_data[,'count_x1h'] =
      as.integer(as.character(fuels_data[,'count_x1h']))
    fuels_data[,'count_x10h'] =
      as.integer(as.character(fuels_data[,'count_x10h']))
    fuels_data[,'count_x100h'] =
      as.integer(as.character(fuels_data[,'count_x100h']))
    fuels_data[,'duff_depth_cm'] =
      as.numeric(as.character(fuels_data[,'duff_depth_cm']))
    fuels_data[,'litter_depth_cm'] =
      as.numeric(as.character(fuels_data[,'litter_depth_cm']))
    fuels_data[,'sum_d2_1000r_cm2'] =
      as.numeric(as.character(fuels_data[,'sum_d2_1000r_cm2']))
    fuels_data[,'sum_d2_1000s_cm2'] =
      as.numeric(as.character(fuels_data[,'sum_d2_1000s_cm2']))

    # check for a slope column
    if (is.element('slope_percent', names(fuels_data))) {

      # if there is a slope column,
      ## first validate it
      if (any(fuels_data[, 'slope_percent'] < 0, na.rm = TRUE)){

        stop('Problem with slope_percent; clean up fuels data.')
      }

      fuels_data[, 'slope_percent'] =
        as.numeric(as.character(fuels_data[,'slope_percent']))

      # make slp_c (the correction factor) based on the slope
      fuels_data[,'slp_c'] = sqrt(1+((fuels_data[,'slope_percent']/100)^2))

    } else {

      # if there is not a slope column, we set slp_c to 1
      fuels_data[,'slp_c'] = 1

    }

    # test for NA values; NAs are allowable (with a warning) in some columns
    test_fuels_NAs(fuels_data)

    # return the data frame
    return(fuels_data)

  }


# Validate Treelist --------------------------------------------------------

#' Validate treelist
#'
#' Load, validate, and prepare a treelist for each plot. This function checks
#' that the treelist dataframe is properly formatted, and returns a
#' properly-typed tidy data frame with a row for each individual tree, and
#' columns for relevant identifiers or measurements.
#'
#' The treelist dataframe must have a row for each observation of each
#' individual tree, and at least these columns:
#' \describe{
#'   \item{plot_id}{Plot ids must be unique plot identifiers. (E.g.,
#'   if you have a nested study design with "stand A plot 1" and "stand B plot
#'   1", use "A1" and "B1" as PlotIDs.) There may be multiple inventory dates per
#'   plot_id, or multiple transects sharing a plot_id. There will likely be
#'   multiple trees per plot_id (that is, multiple rows will share a single
#'   plot_id.)}
#'
#'   \item{inv_date}{The date of measurement, in mm/dd/YYYY format.
#'   There must be a 1:1 match between the dates of fuels measurements and
#'   dates of trees data. (plot_id:inv_date) must uniquely identify a
#'   sampling event in both the fuels and the trees data.}
#'
#'   \item{species}{A species identifier code for the individual tree.
#'   Generally follows 4-letter scientific abbreviation format (e.g. Abies
#'   concolor is "ABCO", not "WF", "White fir", "Abies_concolor", etc.).
#'   Compare your species codes to those included in the Van Wagtendonk
#'   constant tables (try "species_codes" in console) to ensure correct
#'   matching. Note that singleleaf pinyon (Pinus monophylla) and western
#'   white pine (Pinus monticola) would share the code "PIMO" - these should
#'   be labeled "PIMO1" and "PIMO2", respectively.}
#'
#'   \item{dbh_cm}{The diameter at breast height (4.5', 1.37m) of the tree in
#'   centimeters.}
#' }
#'
#' @param trees_data A tidy dataframe with the treelist (as described above).
#'
#' @return A tidy dataframe with the treelist. This is primarily
#' a validation function - the format and meaning of the data frame should
#' match that of the import dataframe.
#'
validate_treelist =

  function(trees_data){

    # check that all important columns are present
    test_trees_all_columns(trees_data)

    # check that there aren't NAs in important columns
    test_trees_NAs(trees_data)

    # check that there are no negative DBHs
    test_trees_negatives(trees_data)

    # for now, coerce species to a character because we may modify it
    trees_data[,'species'] = as.character(trees_data[,'species'])

    # check for any unrecognized species codes; if found, map them to 'OTHER'
    # and throw a warning
    if (!all(is.element(trees_data[,'species'],
                        species_codes[,'species_code']))){

      unrecognized_codes =
        paste0(unique(trees_data[!is.element(trees_data$species,
                               species_codes[,'species_code']), 'species']),
               sep = '  ')

      # throw a warning
      warning('Not all species codes were recognized. Unrecognized codes were
    converted to "OTHER" and will receive generic coefficients. Try
    "help(validate_treelist)" for more info.

    Unrecognized codes:  ', unrecognized_codes,'\n')

      # map the unrecognized species to 'OTHER'
      trees_data[!is.element(trees_data$species,
                             species_codes[,'species_code']), 'species'] =
        'OTHER'

    }

    # coerce column classes; this should throw an error if there are incompatible
    # entries
    trees_data[,'plot_id'] =
      factor(as.character(trees_data[,'plot_id']))
    trees_data[,'inv_date'] =
      as.Date(trees_data[,'inv_date'], '%m/%d/%Y')
    trees_data[,'species'] =
      factor(as.character(trees_data[,'species']))
    trees_data[,'dbh_cm'] =
      as.numeric(as.character(trees_data[,'dbh_cm']))

    # return the data frame
    return(trees_data)

  }

# Aggregate Treelist to Plot-Level Overstory Data -----------------------------

#' Get Species Composition
#'
#' For calculating fuel loads, we want to know the species composition of the
#' local overstory. 'Local' means the overstory composition which is
#' representative of the actual composition of surface fuels on the plot.
#' Often, field data will include a treelist collected from the same plot
#' (at the same time) as the Brown's transects. We can use this treelist to
#' describe the species composition for each plot, and use the plot-specific
#' species composition numbers to estimate the fuel load. 'Plot' generally
#' means a sampling unit (e.g. a 0.04-ha sampling plot), but users could
#' use stand-level overstory data by feeding a stand identifier into the
#' plot_id field (as long as fuels data have the same set of stand
#' identifiers). We express species as the proportion of total basal area
#' occupied by each species.
#'
#' @param treelist A treelist - a tidy dataframe with a row for each observation
#' of an individual tree (a single tree may have multiple rows if a plot was
#' visited more than once), and columns for plot_id, inv_date, species, and
#' dbh_cm. See "help(validate_treelist)" for more details.
#'
#' @return A tidy data frame with a row for each observation of a sampling
#' location (a unique combination of plot_id and inv_date), and columns for
#' the proportion of basal area occupied by each species in the dataset for
#' each observation. The proportion of plot basal area occupied by all species
#' ('pBA_(all)') should always be equal to 1.
#'
aggregate_treelist =

  function(treelist){

    # calculate basal area (in square meters) represented by each individual
    # tree from the dbh_cm; 0.00007854 is ((pi/4) * (1m^2/10,000cm^2))
    treelist[,'ba_m2'] = 0.00007854*(treelist[,'dbh_cm']**2)

    # drop the dbh column
    treelist = treelist[,c('plot_id','inv_date','species','ba_m2')]

    # sum the basal area for each species within each observation
    # (plot_id:inv_date)
    overstory.long = stats::aggregate(data = treelist,
                               ba_m2 ~ species + plot_id + inv_date,
                               FUN = sum)

    # calculate the total basalarea for each observation
    overstory.all = stats::aggregate(data = treelist,
                              ba_m2 ~ plot_id + inv_date,
                              FUN = sum)

    # relabel the total basal area column to avoid confusion later
    overstory.all['ba_m2.all'] = overstory.all[,'ba_m2']

    # for each (species:plot_id:inv_date), add a column for the total
    # basal area (all species) on that plot_id:inv_date
    overstory.long =
      merge(x = overstory.long,
            y = overstory.all[,c('plot_id','inv_date','ba_m2.all')],
            by = c('plot_id','inv_date'))

    # get the proportion of total plot_id:inv_date basal area occupied by
    # each species in the observation
    overstory.long[,'pBA'] =
      overstory.long[,'ba_m2'] / overstory.long[,'ba_m2.all']

    # switch from long to wide format, so that we wind up with one row per
    # plot_id:inv_date, and columns for each species (and for all species)
    # the call to melt sets us up for informative column names after dcasting
    overstory.molten =
      reshape2::melt(data = overstory.long,
                     id.vars = c('plot_id','inv_date','species'),
                     measure.vars = c('pBA'))

    overstory.wide =
      reshape2::dcast(data = overstory.molten,
                      plot_id + inv_date ~ variable + species,
                      margins = c('species'),
                      fun.aggregate = sum)

    # if pBA_(all) is ever not equal to 1, throw a warning. We do round to 6
    # digits
    if (any(round(overstory.wide[,'pBA_(all)'], 6) != 1)) {
      warning('Proportional basal areas do not sum to 1! Check input treelist.')
    }

    # return the tidy overstory description
    return(overstory.wide)

  }


# Import Plot-Level Overstory Data ---------------------------------------------

# not currently implemented. At some point, would be nice to allow users to
# upload a wide overstory table like that returned by aggregate_treelist(). This
# would make it possible to estimate the overstory where actual tree-level data
# are not available, or run sensitivity tests on different overstory composition,
# etc.

# Validate Specific Columns ----------------------------------------------------

test_fuels_NAs = function(fuels_data){

  if (any(is.na(fuels_data[, c('plot_id', 'inv_date', 'azimuth')]))){

    stop('fuels data cannot have NA values for plot_id, inv_date, or azimuth')

  }

  if (any(is.na(fuels_data[, c('x1h_length_m', 'x10h_length_m',
                               'x100h_length_m', 'x1000h_length_m',
                               'count_x1h', 'count_x10h', 'count_x100h',
                               'duff_depth_cm', 'litter_depth_cm',
                               'sum_d2_1000r_cm2', 'sum_d2_1000s_cm2')]))){

    warning('some fuels data have NA values;
            not all load estimates will be calculated.')
  }

}

test_trees_NAs = function(trees_data){

  if (any(is.na(trees_data[, c('plot_id', 'inv_date', 'species', 'dbh_cm')]))){

    stop('trees data cannot have NA values for plot_id, inv_date, species,
    or dbh_cm')

  }

}

test_trees_negatives = function(trees_data){

  if (any(trees_data[, 'dbh_cm'] < 0, na.rm = TRUE)) {

    stop('trees cannot have negative DBH')

  }
}

test_fuels_negatives = function(fuels_data){

  if (any(fuels_data[, c('count_x1h', 'count_x10h', 'count_x100h',
                         'duff_depth_cm', 'litter_depth_cm',
                         'sum_d2_1000r_cm2', 'sum_d2_1000s_cm2')] < 0,
          na.rm = TRUE)) {

    stop('some fuels data have negative values recorded')

  }
}

test_whole_numbers = function(fuels_data){

  is.wholenumber = function(x){abs(x-round(x)) < 0.0001}

  if (any(!is.wholenumber(fuels_data[, c('count_x1h', 'count_x10h',
                                     'count_x100h', 'azimuth')]),
          na.rm = TRUE)){

    stop('count_x1h, count_x10h, count_x100h, and azimuth must be whole numbers')
  }
}

test_azimuth_range = function(fuels_data){

  if (any(fuels_data[, 'azimuth'] > 359, na.rm = TRUE) |
      any(fuels_data[, 'azimuth'] < 0, na.rm = TRUE)){

    stop('azimuths for fuels data must be between 0 and 359')
  }
}

test_transect_lengths_range = function(fuels_data){

  if (any(fuels_data[, c('x1h_length_m', 'x10h_length_m', 'x100h_length_m',
                          'x1000h_length_m')] <=0, na.rm = TRUE)) {

    stop('fuels transect lengths must greater than 0')

  }
}

test_fuels_all_columns = function(fuels_data){

  # these are the necessary columns
  necessary_columns =
    c('plot_id','inv_date','azimuth',
      'x1h_length_m', 'x10h_length_m', 'x100h_length_m', 'x1000h_length_m',
      'count_x1h', 'count_x10h','count_x100h',
      'duff_depth_cm','litter_depth_cm','sum_d2_1000r_cm2','sum_d2_1000s_cm2')

  # if the file doesn't have all the necessary columns, throw an error
  if (!all(is.element(necessary_columns, names(fuels_data)))) {

    stop('fuels_data is missing important columns! Try "help(validate_fuels)"
    for more information.')
  }
}

test_trees_all_columns = function(trees_data){

  # these are the necessary columns
  necessary_columns =
    c('plot_id','inv_date','species','dbh_cm')

  # if the file doesn't have all the necessary columns, throw an error
  if (!all(is.element(necessary_columns, names(trees_data)))){

    stop('trees_data is missing important columns! Try "help(validate_treelist)"
         for more information.')
  }
}
