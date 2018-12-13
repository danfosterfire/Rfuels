context('Test that functions catch and reject bad input data')

# build valid vectors for testing
good_plot_ids = c('a1','b1', 'a2', 'b2')
good_inv_dates = c('01/01/2001','01/01/2005','01/01/2010','01/01/2018')
good_azimuths = c(100, 145, 210, 355)
good_x1h_length_ms = c(1.83, 1.83, 1.83, 2)
good_x10h_length_ms = c(1.83, 1.83, 1.83, 2)
good_x100h_length_ms = c(3.05, 3.05, 3.05, 3)
good_x100h_length_ms = c(11.83, 11.83, 15.3, 11.3)
good_duff_depth_cms = c(0, 5, 3.5, 12.1)
good_duff_depth_cms_int = c(0, 3, 5, 1)
good_litter_depth_cms = c(12.1, 5.3, 10.3335, 1)
good_count_x1hs = c(0, 10, 22, 3)
good_count_x10hs = c(5, 7, 2, 1)
good_count_x100hs = c(1, 5, 3, 0)
good_sum_d2_1000s_cm2s = c(0, 225, 65.61, 373)
good_sum_d2_1000r_cm2s = c(81, 277, 292.04, 0)

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
nas_specieses = c(NA, 'ABCO', 'ABCO', 'CADE')
nas_dbh_cms = c(4, 11.4, 3.55, NA)

## azimuth issues
azimuths_with_numeric = c(100, 145, 210, 210.4)
azimuths_with_character = c('a', 100, 145, 201)
azimuths_over_359 = c(100, 145, 370, 360)
azimuths_under_0 = c(-5, 1, 350, 180)

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



##
mixed_types_x1h_length_ms = c(1.83, 1.83, NA, 2)
mixed_types_x10h_length_ms = c(1.83, NA, 1.83, 2)
mixed_types_x100h_length_ms = c(NA, 3.05, 3.05, 3)
mixed_types_x100h_length_ms = c(NA, 11.83, 15.3, 11.3)
mixed_types_duff_depth_cms = c(0, 5, NA, 12.1)
mixed_types_litter_depth_cms = c(12.1, NA, 10.3335, 1)
mixed_types_count_x1hs = c(0, 10, 22, NA)
mixed_types_count_x10hs = c(5, 7, NA, 1)
mixed_types_count_x100hs = c(1, NA, 3, 0)
mixed_types_sum_d2_1000s_cm2s = c(0, NA, 65.61, 373)
mixed_types_sum_d2_1000r_cm2s = c(81, 277, NA, 0)
mixed_types_specieses = c(NA, 'ABCO', 'ABCO', 'CADE')
mixed_types_dbh_cms = c(4, 11.4, 3.55, NA)



testthat::test_that('Bad fuels data are rejected',{


})
