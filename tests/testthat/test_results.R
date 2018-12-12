context("Test results")

testthat::test_that('Package and spreadsheet methods agree',{

  # use this package to estimate fuel loads using the example data
  results_from_package =
    estimate_fuel_loads(fuels_location =
                          system.file('extdata','example_fuels.csv',
                                      package = 'Rfuels'),
                        treelist_location =
                          system.file('extdata','example_treelist.csv',
                                      package = 'Rfuels'),
                        results_type = 'full')

  # load the fuel load estimates from the same example data; these were
  # generated using Moghaddas's spreadsheet method
  results_by_hand =
    read.csv(file = system.file('extdata','validated_example_data.csv',
                                package = 'Rfuels'),
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

  testthat::expect_equal(results_from_package[,'fuelload_litter_Mgha'],
                         results_by_hand[, 'fuelload_litter_Mgha'])

  testthat::expect_equal(results_from_package[,'fuelload_duff_Mgha'],
                         results_by_hand[, 'fuelload_duff_Mgha'])

  testthat::expect_equal(results_from_package[,'fuelload_1h_Mgha'],
                         results_by_hand[, 'fuelload_1h_Mgha'])

  testthat::expect_equal(results_from_package[,'fuelload_10h_Mgha'],
                         results_by_hand[, 'fuelload_10h_Mgha'])

  testthat::expect_equal(results_from_package[,'fuelload_100h_Mgha'],
                         results_by_hand[, 'fuelload_100h_Mgha'])

  testthat::expect_equal(results_from_package[,'fuelload_1000s_Mgha'],
                         results_by_hand[, 'fuelload_1000s_Mgha'])

  testthat::expect_equal(results_from_package[,'fuelload_1000r_Mgha'],
                         results_by_hand[, 'fuelload_1000r_Mgha'])


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


