# idk man
source(here::here('R/validate_inputs.R'))
source(here::here('R/calc_fuels_coeffs.R'))


# load the vw constants tables
load(here::here('data/kvals.rda'))
load(here::here('data/litterduff_coeffs.rda'))
load(here::here('data/QMDcm.rda'))
load(here::here('data/SEC.rda'))
load(here::here('data/SG.rda'))
load(here::here('data/species_codes.rda'))

test_fuels = import_fuels(here::here('example_fuels.csv'))

test_trees = import_treelist(here::here('example_treelist.csv'))

test_overstory = aggregate_treelist(test_trees)

test_dataset =
  merge(x = test_overstory,
        y = test_fuels,
        by = c('plot_id', 'inv_date'),
        all.y = TRUE)

test_species =
  get_spp_codes(test_overstory)


test_litter_coeffs =
  get_litterduff_coeffs(dataset = test_dataset,
                        species_list = test_species,
                        fuel_type = 'litter_coeff')

test_litter_coeffs

test_duff_coeffs =
  get_litterduff_coeffs(dataset = test_dataset,
                        species_list = test_species,
                        fuel_type = 'duff_coeff')

head(test_duff_coeffs)

test_x1h_coeffs =
  get_fwd_coeffs(dataset = test_dataset,
                 species_list = test_species,
                 timelag_class = 'x1h')

head(test_x1h_coeffs)

test_x10h_coeffs =
  get_fwd_coeffs(dataset = test_dataset,
                 species_list = test_species,
                 timelag_class = 'x10h')

head(test_x10h_coeffs)

test_x100h_coeffs =
  get_fwd_coeffs(dataset = test_dataset,
                 species_list = test_species,
                 timelag_class = 'x100h')

head(test_x100h_coeffs)

test_x1000s_coeffs =
  get_1000h_coeffs(dataset = test_dataset,
                 species_list = test_species,
                 type = 'sound')

head(test_x1000s_coeffs)


test_x1000r_coeffs =
  get_1000h_coeffs(dataset = test_dataset,
                   species_list = test_species,
                   type = 'rotten')

head(test_x1000r_coeffs)

head(test_dataset)

test_entire = estimate_fuel_loads(fuels_location = here::here('example_fuels.csv'),
                                  treelist_location = here::here('example_treelist.csv'),
                                  results_type = 'full')

help(import_fuels)
