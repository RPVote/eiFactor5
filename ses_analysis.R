####################################
# Loren Collingwood                #
# Riverside SES White vs. Hispanic #
####################################

rm(list=ls())

# Packages #
# Need to get API key for census to harvest Census data (it's free!)
library(tigris)
library(tidycensus)
library(tidyverse)
library(haven)
library(reactable)


# Relevant Population Variables #
acs_vars <- c("B01003_001",  # Total Pop
              "B03002_003",  # White NH
              "B03002_012",  # Hispanic
              
              "B19013_001",  # Median HH Income inc 2019 (all),
              "B19013H_001", # Median HH Income (White alone NH)
              "B19013I_001", # Median HH Income (Hispanic)
              
              "B19001_001",  #Income total households (all, IN 2020 INFLATION-ADJUSTED DOLLARS)
              "B19001H_001", #Income total (White)
              "B19001I_001", #Income total (Hispanic) 
              
              "B19001H_014", #HH income > 100,000 to $124,999 (White)
              "B19001H_015", #HH income 125,000 to $149,999 (White)
              "B19001H_016", #HH income 150,000 to $199,999 (White)
              "B19001H_017", #HH income 200,000 or more (White)
              
              "B19001I_014", #HH income > 100,000 to $124,999 (Hispanic)
              "B19001I_015", #HH income 125,000 to $149,999 (Hispanic)
              "B19001I_016", #HH income 150,000 to $199,999 (Hispanic)
              "B19001I_017", #HH income 200,000 or more (Hispanic)
              
              "B22005H_002", # SNAP benefits received (White)
              "B22005I_002", # SNAP benefits received (Hispanic)
              
              "B22005H_001", # SNAP Denominator (Total White)
              "B22005I_001", # SNAP Denominator (total Hispanic)
              
              "B17001H_002", # Income Below poverty level (White)
              "B17001I_002", # Income Below poverty level (Hispanic)
              
              "B17001H_001", # POVERTY STATUS (NH White) # Denominator
              "B17001I_001", # POVERTY STATUS (Hispanic) # Denominator
              
              
              ############
              # Educational Attainment, White #
              
              #Total White
              "C15002H_001",	#Estimate!!Total:	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (White NH)
              
              #White Men
              "C15002H_003",	#Estimate!!Total:!!Male:!!Less than high school diploma	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (White NH)
              "C15002H_004",	#Estimate!!Total:!!Male:!!High school graduate (includes equivalency)	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (White NH)
              "C15002H_005",	#Estimate!!Total:!!Male:!!Some college or associate's degree	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (White NH)
              "C15002H_006",	#Estimate!!Total:!!Male:!!Bachelor's degree or higher	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (White NH)
              
              #White Women
              "C15002H_008",	#Estimate!!Total:!!Female:!!Less than high school diploma	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (White NH)
              "C15002H_009",	#Estimate!!Total:!!Female:!!High school graduate (includes equivalency)	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (White NH)
              "C15002H_010",	#Estimate!!Total:!!Female:!!Some college or associate's degree	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (White NH)
              "C15002H_011",  #Estimate!!Total:!!Female:!!Bachelor's degree or higher	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (White NH)
              
              # Educational Attainment, Hispanic #
              
              #Total Hispanic
              "C15002I_001",	#Estimate!!Total:	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic)
              
              #Hispanic Men
              "C15002I_003",	#Estimate!!Total:!!Male:!!Less than high school diploma	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic)
              "C15002I_004",	#Estimate!!Total:!!Male:!!High school graduate (includes equivalency)	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic)
              "C15002I_005",	#Estimate!!Total:!!Male:!!Some college or associate's degree	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic)
              "C15002I_006",	#Estimate!!Total:!!Male:!!Bachelor's degree or higher	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic)
              
              #Hispanic Women
              "C15002I_008",	#Estimate!!Total:!!Female:!!Less than high school diploma	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic)
              "C15002I_009",	#Estimate!!Total:!!Female:!!High school graduate (includes equivalency)	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic)
              "C15002I_010",	#Estimate!!Total:!!Female:!!Some college or associate's degree	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic)
              "C15002I_011",	#Estimate!!Total:!!Female:!!Bachelor's degree or higher	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic)
              
              ############
              
              #Civilian Employment Status 16-64 (In labor force), White Men #
              "C23002H_006", 	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (White Not HS)
              #Employed vs Unemployed 
              "C23002H_007",	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:!!Employed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (White Not HS)
              "C23002H_008",	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:!!Unemployed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (White Not HS)
              
              #Civilian Employment Status 16-64, White Women #
              "C23002H_019",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (White Not HS)                
              #Employed vs Unemployed 
              "C23002H_020",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:!!Employed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (White Not HS)
              "C23002H_021",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:!!Unemployed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (White Not HS)
              
              
              #Civilian Employment Status 16-64 (In labor force), Hispanic Men #
              "C23002I_006", 	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Hispanic)
              #Employed vs Unemployed 
              "C23002I_007",	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:!!Employed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Hispanic)
              "C23002I_008",	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:!!Unemployed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Hispanic)
              
              #Civilian Employment Status 16-64, Hispanic Women #
              "C23002I_019",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Hispanic)                
              #Employed vs Unemployed 
              "C23002I_020",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:!!Employed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Hispanic)
              "C23002I_021"	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:!!Unemployed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Hispanic)
             
)

