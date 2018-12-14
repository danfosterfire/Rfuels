context('Test that functions catch and reject bad input data')


# good inputs  -----------------------------------------------------------------

# build valid vectors for testing
good_plot_ids = c('a1','b1', 'a2', 'b2')
good_inv_dates = c('01/01/2001','01/01/2005','01/01/2010','01/01/2018')
good_azimuths = c(100, 145, 210, 355)
good_x1h_length_ms = c(1.83, 1.83, 1.83, 2)
good_x10h_length_ms = c(1.83, 1.83, 1.83, 2)
good_x100h_length_ms = c(3.05, 3.05, 3.05, 3)
good_x1000h_length_ms = c(11.83, 11.83, 15.3, 11.3)
good_duff_depth_cms = c(0, 3, 5, 1)
good_litter_depth_cms = c(12.1, 5.3, 10.3335, 1)
good_count_x1hs = c(0, 10, 22, 3)
good_count_x10hs = c(5, 7, 2, 1)
good_count_x100hs = c(1, 5, 3, 0)
good_sum_d2_1000s_cm2s = c(0, 225, 65.61, 373)
good_sum_d2_1000r_cm2s = c(81, 277, 292.04, 0)
good_slope_percents = c(4, 0, 55, 300)
good_specieses = c('PSME', 'ABCO', 'ABCO', 'CADE')
good_dbh_cms = c(4, 11.4, 3.55, 37.9)

testthat::test_that('Correctly-formatted data frames pass all tests',{

  good_fuels =
    data.frame(plot_id = good_plot_ids,
               inv_date = good_inv_dates,
               azimuth = good_azimuths,
               x1h_length_m = good_x1h_length_ms,
               x10h_length_m = good_x10h_length_ms,
               x100h_length_m = good_x100h_length_ms,
               x1000h_length_m = good_x1000h_length_ms,
               count_x1h = good_count_x1hs,
               count_x10h = good_count_x10hs,
               count_x100h = good_count_x100hs,
               duff_depth_cm = good_duff_depth_cms,
               litter_depth_cm = good_litter_depth_cms,
               sum_d2_1000r_cm2 = good_sum_d2_1000r_cm2s,
               sum_d2_1000s_cm2 = good_sum_d2_1000s_cm2s)

  good_fuels_with_slope =
    data.frame(plot_id = good_plot_ids,
               inv_date = good_inv_dates,
               azimuth = good_azimuths,
               x1h_length_m = good_x1h_length_ms,
               x10h_length_m = good_x10h_length_ms,
               x100h_length_m = good_x100h_length_ms,
               x1000h_length_m = good_x1000h_length_ms,
               count_x1h = good_count_x1hs,
               count_x10h = good_count_x10hs,
               count_x100h = good_count_x100hs,
               duff_depth_cm = good_duff_depth_cms,
               litter_depth_cm = good_litter_depth_cms,
               sum_d2_1000r_cm2 = good_sum_d2_1000r_cm2s,
               sum_d2_1000s_cm2 = good_sum_d2_1000s_cm2s,
               slope_percent = good_slope_percents)

  good_trees =
    data.frame(plot_id = good_plot_ids,
               inv_date = good_inv_dates,
               species = good_specieses,
               dbh_cm = good_dbh_cms)

  testthat::expect_is(validate_fuels(good_fuels), 'data.frame')
  testthat::expect_is(validate_fuels(good_fuels_with_slope), 'data.frame')
  testthat::expect_is(validate_treelist(good_trees), 'data.frame')

})


# unmached plot_ids and/or inv dates  ------------------------------------------

## mismatching inv_date and/or plotIDs
mismatch_inv_date = c('01/01/2001','01/01/2005','06/10/2012','01/01/2018')
mismatch_plot_id = c('a1','b1', 'c3', 'c4')

