context("Test results")

# use this package to estimate fuel loads using the example data
results_from_package =
  estimate_fuel_loads(fuels_location =
                        here::here('inst/extdata/example_fuels.csv'),
                      treelist_location =
                        here::here('inst/extdata/example_treelist.csv'),
                      results_type = 'full')

# load the fuel load estimates from the same example data; these were
# generated using Moghaddas's spreadsheet method
results_by_hand =
  read.csv(file = here::here('tests/validated_example_data.csv'),
           stringsAsFactors = TRUE)

# apply a common sorting to the datasets
results_from_package =
  results_from_package[with(results_from_package,
                            order(results_from_package$plot_id,
                                  results_from_package$inv_date,
                                  results_from_package$azimuth)), ]

results_by_hand =
  results_by_hand[with(results_by_hand,
                       order(results_by_hand$plot_id,
                             results_by_hand$inv_date,
                             results_by_hand$azimuth)),]

# compare the results from the package with the by-hand results; they should
# be the same
testthat::test_that('litter and duff estimates are correct', {

  testthat::expect_equal(results_from_package[,'fuelload_litter_Mgha'],
                         results_by_hand[, 'fuelload_litter_Mgha'])

  testthat::expect_equal(results_from_package[,'fuelload_duff_Mgha'],
                         results_by_hand[, 'fuelload_duff_Mgha'])

})

testthat::test_that('1h, 10h, and 100h estimates are correct', {

  testthat::expect_equal(results_from_package[,'fuelload_1h_Mgha'],
                         results_by_hand[, 'fuelload_1h_Mgha'])

  testthat::expect_equal(results_from_package[,'fuelload_10h_Mgha'],
                         results_by_hand[, 'fuelload_10h_Mgha'])

  testthat::expect_equal(results_from_package[,'fuelload_100h_Mgha'],
                         results_by_hand[, 'fuelload_100h_Mgha'])
})

testthat::test_that('1000s and 1000r estimates are correct', {

  testthat::expect_equal(results_from_package[,'fuelload_1000s_Mgha'],
                         results_by_hand[, 'fuelload_1000s_Mgha'])

  testthat::expect_equal(results_from_package[,'fuelload_1000r_Mgha'],
                         results_by_hand[, 'fuelload_1000r_Mgha'])
})

testthat::test_that('Aggregate estimates are correct', {

  testthat::expect_equal(results_from_package[,'fuelload_1000h_Mgha'],
                         (results_by_hand[, 'fuelload_1000s_Mgha']+
                            results_by_hand[,'fuelload_1000r_Mgha']))

  testthat::expect_equal(results_from_package[,'fuelload_total_Mgha'],
                         (results_by_hand[, 'fuelload_litter_Mgha']+
                            results_by_hand[,'fuelload_duff_Mgha']+
                            results_by_hand[,'fuelload_1h_Mgha']+
                            results_by_hand[,'fuelload_10h_Mgha']+
                            results_by_hand[,'fuelload_100h_Mgha']+
                            results_by_hand[,'fuelload_1000s_Mgha']+
                            results_by_hand[,'fuelload_1000r_Mgha']))

  testthat::expect_equal(results_from_package[,'fuelload_surface_Mgha'],
                         (results_by_hand[, 'fuelload_litter_Mgha']+
                            results_by_hand[,'fuelload_1h_Mgha']+
                            results_by_hand[,'fuelload_10h_Mgha']+
                            results_by_hand[,'fuelload_100h_Mgha']+
                            results_by_hand[,'fuelload_1000s_Mgha']+
                            results_by_hand[,'fuelload_1000r_Mgha']))
})