# Harvest County-Level Data #
acs20_county <- get_acs(geography = "county", 
                        county = "Riverside",
                        variables = acs_vars, 
                        year = 2020,
                        state = "CA", 
                        output="wide")

acs20_county_final <- acs20_county %>%
  mutate(tot_pop= B01003_001E,
         # Race/Ethnicity #
         nh_white= B03002_003E,
         hispanic= B03002_012E, 
         pct_white = nh_white / tot_pop, 
         pct_hispanic = hispanic / tot_pop,
         
         # Median HH Income #
         med_hh_inc= B19013_001E, 
         med_hh_inc_white = B19013H_001E, 
         med_hh_inc_hispanic = B19013I_001E, 
         
         # Household Income #
         inc_total_households = B19001_001E, 
         inc_total_households_white = B19001H_001E, 
         inc_total_households_hispanic = B19001I_001E, 
         
         hh_inc_total_white_100 =B19001H_014E, 
         hh_inc_total_white_125 =B19001H_015E, 
         hh_inc_total_white_150 =B19001H_016E, 
         hh_inc_total_white_200 = B19001H_017E,
         
         hh_inc_total_hispanic_100 = B19001I_014E, 
         hh_inc_total_hispanic_125 = B19001I_015E, 
         hh_inc_total_hispanic_150 = B19001I_016E, 
         hh_inc_total_hispanic_200 = B19001I_017E, 
         
         pct_hh_inc_white_100p= (hh_inc_total_white_100 + hh_inc_total_white_125 + 
                                   hh_inc_total_white_150+ 
                                   hh_inc_total_white_200)/inc_total_households_white, 
         
         pct_hh_inc_white_125p= (hh_inc_total_white_125 + hh_inc_total_white_150+
                                   hh_inc_total_white_200)/inc_total_households_white, 
         
         pct_hh_inc_hispanic_100p= (hh_inc_total_hispanic_100 + hh_inc_total_hispanic_125 + 
                                      hh_inc_total_hispanic_150+ 
                                      hh_inc_total_hispanic_200)/inc_total_households_hispanic, 
         pct_hh_inc_hispanic_125p= (hh_inc_total_hispanic_125 + hh_inc_total_hispanic_150+ 
                                      hh_inc_total_hispanic_200)/inc_total_households_hispanic, 
         
         
         # SNAP #
         snap_white= B22005H_002E, 
         snap_hispanic= B22005I_002E, 
         
         pct_snap_white= snap_white/B22005H_001E,
         pct_snap_hispanic= snap_hispanic/B22005I_001E, 
         
         # Poverty Status 
         pct_white_below_poverty = B17001H_002E / B17001H_001E,
         pct_hispanic_below_poverty = B17001I_002E / B17001I_001E,
         
         
         ########Educational Attainment
         
         #Educational Attainment, White
         pct_educ_less_hs_white = (C15002H_003E + C15002H_008E)/C15002H_001E,
         pct_educ_bachelor_white= (C15002H_006E+ C15002H_011E)/C15002H_001E,
         #Educational Attainment, Hispanic 
         pct_educ_less_hs_hispanic = (C15002I_003E + C15002I_008E)/C15002I_001E,
         pct_educ_bachelor_hispanic= (C15002I_006E+ C15002I_011E)/C15002I_001E, 
         
         ########Civilian Employment in Labor Force
         
         #Civilian Employment in Labor Force, 16-64 White
         civilian_empl_status_total_white= C23002H_006E+ C23002H_019E,
         pct_umemployed_white = (C23002H_008E+C23002H_021E)/civilian_empl_status_total_white,
         
         #Civilian Employment in Labor Force, 16-64 Hispanic
         civilian_empl_status_total_hispanic= C23002I_006E+ C23002I_019E,
         pct_umemployed_hispanic = (C23002I_008E+C23002I_021E)/civilian_empl_status_total_hispanic,
         
         
  ) %>% select(pct_white,pct_hispanic, 
               med_hh_inc_white, med_hh_inc_hispanic, 
               
               pct_hh_inc_white_100p, pct_hh_inc_white_125p, 
               pct_hh_inc_hispanic_100p, pct_hh_inc_hispanic_125p,
               
               pct_snap_white, pct_snap_hispanic, 
               pct_white_below_poverty, pct_hispanic_below_poverty, 
              
               pct_educ_less_hs_white, pct_educ_bachelor_white, 
               pct_educ_less_hs_hispanic, pct_educ_bachelor_hispanic,
               
               pct_umemployed_white, pct_umemployed_hispanic
               )