testthat::test_that('Unmatched plot_ids and/or inv_dates are flagged', {

  # this actually tests estimate_fuel_loads()
  mismatch_plot_ids_fuels =
    data.frame(plot_id = mismatch_plot_id,
               inv_date = good_inv_dates,
               azimuth = good_azimuths,
               x1h_length_m = good_x1h_length_ms,
               x10h_length_m = good_x10h_length_ms,
               x100h_length_m = good_x100h_length_ms,
               x1000h_length_m = good_x1000h_length_ms,
               count_x1h = good_count_x1hs,
               count_x10h = good_count_x10hs,
               count_x100h = good_count_x100hs,
               duff_depth_cm = good_duff_depth_cms,
               litter_depth_cm = good_litter_depth_cms,
               sum_d2_1000r_cm2 = good_sum_d2_1000r_cm2s,
               sum_d2_1000s_cm2 = good_sum_d2_1000s_cm2s)

  mismatch_plot_ids_trees =
    data.frame(plot_id = good_plot_ids,
               inv_date = good_inv_dates,
               species = good_specieses,
               dbh_cm = good_dbh_cms)

  mismatch_inv_date_fuels =
    data.frame(plot_id = good_plot_ids,
               inv_date = good_inv_dates,
               azimuth = good_azimuths,
               x1h_length_m = good_x1h_length_ms,
               x10h_length_m = good_x10h_length_ms,
               x100h_length_m = good_x100h_length_ms,
               x1000h_length_m = good_x1000h_length_ms,
               count_x1h = good_count_x1hs,
               count_x10h = good_count_x10hs,
               count_x100h = good_count_x100hs,
               duff_depth_cm = good_duff_depth_cms,
               litter_depth_cm = good_litter_depth_cms,
               sum_d2_1000r_cm2 = good_sum_d2_1000r_cm2s,
               sum_d2_1000s_cm2 = good_sum_d2_1000s_cm2s)

  mismatch_inv_date_trees =
    data.frame(plot_id = good_plot_ids,
               inv_date = mismatch_inv_date,
               species = good_specieses,
               dbh_cm = good_dbh_cms)

  testthat::expect_error(estimate_fuel_loads(fuels_data =
                                                 mismatch_plot_ids_fuels,
                                               trees_data =
                                                 mismatch_plot_ids_trees,
                                               results_type = 'results_only'))

  testthat::expect_error(estimate_fuel_loads(fuels_data =
                                                 mismatch_inv_date_fuels,
                                               trees_data =
                                                 mismatch_inv_date_trees,
                                               results_type = 'results_only'))

})

# Unrecognized species ---------------------------------------------------------

unrecognized_species = c('baobab', 'ginko', 'PPPO', 'i<3trees')
integer_species = c(1, 4, 5, 1)

testthat::test_that('Unrecognized species generate a warning',{

  weird_species_trees =
    data.frame(plot_id = good_plot_ids,
               inv_date = good_inv_dates,
               species = unrecognized_species,
               dbh_cm = good_dbh_cms)

  integer_species_trees =
    data.frame(plot_id = good_plot_ids,
               inv_date = good_inv_dates,
               species = integer_species,
               dbh_cm = good_dbh_cms)

  testthat::expect_warning(validate_treelist(weird_species_trees))
  testthat::expect_warning(validate_treelist(integer_species_trees))

})

# NA handling ------------------------------------------------------------------

## vectors with some NAs
nas_plot_ids = c('a1','b1', 'a2', NA)
nas_count_x1hs = c(0, 10, 22, NA)
nas_specieses = c(NA, 'ABCO', 'ABCO', 'CADE')


testthat::test_that('NA handling works', {

  fail_fuels =
    data.frame(plot_id = nas_plot_ids,  # has an NA
               inv_date = good_inv_dates,
               azimuth = good_azimuths,
               x1h_length_m = good_x1h_length_ms,
               x10h_length_m = good_x10h_length_ms,
               x100h_length_m = good_x100h_length_ms,
               x1000h_length_m = good_x1000h_length_ms,
               count_x1h = good_count_x1hs,
               count_x10h = good_count_x10hs,
               count_x100h = good_count_x100hs,
               duff_depth_cm = good_duff_depth_cms,
               litter_depth_cm = good_litter_depth_cms,
               sum_d2_1000r_cm2 = good_sum_d2_1000r_cm2s,
               sum_d2_1000s_cm2 = good_sum_d2_1000s_cm2s)

  warn_fuels =
    data.frame(plot_id = good_plot_ids,
               inv_date = good_inv_dates,
               azimuth = good_azimuths,
               x1h_length_m = good_x1h_length_ms,
               x10h_length_m = good_x10h_length_ms,
               x100h_length_m = good_x100h_length_ms,
               x1000h_length_m = good_x1000h_length_ms,
               count_x1h = nas_count_x1hs,             # has an NA
               count_x10h = good_count_x10hs,
               count_x100h = good_count_x100hs,
               duff_depth_cm = good_duff_depth_cms,
               litter_depth_cm = good_litter_depth_cms,
               sum_d2_1000r_cm2 = good_sum_d2_1000r_cm2s,
               sum_d2_1000s_cm2 = good_sum_d2_1000s_cm2s)

  fail_trees =
    data.frame(plot_id = good_plot_ids,
               inv_date = good_inv_dates,
               species = nas_specieses,
               dbh_cm = good_dbh_cms)

  testthat::expect_warning(validate_fuels(warn_fuels))
  testthat::expect_error(validate_fuels(fail_fuels))
  testthat::expect_error(validate_trees(fail_trees))

})

