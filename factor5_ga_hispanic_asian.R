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

source("acs_vars_ga.R")

vars <- acs_vars
geography = "county"
year = 2021
state = "GA"
county <- c("135", "121")

acs_factor5 <- function(vars, 
                        geography = c("state", "county", "tract","block group", "block"),
                        year = 2021,
                        state = "GA",
                        county = NULL){
  
  # Call ACS Data #
  # On a multiple county call...
  if(!is.null(county) & length(county) > 1) {
    
    acs_dat <- get_acs(geography = geography, 
                       variables = vars, 
                       year = year,
                       state = state,
                       output = "wide",
                       county = county)
    
  acs_dat_sum <- acs_dat %>%
    # Select Estimates #
    dplyr::select(-GEOID, 
                  -NAME,
                  -B19013_001E,  # Median HH Income inc (all),
                  -B19013B_001E, # Median HH Income (black),
                  -B19013H_001E, # Median White alone NH
                  -B19013I_001E, # Median HH Income Hispanic 
                  -B19013D_001E, # Median HH Income Asian
                  -B19013E_001E, # Pac Island (lowest is county unit)
                  -B19013C_001E
                  ) %>%
    dplyr::select_if(grepl("E", names((.)) )) %>%
    colSums(na.rm=T)
  
  # Convert to data frame
  acs_dat_sum <-  as.data.frame(t(acs_dat_sum))
  
  # Weighted Average for HH median income
  acs_dat_weight <- acs_dat %>%
                    dplyr::select(GEOID, 
                                  B01003_001E, # total pop
                                  B19013_001E,  # Median HH Income inc (all),
                                  B19013B_001E, # Median HH Income (black),
                                  B19013H_001E, # Median White alone NH
                                  B19013I_001E, # Median HH Income Hispanic 
                                  B19013D_001E, # Median HH Income Asian
                                  #B19013E_001E, # Pac Island (lowest is county unit), not reliable
                                  B19013C_001E) %>% # Native
    dplyr::select_if(grepl("1E", names((.)) )) 
  
  # Extract Weighted Mean #
  acs_dat_weight <- apply(as.matrix(acs_dat_weight), 2, function(x,y) weighted.mean(x=x, w=acs_dat_weight$B01003_001E, na.rm=T)) 
  
  # Wrangle into correct format --
  acs_dat_weight <- as.data.frame(t(acs_dat_weight)) %>%
    dplyr::select(-B01003_001E)
  
  # combine the data together
  acs_dat <- data.frame(acs_dat_sum, acs_dat_weight)

    
  } else {
    
    acs_dat <- get_acs(geography = geography, 
                       variables = vars, 
                       year = year,
                       state = state,
                       output = "wide",
                       county = county)
    
  }
  
  # Recodes Variables #
  acs_dat <- acs_dat %>%
    dplyr::mutate(
      
      tot_pop= B01003_001E,
      
      # Race/Ethnicity #
      nh_white= B03002_003E,
      nh_black= B03002_004E, 
      nh_asian = B03002_006E, 
      nh_pac_island = B03002_007E, 
      hispanic= B03002_012E, 
      nh_native = B03002_005E,
      
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
      med_hh_inc_asian = B19013D_001E,
      #med_hh_inc_pac = B19013E_001, Too unreliable 
      # Note for PAC not enough reliable data so just use asian on this one #
      med_hh_inc_aapi = med_hh_inc_asian, # weighted.mean(x = c(med_hh_inc_asian,
                                          #  med_hh_inc_pac),
                                      #w = c(B19001D_001E,B19001E_001E)), # total households asian, pac
      med_hh_inc_native = B19013C_001E,
      
      # Household Income: 2020 #
      inc_total_households = B19001_001E, 
      inc_total_households_black = B19001B_001E, # Black
      inc_total_households_white = B19001H_001E, # White non-Hispanic
      inc_total_households_hispanic = B19001I_001E, # Hispanic or latino
      inc_total_households_aapi = B19001D_001E + B19001E_001E, # AAPI
      inc_total_households_native = B19001C_001E, # Native
      
      # White #
      hh_inc_total_white_100 =B19001H_014E, 
      hh_inc_total_white_125 =B19001H_015E, 
      hh_inc_total_white_150 =B19001H_016E, 
      hh_inc_total_white_200 = B19001H_017E, 
      
      # Black #
      hh_inc_total_black_100 = B19001B_014E, 
      hh_inc_total_black_125 = B19001B_015E, 
      hh_inc_total_black_150 = B19001B_016E, 
      hh_inc_total_black_200 = B19001B_017E, 
      
      # Hispanic #
      hh_inc_total_hispanic_100 = B19001I_014E, 
      hh_inc_total_hispanic_125 = B19001I_015E, 
      hh_inc_total_hispanic_150 = B19001I_016E, 
      hh_inc_total_hispanic_200 = B19001I_017E, 
      
      # Asian Alone #
      hh_inc_total_asian_100 = B19001D_014E, 
      hh_inc_total_asian_125 = B19001D_015E, 
      hh_inc_total_asian_150 = B19001D_016E, 
      hh_inc_total_asian_200 = B19001D_017E, 
      
      # Pacific Islander
      hh_inc_total_pac_100 = B19001E_014E, 
      hh_inc_total_pac_125 = B19001E_015E, 
      hh_inc_total_pac_150 = B19001E_016E, 
      hh_inc_total_pac_200 = B19001E_017E, 
    
      
      # White Income percents
      pct_hh_inc_white_100p= (hh_inc_total_white_100 + hh_inc_total_white_125 + 
                                hh_inc_total_white_150+ 
                                hh_inc_total_white_200)/inc_total_households_white, 
      pct_hh_inc_white_125p= (hh_inc_total_white_125 + hh_inc_total_white_150+
                                hh_inc_total_white_200)/inc_total_households_white, 
      
      # Black Income percents
      pct_hh_inc_black_100p= (hh_inc_total_black_100 + hh_inc_total_black_125 + 
                                hh_inc_total_black_150+ 
                                hh_inc_total_black_200)/inc_total_households_black, 
      pct_hh_inc_black_125p= (hh_inc_total_black_125 + hh_inc_total_black_150+ 
                                hh_inc_total_black_200)/inc_total_households_black, 
            
      # Hispanic Income Percents
      pct_hh_inc_hispanic_100p= (hh_inc_total_hispanic_100 + hh_inc_total_hispanic_125 + 
                                hh_inc_total_hispanic_150+ 
                                hh_inc_total_hispanic_200)/inc_total_households_hispanic, 
      pct_hh_inc_hispanic_125p= (hh_inc_total_hispanic_125 + hh_inc_total_hispanic_150 + 
                                hh_inc_total_hispanic_200)/inc_total_households_hispanic, 
      
      # AAPI Income Percents #
      pct_hh_inc_aapi_100p= (hh_inc_total_asian_100 + hh_inc_total_asian_125 + 
                               hh_inc_total_asian_150+ 
                               hh_inc_total_asian_200 + 
                               hh_inc_total_pac_100 + 
                               hh_inc_total_pac_125 + 
                               hh_inc_total_pac_150 +
                               hh_inc_total_pac_200 )/inc_total_households_aapi,
      
      pct_hh_inc_aapi_125p= (hh_inc_total_asian_125 + 
                               hh_inc_total_asian_150+ 
                               hh_inc_total_asian_200 + 
                               hh_inc_total_pac_100 + 
                               hh_inc_total_pac_150 +
                               hh_inc_total_pac_200 )/inc_total_households_aapi,
      
      
      # SNAP #
      snap_black= B22005B_002E, 
      snap_white= B22005H_002E, 
      snap_hispanic = B22005I_002E,
      snap_aapi = B22005D_002E + B22005E_002E,
      snap_native = B22005C_002E,
        
      pct_snap_black= snap_black/B22005B_001E, 
      pct_snap_white= snap_white/B22005H_001E,
      pct_snap_hispanic = snap_hispanic / B22005I_001E,
      pct_snap_aapi = snap_aapi / (B22005D_001E + B22005E_001E),
      pct_snap_native = snap_native / B22005C_001E,
      
      # Poverty Status 
      pct_black_below_poverty = B17001B_002E / B17001B_001E,
      pct_white_below_poverty = B17001H_002E / B17001H_001E,
      
      pct_hispanic_below_poverty = B17001I_002E / B17001I_001E,
      pct_aapi_below_poverty = (B17001D_002E + B17001E_002E) / 
                               (B17001D_001E + B17001E_001E),
      
      pct_native_below_poverty = B17001C_002E / B17001C_001E,
      
      # Black Poverty #
      
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
      
      # White Poverty #
      
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
      
      # Hispanic Poverty #
      
      # Poverty Status Hispanic Below 18 #
      hispanic_below18_total = B17001I_004E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
        B17001I_005E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
        B17001I_006E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
        B17001I_007E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
        B17001I_008E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
        B17001I_009E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
        B17001I_033E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!Under 5 years
        B17001I_034E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!5 years
        B17001I_035E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!6 to 11 years
        B17001I_036E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!12 to 14 years
        B17001I_037E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!15 years
        B17001I_038E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!16 and 17 years
        B17001I_018E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
        B17001I_019E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
        B17001I_020E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
        B17001I_021E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
        B17001I_022E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
        B17001I_023E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
        B17001I_047E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!Under 5 years
        B17001I_048E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!5 years
        B17001I_049E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!6 to 11 years
        B17001I_050E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!12 to 14 years
        B17001I_051E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!15 years
        B17001I_052E,	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!16 and 17 years
      
      hispanic_below18_poverty = B17001I_004E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
        B17001I_005E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
        B17001I_006E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
        B17001I_007E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
        B17001I_008E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
        B17001I_009E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
        B17001I_018E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
        B17001I_019E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
        B17001I_020E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
        B17001I_021E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
        B17001I_022E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
        B17001I_023E,	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
      
      pct_hispanic_below_poverty_child = hispanic_below18_poverty / hispanic_below18_total,
      
      # Poverty Status Hispanic Adults #
      hispanic_above18_total = B17001I_010E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
        B17001I_011E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
        B17001I_012E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
        B17001I_013E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
        B17001I_014E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
        B17001I_015E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
        B17001I_016E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
        B17001I_039E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!18 to 24 years
        B17001I_040E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!25 to 34 years
        B17001I_041E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!35 to 44 years
        B17001I_042E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!45 to 54 years
        B17001I_043E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!55 to 64 years
        B17001I_044E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!65 to 74 years
        B17001I_045E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!75 years and over
        B17001I_024E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
        B17001I_025E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
        B17001I_026E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
        B17001I_027E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
        B17001I_028E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
        B17001I_029E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
        B17001I_030E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
        B17001I_053E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!18 to 24 years
        B17001I_054E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!25 to 34 years
        B17001I_055E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!35 to 44 years
        B17001I_056E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!45 to 54 years
        B17001I_057E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!55 to 64 years
        B17001I_058E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!65 to 74 years
        B17001I_059E,	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!75 years and over              
      
      hispanic_above18_poverty = B17001I_010E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
        B17001I_011E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
        B17001I_012E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
        B17001I_013E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
        B17001I_014E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
        B17001I_015E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
        B17001I_016E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
        B17001I_024E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
        B17001I_025E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
        B17001I_026E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
        B17001I_027E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
        B17001I_028E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
        B17001I_029E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
        B17001I_030E,	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
      
      pct_hispanic_below_poverty_adult = hispanic_above18_poverty / hispanic_above18_total,
      
      # Poverty Status AAPI #
      
      # Poverty Status Asian Below 18 #
      Asian_below18_total = B17001D_004E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
        B17001D_005E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
        B17001D_006E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
        B17001D_007E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
        B17001D_008E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
        B17001D_009E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
        B17001D_033E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!Under 5 years
        B17001D_034E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!5 years
        B17001D_035E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!6 to 11 years
        B17001D_036E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!12 to 14 years
        B17001D_037E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!15 years
        B17001D_038E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!16 and 17 years
        B17001D_018E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
        B17001D_019E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
        B17001D_020E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
        B17001D_021E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
        B17001D_022E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
        B17001D_023E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
        B17001D_047E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!Under 5 years
        B17001D_048E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!5 years
        B17001D_049E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!6 to 11 years
        B17001D_050E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!12 to 14 years
        B17001D_051E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!15 years
        B17001D_052E,	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!16 and 17 years
      
      Asian_below18_poverty = B17001D_004E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
        B17001D_005E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
        B17001D_006E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
        B17001D_007E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
        B17001D_008E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
        B17001D_009E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
        B17001D_018E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
        B17001D_019E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
        B17001D_020E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
        B17001D_021E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
        B17001D_022E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
        B17001D_023E,	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
      
      # Poverty Status Pac Below 18 #
      Pac_below18_total = B17001E_004E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
        B17001E_005E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
        B17001E_006E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
        B17001E_007E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
        B17001E_008E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
        B17001E_009E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
        B17001E_033E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!Under 5 years
        B17001E_034E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!5 years
        B17001E_035E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!6 to 11 years
        B17001E_036E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!12 to 14 years
        B17001E_037E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!15 years
        B17001E_038E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!16 and 17 years
        B17001E_018E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
        B17001E_019E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
        B17001E_020E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
        B17001E_021E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
        B17001E_022E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
        B17001E_023E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
        B17001E_047E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!Under 5 years
        B17001E_048E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!5 years
        B17001E_049E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!6 to 11 years
        B17001E_050E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!12 to 14 years
        B17001E_051E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!15 years
        B17001E_052E,	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!16 and 17 years
      
      Pac_below18_poverty = B17001E_004E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
        B17001E_005E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
        B17001E_006E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
        B17001E_007E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
        B17001E_008E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
        B17001E_009E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
        B17001E_018E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
        B17001E_019E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
        B17001E_020E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
        B17001E_021E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
        B17001E_022E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
        B17001E_023E,	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
      
      pct_aapi_below_poverty_child = (Asian_below18_poverty + Pac_below18_poverty) / 
                                     (Pac_below18_total + Asian_below18_total),
      
      # Poverty Asian Black Adults #
      Asian_above18_total = B17001D_010E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
        B17001D_011E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
        B17001D_012E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
        B17001D_013E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
        B17001D_014E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
        B17001D_015E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
        B17001D_016E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
        B17001D_039E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!18 to 24 years
        B17001D_040E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!25 to 34 years
        B17001D_041E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!35 to 44 years
        B17001D_042E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!45 to 54 years
        B17001D_043E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!55 to 64 years
        B17001D_044E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!65 to 74 years
        B17001D_045E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!75 years and over
        B17001D_024E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
        B17001D_025E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
        B17001D_026E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
        B17001D_027E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
        B17001D_028E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
        B17001D_029E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
        B17001D_030E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
        B17001D_053E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!18 to 24 years
        B17001D_054E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!25 to 34 years
        B17001D_055E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!35 to 44 years
        B17001D_056E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!45 to 54 years
        B17001D_057E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!55 to 64 years
        B17001D_058E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!65 to 74 years
        B17001D_059E,	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!75 years and over              
      
      Asian_above18_poverty = B17001D_010E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
        B17001D_011E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
        B17001D_012E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
        B17001D_013E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
        B17001D_014E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
        B17001D_015E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
        B17001D_016E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
        B17001D_024E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
        B17001D_025E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
        B17001D_026E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
        B17001D_027E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
        B17001D_028E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
        B17001D_029E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
        B17001D_030E,	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
      
      # Poverty Status PAC Adults #
      Pac_above18_total = B17001E_010E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
        B17001E_011E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
        B17001E_012E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
        B17001E_013E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
        B17001E_014E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
        B17001E_015E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
        B17001E_016E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
        B17001E_039E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!18 to 24 years
        B17001E_040E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!25 to 34 years
        B17001E_041E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!35 to 44 years
        B17001E_042E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!45 to 54 years
        B17001E_043E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!55 to 64 years
        B17001E_044E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!65 to 74 years
        B17001E_045E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!75 years and over
        B17001E_024E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
        B17001E_025E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
        B17001E_026E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
        B17001E_027E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
        B17001E_028E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
        B17001E_029E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
        B17001E_030E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
        B17001E_053E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!18 to 24 years
        B17001E_054E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!25 to 34 years
        B17001E_055E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!35 to 44 years
        B17001E_056E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!45 to 54 years
        B17001E_057E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!55 to 64 years
        B17001E_058E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!65 to 74 years
        B17001E_059E,	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!75 years and over              
      
      Pac_above18_poverty = B17001E_010E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
        B17001E_011E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
        B17001E_012E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
        B17001E_013E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
        B17001E_014E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
        B17001E_015E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
        B17001E_016E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
        B17001E_024E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
        B17001E_025E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
        B17001E_026E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
        B17001E_027E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
        B17001E_028E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
        B17001E_029E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
        B17001E_030E,	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
      
      pct_aapi_below_poverty_adult = (Asian_above18_poverty + Pac_above18_poverty) / 
                                     (Asian_above18_total + Pac_above18_total),
      
      # Poverty Status Native #
      
      
      # Poverty Status Native Below 18 #
      Native_below18_total = B17001C_004E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
        B17001C_005E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
        B17001C_006E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
        B17001C_007E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
        B17001C_008E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
        B17001C_009E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
        B17001C_033E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!Under 5 years
        B17001C_034E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!5 years
        B17001C_035E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!6 to 11 years
        B17001C_036E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!12 to 14 years
        B17001C_037E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!15 years
        B17001C_038E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!16 and 17 years
        B17001C_018E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
        B17001C_019E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
        B17001C_020E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
        B17001C_021E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
        B17001C_022E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
        B17001C_023E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
        B17001C_047E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!Under 5 years
        B17001C_048E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!5 years
        B17001C_049E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!6 to 11 years
        B17001C_050E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!12 to 14 years
        B17001C_051E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!15 years
        B17001C_052E,	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!16 and 17 years
      
      Native_below18_poverty = B17001C_004E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
        B17001C_005E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
        B17001C_006E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
        B17001C_007E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
        B17001C_008E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
        B17001C_009E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
        B17001C_018E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
        B17001C_019E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
        B17001C_020E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
        B17001C_021E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
        B17001C_022E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
        B17001C_023E,	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
      
      pct_Native_below_poverty_child = Native_below18_poverty / Native_below18_total,
      
      # Poverty Status Native Adults #
      Native_above18_total = B17001C_010E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
        B17001C_011E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
        B17001C_012E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
        B17001C_013E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
        B17001C_014E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
        B17001C_015E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
        B17001C_016E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
        B17001C_039E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!18 to 24 years
        B17001C_040E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!25 to 34 years
        B17001C_041E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!35 to 44 years
        B17001C_042E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!45 to 54 years
        B17001C_043E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!55 to 64 years
        B17001C_044E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!65 to 74 years
        B17001C_045E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!75 years and over
        B17001C_024E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
        B17001C_025E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
        B17001C_026E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
        B17001C_027E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
        B17001C_028E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
        B17001C_029E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
        B17001C_030E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
        B17001C_053E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!18 to 24 years
        B17001C_054E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!25 to 34 years
        B17001C_055E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!35 to 44 years
        B17001C_056E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!45 to 54 years
        B17001C_057E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!55 to 64 years
        B17001C_058E+	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!65 to 74 years
        B17001C_059E,	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!75 years and over              
      
      Native_above18_poverty = B17001C_010E +	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
        B17001C_011E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
        B17001C_012E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
        B17001C_013E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
        B17001C_014E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
        B17001C_015E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
        B17001C_016E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
        B17001C_024E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
        B17001C_025E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
        B17001C_026E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
        B17001C_027E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
        B17001C_028E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
        B17001C_029E+	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
        B17001C_030E,	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
      
      pct_Native_below_poverty_adult = Native_above18_poverty / Native_above18_total,
      
      ##########################
      # Educational Attainment #
      ##########################
      
      #Educational Attainment, Black #
      pct_educ_less_hs_black = (C15002B_003E + C15002B_008E)/C15002B_001E,
      pct_educ_bachelor_black= (C15002B_006E+ C15002B_011E)/C15002B_001E, 
      
      # Educational Attainment, White #
      pct_educ_less_hs_white = (C15002H_003E + C15002H_008E)/C15002H_001E,
      pct_educ_bachelor_white= (C15002H_006E+ C15002H_011E)/C15002H_001E,
      
      # Educational Attainment, Hispanic #
      pct_educ_less_hs_hispanic = (C15002I_003E + C15002I_008E)/C15002I_001E,
      pct_educ_bachelor_hispanic = (C15002I_006E+ C15002I_011E)/C15002I_001E,
      
      # Educational Attainment, AAPI #
      pct_educ_less_hs_aapi = (C15002D_003E + C15002D_008E + C15002E_003E + C15002E_008E) /
                              (C15002D_001E + C15002E_001E),
      pct_educ_bachelor_aapi = (C15002D_006E+ C15002D_011E + C15002E_006E+ C15002E_011E) /
                               (C15002D_001E +C15002E_001E),
      
      # Educational Attainment, Native #
      pct_educ_less_hs_native = (C15002C_003E + C15002C_008E)/C15002C_001E,
      pct_educ_bachelor_native = (C15002C_006E+ C15002C_011E)/C15002C_001E,
      
      
      # Civilian Employment / Unemployment) #

      #Civilian Employment in Labor Force, 16-64 Black
      civilian_empl_status_total_black= C23002B_006E+ C23002B_019E,
      pct_umemployed_black = (C23002B_008E+C23002B_021E)/civilian_empl_status_total_black,
      
      #Civilian Employment in Labor Force, 16-64 White
      civilian_empl_status_total_white= C23002H_006E+ C23002H_019E,
      pct_umemployed_white = (C23002H_008E+C23002H_021E)/civilian_empl_status_total_white,
      
      #Civilian Employment in Labor Force, 16-64 Hispanic
      civilian_empl_status_total_hispanic= C23002I_006E+ C23002I_019E,
      pct_umemployed_hispanic = (C23002I_008E+C23002I_021E)/civilian_empl_status_total_hispanic,
      
      #Civilian Employment in Labor Force, 16-64 AAPI
      civilian_empl_status_total_aapi= C23002D_006E+ C23002D_019E + C23002E_006E+ C23002E_019E,
      pct_umemployed_aapi = (C23002D_008E+C23002D_021E + C23002E_008E+C23002E_021E) / 
                            civilian_empl_status_total_aapi,
      
      #Civilian Employment in Labor Force, 16-64 Native 
      civilian_empl_status_total_native = C23002C_006E+ C23002C_019E,
      pct_umemployed_native = (C23002C_008E+C23002C_021E)/civilian_empl_status_total_native,
      
      #Disabled, Ages 18-64 Black, White, Hispanic, AAPI, Native #
      pct_disabled_black= B18101B_006E/B18101B_005E,
      pct_disabled_white= B18101H_006E/B18101H_005E, 
      pct_disabled_hispanic = B18101I_006E/B18101I_005E, 
      pct_disabled_aapi = (B18101D_006E + B18101E_006E) / 
                          (B18101D_005E + B18101E_005E), 
      pct_disabled_native = B18101C_006E/B18101C_005E, 
      
      #Uninsured Black, White, Hispanic, AAPI, Native (19-64)
      pct_uninsured_black_19_64 = C27001B_007E/C27001B_005E, 
      pct_uninsured_white_19_64 = C27001H_007E/C27001H_005E,
      pct_uninsured_hispanic_19_64 = C27001I_007E/C27001I_005E,
      
      pct_uninsured_aapi_19_64 = (C27001D_007E + C27001E_007E)/
                                 (C27001D_005E + C27001E_005E),
      pct_uninsured_native_19_64 = C27001C_007E/C27001C_005E) %>% 
    dplyr::select(pct_black, 
                  pct_white,
                  pct_hispanic,
                  pct_aapi,
                  pct_native,
                  
                  med_hh_inc_black, 
                  med_hh_inc_white,
                  med_hh_inc_hispanic, 
                  med_hh_inc_asian,
                  #med_hh_inc_pac, 
                  med_hh_inc_aapi,
                  med_hh_inc_native,
                  
                  pct_hh_inc_black_100p, 
                  pct_hh_inc_black_125p,
                  
                  pct_hh_inc_white_100p, 
                  pct_hh_inc_white_125p, 
                  
                  pct_hh_inc_hispanic_100p,
                  pct_hh_inc_hispanic_125p,
                  
                  pct_hh_inc_aapi_100p,
                  pct_hh_inc_aapi_125p,
                  
                  pct_snap_black, 
                  pct_snap_white, 
                  pct_snap_hispanic,
                  pct_snap_aapi,
                  pct_snap_native,
                  
                  pct_black_below_poverty, 
                  pct_white_below_poverty, 
                  pct_hispanic_below_poverty,
                  pct_aapi_below_poverty,
                  pct_native_below_poverty,
                  
                  pct_black_below_poverty_child, 
                  pct_black_below_poverty_adult,
                  
                  pct_white_below_poverty_child, 
                  pct_white_below_poverty_adult, 
                  
                  pct_hispanic_below_poverty_child,
                  pct_hispanic_below_poverty_adult,
                  
                  pct_aapi_below_poverty_child,
                  pct_aapi_below_poverty_adult,
                  
                  pct_Native_below_poverty_child,
                  pct_Native_below_poverty_adult,
                  
                  pct_educ_less_hs_black, 
                  pct_educ_bachelor_black,
                  
                  pct_educ_less_hs_white, 
                  pct_educ_bachelor_white, 
                  
                  pct_educ_less_hs_hispanic,
                  pct_educ_bachelor_hispanic,
                  
                  pct_educ_less_hs_aapi,
                  pct_educ_bachelor_aapi,
                  
                  pct_educ_less_hs_native,
                  pct_educ_bachelor_native,
                  
                  pct_umemployed_black, 
                  pct_umemployed_white, 
                  pct_umemployed_hispanic,
                  pct_umemployed_aapi,
                  pct_umemployed_native,
                  
                  pct_disabled_black, 
                  pct_disabled_white, 
                  pct_disabled_hispanic, 
                  pct_disabled_aapi, 
                  pct_disabled_native,
                  
                  pct_uninsured_black_19_64, 
                  pct_uninsured_white_19_64,
                  pct_uninsured_hispanic_19_64,
                  pct_uninsured_aapi_19_64,
                  pct_uninsured_native_19_64)
    
    return(acs_dat)
    
}