# White Vector #
white <- acs20_county_final %>%
  select(med_hh_inc_white,
         pct_hh_inc_white_100p,
         pct_hh_inc_white_125p,
         pct_snap_white,
         pct_white_below_poverty,
         pct_educ_less_hs_white, 
         pct_educ_bachelor_white,
         pct_umemployed_white)

# Hispanic Vector #
hispanic <- acs20_county_final %>%
  select(med_hh_inc_hispanic, 
         pct_hh_inc_hispanic_100p,
         pct_hh_inc_hispanic_125p,
         pct_snap_hispanic,
         pct_hispanic_below_poverty,
         pct_educ_less_hs_hispanic,
         pct_educ_bachelor_hispanic,
         pct_umemployed_hispanic) 


# Combine Data #
ses <- data.frame(white = round(t(white),3), 
                  hispanic = round(t(hispanic),3)) %>%
  dplyr::mutate(diff = white - hispanic) 


# Recode Adjustments

ses['med_hh_inc_white',] <- paste0("$",ses['med_hh_inc_white',])

# ses$white[1] <- paste0("$",ses$white[1])
# ses$hispanic[1] <- paste0("$",ses$hispanic[1])
# 
# ses$diff[1] <- paste0("$",ses$diff[1])
# ses$diff1[1] <- paste0("$",ses$diff1[1])

# Table Labeling #
colnames(ses) <- c("White", "Hispanic",  "White - Hispanic")

rownames(ses) <- c("Median Household Income",
                   "Pct. HH Income > $100K",
                   "Pct. HH Income > $125K",
                   "Pct. HH receiving SNAP",
                   "Pct. HH below poverty line",
                   "Pct. w/ Less than HS Diploma",
                   "Pct. w/ Bachelor's Degree or higher",
                   "Pct. Unemployed"
)

# Produce Table #
reactable(ses,
          pagination = F,
          width = 700)