# Negative Values Handling -----------------------------------------------------

negative_litter_depth_cms = c(-1, 0, 5.5, 6)
negative_dbh_cms = c(-10, 5, 16, 100)

testthat::test_that('Negatives handling works', {

  fail_fuels =
    data.frame(plot_id = good_plot_ids,
               inv_date = good_inv_dates,
               azimuth = good_azimuths,
               x1h_length_m = good_x1h_length_ms,
               x10h_length_m = good_x10h_length_ms,
               x100h_length_m = good_x100h_length_ms,
               x1000h_length_m = good_x1000h_length_ms,
               count_x1h = good_count_x1hs,
               count_x10h = good_count_x10hs,
               count_x100h = good_count_x100hs,
               duff_depth_cm = good_duff_depth_cms,
               litter_depth_cm = negative_litter_depth_cms, # is negative
               sum_d2_1000r_cm2 = good_sum_d2_1000r_cm2s,
               sum_d2_1000s_cm2 = good_sum_d2_1000s_cm2s)

  fail_trees =
    data.frame(plot_id = good_plot_ids,
               inv_date = good_inv_dates,
               species = good_specieses,
               dbh_cm = negative_dbh_cms) # is negative

  testthat::expect_error(validate_fuels(fail_fuels))
  testthat::expect_error(validate_trees(fail_trees))

})

# Characters handling ----------------------------------------------------------

azimuths_with_character = c('a', 100, 145, 201)
character_percent_slopes = c(100, 'alpha', 33, 55)
character_dbh_cms = c(1, 0, 'five', 7.3)

testthat::test_that('Characters handling works', {

  fail_fuels =
    data.frame(plot_id = good_plot_ids,
               inv_date = good_inv_dates,
               azimuth = azimuths_with_character, # includes a string
               x1h_length_m = good_x1h_length_ms,
               x10h_length_m = good_x10h_length_ms,
               x100h_length_m = good_x100h_length_ms,
               x1000h_length_m = good_x1000h_length_ms,
               count_x1h = good_count_x1hs,
               count_x10h = good_count_x10hs,
               count_x100h = good_count_x100hs,
               duff_depth_cm = good_duff_depth_cms,
               litter_depth_cm = good_litter_depth_cms,
               sum_d2_1000r_cm2 = good_sum_d2_1000r_cm2s,
               sum_d2_1000s_cm2 = good_sum_d2_1000s_cm2s)

  warn_fuels =
    data.frame(plot_id = good_plot_ids,
               inv_date = good_inv_dates,
               azimuth = good_azimuths,
               x1h_length_m = good_x1h_length_ms,
               x10h_length_m = good_x10h_length_ms,
               x100h_length_m = good_x100h_length_ms,
               x1000h_length_m = good_x1000h_length_ms,
               count_x1h = good_count_x1hs,
               count_x10h = good_count_x10hs,
               count_x100h = good_count_x100hs,
               duff_depth_cm = good_duff_depth_cms,
               litter_depth_cm = good_litter_depth_cms,
               sum_d2_1000r_cm2 = good_sum_d2_1000r_cm2s,
               sum_d2_1000s_cm2 = good_sum_d2_1000s_cm2s,
               slope_percent = character_percent_slopes) # includes a string

  fail_trees =
    data.frame(plot_id = good_plot_ids,
               inv_date = good_inv_dates,
               species = good_specieses,
               dbh_cm = character_dbh_cms)   # includes a string

  testthat::expect_error(validate_fuels(fail_fuels))
  testthat::expect_warning(validate_fuels(warn_fuels))
  testthat::expect_error(validate_trees(fail_trees))

})

# Range Handling ---------------------------------------------------------------

zero_x100h_length_ms = c(0, 1.83, 1.83, 2)
azimuths_over_359 = c(100, 145, 370, 360)