#################################
# Post Data Extract and Recodes #
#################################

# Black Vector #
black <- acs_dat %>%
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
white <- acs_dat %>%
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
  
# Hispanic Vector #
hispanic <- acs_dat %>%
  dplyr::select(med_hh_inc_hispanic,
         pct_hh_inc_hispanic_100p,
         pct_hh_inc_hispanic_125p,
         pct_snap_hispanic,
         pct_hispanic_below_poverty,
         pct_hispanic_below_poverty_child,
         pct_hispanic_below_poverty_adult,
         pct_educ_less_hs_hispanic, 
         pct_educ_bachelor_hispanic,
         pct_umemployed_hispanic,
         pct_disabled_hispanic,
         pct_uninsured_hispanic_19_64)


# AAPI Vector #
aapi <- acs_dat %>%
  dplyr::select(med_hh_inc_aapi,
                pct_hh_inc_aapi_100p,
                pct_hh_inc_aapi_125p,
                pct_snap_aapi,
                pct_aapi_below_poverty,
                pct_aapi_below_poverty_child,
                pct_aapi_below_poverty_adult,
                pct_educ_less_hs_aapi, 
                pct_educ_bachelor_aapi,
                pct_umemployed_aapi,
                pct_disabled_aapi,
                pct_uninsured_aapi_19_64)

# Combine Data #
ses <- data.frame(Black = round(t(black),3), 
                  White = round(t(white), 3),
                  Hispanic = round(t(hispanic), 3),
                  AAPI = round(t(aapi), 3)
                  ) %>%
    dplyr::mutate(WB_Diff = White - Black,
                  WH_Diff = White - Hispanic,
                  WA_Diff = White - AAPI)
  
# Recode Adjustments
ses$Black[1] <- paste0("$",ses$Black[1])
ses$White[1] <- paste0("$",ses$White[1])
ses$Hispanic[1] <- paste0("$",ses$Hispanic[1])
ses$WB_Diff[1] <- paste0("$",ses$WB_Diff[1])
ses$WH_Diff[1] <- paste0("$",ses$WH_Diff[1])  
ses$WA_Diff[1] <- paste0("$",ses$WA_Diff[1])  

# Table Labeling #
colnames(ses) <- c("Black", "White","Hispanic", "AAPI", "White - Black", "White - Hispanic", "White - AAPI")
  
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
  
reactable(ses,
              pagination = F,
              width = 800)
    
  
