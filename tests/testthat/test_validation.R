context('Test that functions catch and reject bad input data')

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

# build invalid vectors for testing

## vectors with some NAs
nas_plot_ids = c('a1','b1', 'a2', NA)
nas_inv_dates = c('01/01/2001',NA,'01/01/2010','01/01/2018')
nas_azimuths = c(100, 145, 210, NA)
nas_x1h_length_ms = c(1.83, 1.83, NA, 2)
nas_x10h_length_ms = c(1.83, NA, 1.83, 2)
nas_x100h_length_ms = c(NA, 3.05, 3.05, 3)
nas_x100h_length_ms = c(NA, 11.83, 15.3, 11.3)
nas_duff_depth_cms = c(0, 5, NA, 12.1)
nas_litter_depth_cms = c(12.1, NA, 10.3335, 1)
nas_count_x1hs = c(0, 10, 22, NA)
nas_count_x10hs = c(5, 7, NA, 1)
nas_count_x100hs = c(1, NA, 3, 0)
nas_sum_d2_1000s_cm2s = c(0, NA, 65.61, 373)
nas_sum_d2_1000r_cm2s = c(81, 277, NA, 0)
nas_slope_percents = c(0, NA, 99, 45)
nas_specieses = c(NA, 'ABCO', 'ABCO', 'CADE')
nas_dbh_cms = c(4, 11.4, 3.55, NA)


## azimuth issues
azimuths_with_numeric = c(100, 145, 210, 210.4)
azimuths_with_character = c('a', 100, 145, 201)
azimuths_over_359 = c(100, 145, 370, 360)
azimuths_under_0 = c(-5, 1, 350, 180)

# START HERE ------------------------------------------------------------------
# WORKING THROUGH THE VARIOUS POSSIBLE ISSUES, MAKING SURE THAT VALIDATE_INPUTS
# CATCHES THEM. MAKE A PROBLEMATIC DATAFRAME AND EXPECT_ERROR(), SEE BELOW

## transect length issues
zero_x1h_length_ms = c(0, 1.83, 1.83, 2)
zero_x10h_length_ms = c(0, 1.83, 1.83, 2)
zero_x100h_length_ms = c(0, 1.83, 1.83, 2)
zero_x1000h_length_ms = c(0, 1.83, 1.83, 2)

character_x1h_length_ms = c('a', 1.83, 1.83, 2)
character_x10h_length_ms = c('a', 1.83, 1.83, 2)
character_x100h_length_ms = c('a', 1.83, 1.83, 2)
character_x1000h_length_ms = c('a', 1.83, 1.83, 2)

## transect count issues
character_count_x1h = c('a', 1, 2, 4)
character_count_x10h = c('a', 1, 2, 4)
character_count_x100h = c('a', 1, 2, 4)
numeric_count_x1h = c('a', 1, 2, 4)
numeric_count_x10h = c('a', 1, 2, 4)
numeric_count_x100h = c('a', 1, 2, 4)

## duff and litter depth issues
negative_duff_depth_cms = c(-1, 0, 5.5, 6)
negative_litter_depth_cms = c(-1, 0, 5.5, 6)
character_duff_depth_cms = c(0, 1, 'b', 7)
character_litter_depth_cms = c(0, 1, 'abco', 9)

## sum of squared diameters issues
negative_sum_D2_1000s_cm2 = c(-1, 50, 1000, 225)
negative_sum_D2_1000r_cm2 = c(-1, 50, 1000, 225)
character_sum_D2_1000s_cm2 = c(100, 'a', 1000, 225)
character_sum_D2_1000r_cm2 = c(100, 'b', 1000, 225)

## slope percent issues
negative_percent_slopes = c(-3, 50.6, 100, 150)
character_percent_slopes = c(100, 'alpha', 33, 55)


## species issues
unrecognized_species = c('baobab', 'ginko', 'PPPO', 'i<3trees')
integer_species = c(1, 4, 5, 1)

## dbh_cm issues
negative_dbh_cms = c(-10, 5, 16, 100)
character_dbh_cms = c(10, 'a', 16, 100)

## inv_date issues
inv_date_dashes = c('01-01-2001', '01-05-2005', '01-01-2010', '01-01-1999')
inv_date_reversed = c('2001/01/01', '2005/01/05', '2010/01/01', '1999/01/01')
inv_date_y2k = c('01/01/01', '01/05/05', '01/01/10', '01/01/99')
inv_date_singles = c('1/1/2001', '1/5/2005', '1/1/2010', '1/1/1999')

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
