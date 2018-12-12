# Regression coefficients for litter, Duff, and litter&Duff weight (kg m-2) as a function of depth in cm for the 19 Sierra Nevada conifers listed
# Each regression went through the origin, was based on 80 observations, and was significant at the 0.05 level
# Source: van Wagtendonk et al. 1998, table 7

vw98_spp = c("Douglas-fir","Foothill pine","Foxtail pine","Giant sequoia","Incense-cedar","Jeffrey pine","Knobcone pine","Limber pine","Lodgepole pine","Mountain hemlock","Ponderosa pine","Red fir","Singleleaf pinyon","Sugar pine","Washoe pine","Western juniper","Western white pine","White fir", "Whitebark pine","All species", "Unknown")

vw98_spp_code = c("PSME","PISA","PIBA", "SEGI", "CADE", "PIJE", "PIAT", "PIFL", "PICO", "TSME", "PIPO", "ABMA", "PIMO1", "PILA", "PIWA", "JUOC", "PIMO2", "ABCO", "PIAL", "ALLSPP", "OTHER")

vw98_Litter_coeff = c(0.864,0.111,0.886,0.990,1.276,0.358,0.339,0.889,0.951,1.102,0.276,0.530,0.906,0.304,0.600,0.832,0.542,1.050,0.540,0.363,0.363)

vw98_Duff_coeff = c(1.319,1.448,2.504,1.648,1.675,1.707,1.646,2.337,1.671,1.876,1.402,1.727,2.592,1.396,1.870,1.798,1.422,1.518,1.895,1.750, 1.750)

vw98_LitterDuff_coeff = c(1.295,1.220,2.360,1.632,1.664,1.496,1.274,2.255,1.612,1.848,1.233,1.722,2.478,1.189,1.719,1.763,1.485,1.572,1.802,1.624, 1.624)

litterduff_coeffs = data.frame(species=vw98_spp,spp=vw98_spp_code,litter_coeff=vw98_Litter_coeff,duff_coeff=vw98_Duff_coeff,litterduff_coeff=vw98_LitterDuff_coeff)




# Average squared quadratic mean diameter (cm-2) by fuel size class (cm) for 19 Sierra Nevada conifers
# Source: van Wagtendonk et al. 1996, table 3

# This table has been slightly modified from the original: The original table does not give values for 1000h fuels
# of Pinus balfouriana, Pinus Monticola, and Pinus sabiniana, instead providing "NA" in those spaces.
# To increase flexibility, I have substituted the "all species" average of 127.24 for those species.

vw96_spp = c("Abies concolor","Abies magnifica","Calocedrus decurrens","Juniperus occidentalis","Pinus albicaulis","Pinus attenuata","Pinus balfouriana","Pinus contorta","Pinus flexilis","Pinus jeffreyi","Pinus lambertiana","Pinus monophylla","Pinus monticola","Pinus ponderosa","Pinus sabiniana","Pinus washoensis","Pseudotsuga menziesii","Seguoiadendron giganteum","Tsuga mertensiana","All Species", "Other")

vw96_spp_code = c("ABCO", "ABMA", "CADE", "JUOC", "PIAL", "PIAT", "PIBA", "PICO", "PIFL", "PIJE", "PILA", "PIMO1", "PIMO2", "PIPO", "PISA", "PIWA", "PSME", "SEGI", "TSME", "ALLSPP", "OTHER")

vw96_qmd_1h = c(0.08,0.10,0.09,0.08,0.13,0.10,0.12,0.10,0.21,0.15,0.12,0.09,0.08,0.23,0.14,0.22,0.06,0.14,0.05,0.12, 0.12)

vw96_qmd_10h = c(1.32,1.32,1.23,1.61,1.21,1.25,0.92,1.44,1.28,1.25,1.46,1.41,0.79,1.56,0.94,1.37,1.37,1.28,1.46,1.28, 1.28)

vw96_qmd_100h = c(11.56,16.24,20.79,13.92,14.75,9.68,12.82,13.39,17.72,17.31,13.61,11.56,9.92,19.36,12.91,13.47,12.04,17.06,13.61,14.52, 14.52)

vw96_qmd_1000h = c(162.56,219.93,74.30,61.62,92.74,70.39,127.24,138.06,115.78,135.49,169.52,129.96,127.24,101.81,127.24,122.77,75.69,167.70,115.99,127.24, 127.24)

QMDcm = data.frame(species=vw96_spp,spp=vw96_spp_code,x1h=vw96_qmd_1h,x10h=vw96_qmd_10h,x100h=vw96_qmd_100h,x1000h=vw96_qmd_1000h)