testthat::test_that('Range handling works', {

  fail_fuels_zero =
    data.frame(plot_id = good_plot_ids,
               inv_date = good_inv_dates,
               azimuth = good_azimuths,
               x1h_length_m = good_x1h_length_ms,
               x10h_length_m = good_x10h_length_ms,
               x100h_length_m = zero_x100h_length_ms, #includes a zero
               x1000h_length_m = good_x1000h_length_ms,
               count_x1h = good_count_x1hs,
               count_x10h = good_count_x10hs,
               count_x100h = good_count_x100hs,
               duff_depth_cm = good_duff_depth_cms,
               litter_depth_cm = good_litter_depth_cms,
               sum_d2_1000r_cm2 = good_sum_d2_1000r_cm2s,
               sum_d2_1000s_cm2 = good_sum_d2_1000s_cm2s)

  fail_fuels_az =
    data.frame(plot_id = good_plot_ids,
               inv_date = good_inv_dates,
               azimuth = azimuths_over_359,
               x1h_length_m = good_x1h_length_ms,
               x10h_length_m = good_x10h_length_ms,
               x100h_length_m = good_x100h_length_ms,
               x1000h_length_m = good_x1000h_length_ms,
               count_x1h = good_count_x1hs,
               count_x10h = good_count_x10hs,
               count_x100h = good_count_x100hs,
               duff_depth_cm = good_duff_depth_cms,
               litter_depth_cm = good_litter_depth_cms,
               sum_d2_1000r_cm2 = good_sum_d2_1000r_cm2s,
               sum_d2_1000s_cm2 = good_sum_d2_1000s_cm2s)

  testthat::expect_error(validate_fuels(fail_fuels_zero))
  testthat::expect_error(validate_fuels(fail_fuels_az))

})

# Date handling ----------------------------------------------------------------

testthat::test_that('Date handling works', {

  inv_date_dashes = c('01-01-2001', '01-05-2005', '01-01-2010', '01-01-1999')
  inv_date_reversed = c('2001/01/01', '2005/01/05', '2010/01/01', '1999/01/01')
  inv_date_y2k = c('01/01/01', '01/05/05', '01/01/10', '01/01/99')

  fail_fuels_dashes =
    data.frame(plot_id = good_plot_ids,
               inv_date = inv_date_dashes,
               azimuth = good_azimuths,
               x1h_length_m = good_x1h_length_ms,
               x10h_length_m = good_x10h_length_ms,
               x100h_length_m = good_x100h_length_ms,
               x1000h_length_m = good_x1000h_length_ms,
               count_x1h = good_count_x1hs,
               count_x10h = good_count_x10hs,
               count_x100h = good_count_x100hs,
               duff_depth_cm = good_duff_depth_cms,
               litter_depth_cm = good_litter_depth_cms,
               sum_d2_1000r_cm2 = good_sum_d2_1000r_cm2s,
               sum_d2_1000s_cm2 = good_sum_d2_1000s_cm2s)

  fail_fuels_reversed =
    data.frame(plot_id = good_plot_ids,
               inv_date = inv_date_reversed,
               azimuth = good_azimuths,
               x1h_length_m = good_x1h_length_ms,
               x10h_length_m = good_x10h_length_ms,
               x100h_length_m = good_x100h_length_ms,
               x1000h_length_m = good_x1000h_length_ms,
               count_x1h = good_count_x1hs,
               count_x10h = good_count_x10hs,
               count_x100h = good_count_x100hs,
               duff_depth_cm = good_duff_depth_cms,
               litter_depth_cm = good_litter_depth_cms,
               sum_d2_1000r_cm2 = good_sum_d2_1000r_cm2s,
               sum_d2_1000s_cm2 = good_sum_d2_1000s_cm2s)

  fail_fuels_y2k =
    data.frame(plot_id = good_plot_ids,
               inv_date = inv_date_dashes,
               azimuth = good_azimuths,
               x1h_length_m = good_x1h_length_ms,
               x10h_length_m = good_x10h_length_ms,
               x100h_length_m = good_x100h_length_ms,
               x1000h_length_m = good_x1000h_length_ms,
               count_x1h = good_count_x1hs,
               count_x10h = good_count_x10hs,
               count_x100h = good_count_x100hs,
               duff_depth_cm = good_duff_depth_cms,
               litter_depth_cm = good_litter_depth_cms,
               sum_d2_1000r_cm2 = good_sum_d2_1000r_cm2s,
               sum_d2_1000s_cm2 = good_sum_d2_1000s_cm2s)


  testthat::expect_error(validate_fuels(fail_fuels_dashes))
  testthat::expect_error(validate_fuels(fail_fuels_reversed))
  testthat::expect_error(validate_fuels(fail_fuels_y2k))

})



