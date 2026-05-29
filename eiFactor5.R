#####################################
# Loren Collingwood                 #
# Development of eiFactor5 Package  #
# Alpha Version 0.1                 #
# Spring Semester, 2023             #
#####################################

rm(list=ls())

# Packages #
library(tigris)
library(tidycensus)
library(haven)
library(reactable)
library(tidyverse)
library(writexl)
library(readr)
acs_factor5(vars = c("B01003_001","B03002_003"))
 
acs_factor5 <- function(vars, 
                        geography = "state",
                        year = 2020,
                        state){
  # Call ACS DAta #
  acs_state <- get_acs(geography = geography, 
                         variables = vars, 
                         year = year,
                         state = state,
                         output = "wide")
  
  acs_state <- acs_state %>%
    dplyr::mutate(
      
           tot_pop= B01003_001E,
           
           # Race/Ethnicity #
           nh_white= B03002_003E,
           nh_black= B03002_004E, 
           nh_asian = B03002_006E, 
           nh_pac_island = B03002_007E, 
           hispanic= B03002_012E, 
           nh_native = B03002_005,
           
           # Pct Race #
           pct_white = nh_white / tot_pop, 
           pct_black = nh_black /tot_pop, 
           pct_hispanic = hispanic / tot_pop,
           pct_aapi = (nh_asian + nh_pac_island) / tot_pop,
           pct_native = nh_native / tot_pop,
           
           # Median HH Income #
           med_hh_inc= B19013_001E, 
           med_hh_inc_white = B19013H_001E, 
           med_hh_inc_black = B19013B_001E, 
           med_hh_inc_hispanic = B19013I_001E, 
           med_hh_inc_aapi = B19013D_001 + B19013E_001,
           med_hh_inc_native = B19013C_001,
             
           # Household Income: 2020 #
           inc_total_households = B19001_001E, 
           inc_total_households_black = B19001B_001E, # Black
           inc_total_households_white = B19001H_001E, # White non-Hispanic
           inc_total_households_hispanic = B19001I_001E, # Hispanic or latino
           inc_total_households_aapi = B19001D_001 + B19001E_001E, # AAPI
           inc_total_households_native = B19001C_001, # Native
           
           # STOP HERE #
           hh_inc_total_white_100 =B19001H_014E, 
           hh_inc_total_white_125 =B19001H_015E, 
           hh_inc_total_white_150 =B19001H_016E, 
           hh_inc_total_white_200 = B19001H_017E, 
           hh_inc_total_black_100 = B19001B_014E, 
           hh_inc_total_black_125 = B19001B_015E, 
           hh_inc_total_black_150 = B19001B_016E, 
           hh_inc_total_black_200 = B19001B_017E, 
           pct_hh_inc_black_100p= (hh_inc_total_black_100 + hh_inc_total_black_125 + 
                                     hh_inc_total_black_150+ 
                                     hh_inc_total_black_200)/inc_total_households_black, 
           pct_hh_inc_black_125p= (hh_inc_total_black_125 + hh_inc_total_black_150+ 
                                     hh_inc_total_black_200)/inc_total_households_black, 
           pct_hh_inc_white_100p= (hh_inc_total_white_100 + hh_inc_total_white_125 + 
                                     hh_inc_total_white_150+ 
                                     hh_inc_total_white_200)/inc_total_households_white, 
           pct_hh_inc_white_125p= (hh_inc_total_white_125 + hh_inc_total_white_150+
                                     hh_inc_total_white_200)/inc_total_households_white, 
           
           # SNAP #
           snap_black= B22005B_002E, 
           snap_white= B22005H_002E, 
           pct_snap_black= snap_black/B22005B_001E, 
           pct_snap_white= snap_white/B22005H_001E,
           
           # Poverty Status 
           pct_black_below_poverty = B17001B_002E / B17001B_001E,
           pct_white_below_poverty = B17001H_002E / B17001H_001E,
           
           # Poverty Status Black Below 18 #
           black_below18_total = B17001B_004E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
             B17001B_005E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
             B17001B_006E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
             B17001B_007E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
             B17001B_008E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
             B17001B_009E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
             B17001B_033E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!Under 5 years
             B17001B_034E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!5 years
             B17001B_035E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!6 to 11 years
             B17001B_036E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!12 to 14 years
             B17001B_037E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!15 years
             B17001B_038E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!16 and 17 years
             B17001B_018E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
             B17001B_019E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
             B17001B_020E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
             B17001B_021E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
             B17001B_022E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
             B17001B_023E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
             B17001B_047E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!Under 5 years
             B17001B_048E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!5 years
             B17001B_049E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!6 to 11 years
             B17001B_050E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!12 to 14 years
             B17001B_051E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!15 years
             B17001B_052E,	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!16 and 17 years
           
           black_below18_poverty = B17001B_004E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
             B17001B_005E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
             B17001B_006E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
             B17001B_007E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
             B17001B_008E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
             B17001B_009E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
             B17001B_018E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
             B17001B_019E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
             B17001B_020E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
             B17001B_021E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
             B17001B_022E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
             B17001B_023E,	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
           
           pct_black_below_poverty_child = black_below18_poverty / black_below18_total,
           
           # Poverty Status Black Adults #
           black_above18_total = B17001B_010E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
             B17001B_011E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
             B17001B_012E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
             B17001B_013E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
             B17001B_014E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
             B17001B_015E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
             B17001B_016E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
             B17001B_039E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!18 to 24 years
             B17001B_040E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!25 to 34 years
             B17001B_041E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!35 to 44 years
             B17001B_042E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!45 to 54 years
             B17001B_043E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!55 to 64 years
             B17001B_044E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!65 to 74 years
             B17001B_045E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!75 years and over
             B17001B_024E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
             B17001B_025E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
             B17001B_026E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
             B17001B_027E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
             B17001B_028E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
             B17001B_029E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
             B17001B_030E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
             B17001B_053E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!18 to 24 years
             B17001B_054E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!25 to 34 years
             B17001B_055E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!35 to 44 years
             B17001B_056E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!45 to 54 years
             B17001B_057E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!55 to 64 years
             B17001B_058E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!65 to 74 years
             B17001B_059E,	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!75 years and over              
           
           black_above18_poverty = B17001B_010E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
             B17001B_011E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
             B17001B_012E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
             B17001B_013E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
             B17001B_014E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
             B17001B_015E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
             B17001B_016E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
             B17001B_024E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
             B17001B_025E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
             B17001B_026E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
             B17001B_027E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
             B17001B_028E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
             B17001B_029E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
             B17001B_030E,	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
           
           pct_black_below_poverty_adult = black_above18_poverty / black_above18_total,
           
           
           # Poverty Status White Below 18 #
           white_below18_total = B17001H_004E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
             B17001H_005E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
             B17001H_006E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
             B17001H_007E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
             B17001H_008E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
             B17001H_009E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
             B17001H_033E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!Under 5 years
             B17001H_034E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!5 years
             B17001H_035E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!6 to 11 years
             B17001H_036E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!12 to 14 years
             B17001H_037E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!15 years
             B17001H_038E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!16 and 17 years
             B17001H_018E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
             B17001H_019E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
             B17001H_020E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
             B17001H_021E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
             B17001H_022E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
             B17001H_023E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
             B17001H_047E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!Under 5 years
             B17001H_048E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!5 years
             B17001H_049E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!6 to 11 years
             B17001H_050E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!12 to 14 years
             B17001H_051E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!15 years
             B17001H_052E,	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!16 and 17 years
           
           white_below18_poverty = B17001H_004E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
             B17001H_005E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
             B17001H_006E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
             B17001H_007E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
             B17001H_008E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
             B17001H_009E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
             B17001H_018E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
             B17001H_019E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
             B17001H_020E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
             B17001H_021E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
             B17001H_022E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
             B17001H_023E,	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
           
           pct_white_below_poverty_child = white_below18_poverty / white_below18_total,
           
           # Poverty Status White Adults #
           white_above18_total = B17001H_010E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
             B17001H_011E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
             B17001H_012E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
             B17001H_013E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
             B17001H_014E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
             B17001H_015E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
             B17001H_016E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
             B17001H_039E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!18 to 24 years
             B17001H_040E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!25 to 34 years
             B17001H_041E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!35 to 44 years
             B17001H_042E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!45 to 54 years
             B17001H_043E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!55 to 64 years
             B17001H_044E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!65 to 74 years
             B17001H_045E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!75 years and over
             B17001H_024E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
             B17001H_025E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
             B17001H_026E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
             B17001H_027E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
             B17001H_028E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
             B17001H_029E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
             B17001H_030E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
             B17001H_053E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!18 to 24 years
             B17001H_054E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!25 to 34 years
             B17001H_055E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!35 to 44 years
             B17001H_056E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!45 to 54 years
             B17001H_057E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!55 to 64 years
             B17001H_058E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!65 to 74 years
             B17001H_059E,	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!75 years and over              
           
           white_above18_poverty = B17001H_010E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
             B17001H_011E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
             B17001H_012E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
             B17001H_013E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
             B17001H_014E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
             B17001H_015E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
             B17001H_016E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
             B17001H_024E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
             B17001H_025E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
             B17001H_026E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
             B17001H_027E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
             B17001H_028E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
             B17001H_029E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
             B17001H_030E,	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over  
           
           pct_white_below_poverty_adult = white_above18_poverty /white_above18_total,
           
           #Educational Attainment, Black #
           pct_educ_less_hs_black = (C15002B_003E + C15002B_008E)/C15002B_001E,
           pct_educ_bachelor_black= (C15002B_006E+ C15002B_011E)/C15002B_001E, 
           
           pct_educ_less_hs_white = (C15002H_003E + C15002H_008E)/C15002H_001E,
           pct_educ_bachelor_white= (C15002H_006E+ C15002H_011E)/C15002H_001E,
           
           #Civilian Employment in Labor Force, 16-64 Black
           civilian_empl_status_total_black= C23002B_006E+ C23002B_019E,
           pct_umemployed_black = (C23002B_008E+C23002B_021E)/civilian_empl_status_total_black,
           
           #Civilian Employment in Labor Force, 16-64 White
           civilian_empl_status_total_white= C23002H_006E+ C23002H_019E,
           pct_umemployed_white = (C23002H_008E+C23002H_021E)/civilian_empl_status_total_white,
           
           #Disabled, Ages 18-64 Black and White
           pct_disabled_black= B18101B_006E/B18101B_005E,
           pct_disabled_white= B18101H_006E/B18101H_005E, 
           
           #Uninsured Black and White (19-64)
           pct_uninsured_black_19_64 = C27001B_007E/C27001B_005E, 
           pct_uninsured_white_19_64 = C27001H_007E/C27001H_005E 
    ) %>% dplyr::select(pct_black, pct_white,
                 med_hh_inc_black, med_hh_inc_white,
                 pct_hh_inc_black_100p, pct_hh_inc_black_125p,
                 pct_hh_inc_white_100p, pct_hh_inc_white_125p, 
                 pct_snap_black, pct_snap_white, 
                 pct_black_below_poverty, pct_white_below_poverty, 
                 pct_black_below_poverty_child, pct_black_below_poverty_adult,
                 pct_white_below_poverty_child, pct_white_below_poverty_adult, 
                 pct_educ_less_hs_black, pct_educ_bachelor_black,
                 pct_educ_less_hs_white, pct_educ_bachelor_white, 
                 pct_umemployed_black, pct_umemployed_white, 
                 pct_disabled_black, pct_disabled_white, 
                 pct_uninsured_black_19_64, pct_uninsured_white_19_64)
  
  # Black Vector #
  black <- acs_state %>%
    select(med_hh_inc_black, 
           pct_hh_inc_black_100p,
           pct_hh_inc_black_125p,
           pct_snap_black,
           pct_black_below_poverty,
           pct_black_below_poverty_child,
           pct_black_below_poverty_adult,
           pct_educ_less_hs_black,
           pct_educ_bachelor_black,
           pct_umemployed_black,
           pct_disabled_black,
           pct_uninsured_black_19_64) 
  
  # White Vector #
  white <- acs_state %>%
    select(med_hh_inc_white,
           pct_hh_inc_white_100p,
           pct_hh_inc_white_125p,
           pct_snap_white,
           pct_white_below_poverty,
           pct_white_below_poverty_child,
           pct_white_below_poverty_adult,
           pct_educ_less_hs_white, 
           pct_educ_bachelor_white,
           pct_umemployed_white,
           pct_disabled_white,
           pct_uninsured_white_19_64)
  
  # Combine Data #
  ses <- data.frame(Black = round(t(black),3), 
                    White = round(t(white), 3)) %>%
    dplyr::mutate(Diff = White - Black)
  
  # Recode Adjustments
  ses$Black[1] <- paste0("$",ses$Black[1])
  ses$White[1] <- paste0("$",ses$White[1])
  ses$Diff[1] <- paste0("$",ses$Diff[1])
  
  # Table Labeling #
  colnames(ses) <- c("Black", "White", "White - Black")
  
  rownames(ses) <- c("Median Household Income",
                     "Pct. HH Income > $100K",
                     "Pct. HH Income > $125K",
                     "Pct. HH receiving SNAP",
                     "Pct. HH below poverty line",
                     "Pct. HH below poverty line, children",
                     "Pct. HH below poverty line, VAP",
                     "Pct. w/ Less than HS Diploma",
                     "Pct. w/ Bachelor's Degree or higher",
                     "Pct. Unemployed",
                     "Pct Disabled, ages 19-64",
                     "Pct. Uninsured, ages 19-64"
  )
  
  ##################################
  # Produce Table -- as an example #
  ##################################
  
  return (ses)
  
  if (reactable){
  
    reactable(ses,
            pagination = F,
            width = 700)
  
  }
  
  if(xtable) {
    
    xtable::xtable(ses)
    
  }
    
}

# Execute
acs_factor5(vars = acs_vars,
            state = "MS")