# Average secant of acute angles of inclination of nonhorizontal particles by fuel size class (cm) for 19 Sierra Nevada conifers
# Source: van Wagtendonk et al. 1996, table 6. Note that these values contradict the statement in the text that "The average secant of the acute angle to the horizontal for the 7.62+cm (3+ in) size class for asll species was 2.67 (Table 6)." I believe this statement is a typo, and that the values in the table are correct (they are more consistent with Brown 1974).

# This table has been slightly modified from the original: NA values for 1000h secant of Pinus balfouriana, Pinus monticola, and Pinus sabiniana have been replaced with the "All Species" average of 1.02

vw96_sec_1h = c(1.03,1.03,1.02,1.03,1.02,1.03,1.02,1.02,1.02,1.03,1.04,1.02,1.03,1.02,1.05,1.02,1.03,1.02,1.04,1.03, 1.03)

vw96_sec_10h = c(1.02,1.02,1.02,1.04,1.02,1.02,1.02,1.02,1.02,1.03,1.04,1.01,1.02,1.03,1.03,1.02,1.02,1.02,1.02,1.02,1.02)

vw96_sec_100h = c(1.02,1.01,1.03,1.04,1.02,1.00,1.01,1.01,1.01,1.04,1.03,1.01,1.06,1.02,1.02,1.01,1.03,1.02,1.02,1.02,1.02)

vw96_sec_1000h = c(1.01,1.00,1.06,1.04,1.02,1.02,1.02,1.05,1.01,1.05,1.03,1.05,1.02,1.01,1.02,1.05,1.04,1.01,1.00,1.02,1.02)

SEC = data.frame(species=vw96_spp,spp=vw96_spp_code,x1h=vw96_sec_1h,x10h=vw96_sec_10h,x100h=vw96_sec_100h,x1000h=vw96_sec_1000h)


# Average specific gravity by fuel size class (cm) for 19 Sierra Nevada conifers
# Source: van Wagtendonk et al. 1996, table 8.
# This table has been slightly modified from the original: NA values for 100h fuels for Pinus balfouriana and Pinus monophylla, and NA values for 1000h fuels from Juniperus occidentalis, Pinus attenuata, Pinus balfouriana, Pinus monophylla, Pinus monticola, and Pinus sabiniana have been replaced with the "all species" averages for 100h and 1000h fuels, respectively

vw96_sg_1000r = 0.36

vw96_sg_1h = c(0.53,0.57,0.59,0.67,0.55,0.59,0.59,0.53,0.57,0.53,0.59,0.65,0.56,0.55,0.64,0.53,0.60,0.57,0.67,0.58,0.58)
vw96_sg_10h = c(0.54,0.56,0.54,0.65,0.49,0.55,0.61,0.48,0.57,0.55,0.59,0.64,0.56,0.56,0.61,0.52,0.61,0.57,0.65,0.57,0.57)
vw96_sg_100h = c(0.57,0.47,0.55,0.62,0.48,0.39,0.53,0.54,0.54,0.55,0.52,0.53,0.49,0.48,0.43,0.44,0.59,0.56,0.62,0.53,0.53)
vw96_sg_1000s = c(0.32,0.38,0.41,0.47,0.42,0.47,0.47,0.58,0.63,0.47,0.43,0.47,0.47,0.40,0.47,0.35,0.35,0.54,0.66,0.47,0.47)

SG = data.frame(species=vw96_spp,spp=vw96_spp_code,x1h=vw96_sg_1h,x10h=vw96_sg_10h,x100h=vw96_sg_100h,x1000s=vw96_sg_1000s)





# Unit conversion constants (k-values, aka "const") from Van Wagner 1982, table 1
kvals = data.frame(
  fuel_diam = c("cm","cm","cm","cm","in","in","in","in"),
  transect_length = c("m","m","m","m","ft","ft","ft","ft"),
  volume_fuel_per_area = c("m^3^/m^2^","m^3^/ha",NA,NA,"ft^3^/ft^2^","ft^3^/ac",NA,NA),
  weight_fuel_per_area = c(NA,NA,"kg/m^2^","tons/ha",NA,NA,"lb/ft^2^","tons/ac"),
  k = c(0.0001234,1.234,0.1234,1.234,0.008567,373.3,0.5348,11.65)
)


# species mapping table for ease of use
species_codes =
  merge(x = data.frame(species_code = vw96_spp_code,
                       scientific_name = vw96_spp),
        y = data.frame(species_code = vw98_spp_code,
                       common_name = vw98_spp),
        all = TRUE)

# add these data objects to the package file structure
#usethis::use_data_raw()
usethis::use_data(kvals,
                  litterduff_coeffs,
                  QMDcm,
                  SEC,
                  SG,
                  species_codes,
                  overwrite = TRUE,
                  internal = TRUE)
