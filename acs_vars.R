# Relevant Population Variables #
acs_vars <- c("B01003_001",  # Total Pop
              "B03002_003",  # White NH
              "B03002_004",  # Black NH
              "B03002_006",  # Asian NH
              "B03002_007",  # Pac Island NH
              "B03002_012",  # Hispanic
              "B19013_001",  # Median HH Income inc 2019 (all),
              "B19013B_001", # Median HH Income (black),
              "B19013H_001", # Median White alone NH
              "B19013I_001", # Median HH Income Hispanic 
              "B19001_001",  #Income total households
              "B19001B_001", #Income total black households 
              "B19001H_001", #Income total white households 
              "B19001B_014", #HH income Black > 100,000 to $124,999
              "B19001B_015", #HH income Black 125,000 to $149,999
              "B19001B_016", #HH income Black 150,000 to $199,999
              "B19001B_017", #HH income Black 200,000 or more
              "B19001H_014", #HH income white > 100,000 to $124,999
              "B19001H_015", #HH income white 125,000 to $149,999
              "B19001H_016", #HH income white 150,000 to $199,999
              "B19001H_017", #HH income white 200,000 or more
              "B22005B_002", # Snap Black
              "B22005H_002", # Snap White
              "B22005B_001", # Snap Black Denominator 
              "B22005H_001", # Snap White Denominator 
              "B17001B_001", # POVERTY STATUS (BLACK OR AFRICAN AMERICAN ALONE) # Denominator
              "B17001B_002", # Income Below poverty level (Black)
              "B17001H_001", # POVERTY STATUS (NH White) # Denominator
              "B17001H_002", # Income Below poverty level (White)
              
              # Poverty Status Black Men #
              
              "B17001B_004",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
              "B17001B_005",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
              "B17001B_006",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
              "B17001B_007",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
              "B17001B_008",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
              "B17001B_009",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
              "B17001B_010",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
              "B17001B_011",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
              "B17001B_012",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
              "B17001B_013",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
              "B17001B_014",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
              "B17001B_015",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
              "B17001B_016",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
              
              # At or Above Poverty status Black Men (use this to combine with above for Denominator)
              "B17001B_033",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!Under 5 years
              "B17001B_034",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!5 years
              "B17001B_035",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!6 to 11 years
              "B17001B_036",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!12 to 14 years
              "B17001B_037",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!15 years
              "B17001B_038",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!16 and 17 years
              "B17001B_039",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!18 to 24 years
              "B17001B_040",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!25 to 34 years
              "B17001B_041",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!35 to 44 years
              "B17001B_042",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!45 to 54 years
              "B17001B_043",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!55 to 64 years
              "B17001B_044",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!65 to 74 years
              "B17001B_045",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!75 years and over
              
              # Poverty Status Black Women #
              
              "B17001B_018",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
              "B17001B_019",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
              "B17001B_020",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
              "B17001B_021",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
              "B17001B_022",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
              "B17001B_023",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
              "B17001B_024",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
              "B17001B_025",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
              "B17001B_026",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
              "B17001B_027",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
              "B17001B_028",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
              "B17001B_029",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
              "B17001B_030",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
              
              # At or Above Poverty status Black Women (use this to combine with above for Denominator)              
              
              "B17001B_047",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!Under 5 years
              "B17001B_048",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!5 years
              "B17001B_049",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!6 to 11 years
              "B17001B_050",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!12 to 14 years
              "B17001B_051",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!15 years
              "B17001B_052",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!16 and 17 years
              "B17001B_053",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!18 to 24 years
              "B17001B_054",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!25 to 34 years
              "B17001B_055",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!35 to 44 years
              "B17001B_056",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!45 to 54 years
              "B17001B_057",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!55 to 64 years
              "B17001B_058",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!65 to 74 years
              "B17001B_059",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!75 years and over              
              
              # Poverty Status White Men #
              
              "B17001H_004",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
              "B17001H_005",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
              "B17001H_006",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
              "B17001H_007",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
              "B17001H_008",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
              "B17001H_009",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
              "B17001H_010",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
              "B17001H_011",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
              "B17001H_012",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
              "B17001H_013",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
              "B17001H_014",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
              "B17001H_015",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
              "B17001H_016",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
              
              # At or Above Poverty status White Men (use this to combine with above for Denominator)
              
              "B17001H_032",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:
              "B17001H_033",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!Under 5 years
              "B17001H_034",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!5 years
              "B17001H_035",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!6 to 11 years
              "B17001H_036",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!12 to 14 years
              "B17001H_037",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!15 years
              "B17001H_038",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!16 and 17 years
              "B17001H_039",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!18 to 24 years
              "B17001H_040",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!25 to 34 years
              "B17001H_041",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!35 to 44 years
              "B17001H_042",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!45 to 54 years
              "B17001H_043",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!55 to 64 years
              "B17001H_044",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!65 to 74 years
              "B17001H_045",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!75 years and over
              
              # Poverty Status White Women #
              
              "B17001H_018",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
              "B17001H_019",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
              "B17001H_020",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
              "B17001H_021",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
              "B17001H_022",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
              "B17001H_023",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
              "B17001H_024",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
              "B17001H_025",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
              "B17001H_026",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
              "B17001H_027",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
              "B17001H_028",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
              "B17001H_029",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
              "B17001H_030",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over
              
              # At or Above Poverty status White Womens (use this to combine with above for Denominator)
              
              "B17001H_047",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!Under 5 years
              "B17001H_048",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!5 years
              "B17001H_049",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!6 to 11 years
              "B17001H_050",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!12 to 14 years
              "B17001H_051",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!15 years
              "B17001H_052",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!16 and 17 years
              "B17001H_053",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!18 to 24 years
              "B17001H_054",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!25 to 34 years
              "B17001H_055",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!35 to 44 years
              "B17001H_056",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!45 to 54 years
              "B17001H_057",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!55 to 64 years
              "B17001H_058",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!65 to 74 years
              "B17001H_059",  	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!75 years and over
              
              #Educational Attainment, Black#
              #Total Black
              "C15002B_001",	#Estimate!!Total:	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (BLACK OR AFRICAN AMERICAN ALONE)
              #Black Men
              "C15002B_003",	#Estimate!!Total:!!Male:!!Less than high school diploma	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (BLACK OR AFRICAN AMERICAN ALONE)
              "C15002B_004",	#Estimate!!Total:!!Male:!!High school graduate (includes equivalency)	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (BLACK OR AFRICAN AMERICAN ALONE)
              "C15002B_005",	#Estimate!!Total:!!Male:!!Some college or associate's degree	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (BLACK OR AFRICAN AMERICAN ALONE)
              "C15002B_006",	#Estimate!!Total:!!Male:!!Bachelor's degree or higher	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (BLACK OR AFRICAN AMERICAN ALONE)
              #Black Women
              "C15002B_008",	#Estimate!!Total:!!Female:!!Less than high school diploma	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (BLACK OR AFRICAN AMERICAN ALONE)
              "C15002B_009",	#Estimate!!Total:!!Female:!!High school graduate (includes equivalency)	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (BLACK OR AFRICAN AMERICAN ALONE)
              "C15002B_010",	#Estimate!!Total:!!Female:!!Some college or associate's degree	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (BLACK OR AFRICAN AMERICAN ALONE)
              "C15002B_011",	#Estimate!!Total:!!Female:!!Bachelor's degree or higher	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (BLACK OR AFRICAN AMERICAN ALONE)
              
              #Educational Attainment, White #
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
              
              #Civilian Employment Status 16-64 (In labor force), Black Men #
              "C23002B_006", 	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (BLACK OR AFRICAN AMERICAN ALONE)
              #Employed vs Unemployed 
              "C23002B_007",	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:!!Employed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (BLACK OR AFRICAN AMERICAN ALONE)
              "C23002B_008",	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:!!Unemployed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (BLACK OR AFRICAN AMERICAN ALONE)
              
              #Civilian Employment Status 16-64, Black Women #
              "C23002B_019",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (BLACK OR AFRICAN AMERICAN ALONE)                
              #Employed vs Unemployed 
              "C23002B_020",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:!!Employed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (BLACK OR AFRICAN AMERICAN ALONE)
              "C23002B_021",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:!!Unemployed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (BLACK OR AFRICAN AMERICAN ALONE)
              
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
              
              # Disability status, ages 18-64 Black
              "B18101B_005",	#Estimate!!Total:!!18 to 64 years:	AGE BY DISABILITY STATUS (BLACK OR AFRICAN AMERICAN ALONE)
              "B18101B_006",	#Estimate!!Total:!!18 to 64 years:!!With a disability	AGE BY DISABILITY STATUS (BLACK OR AFRICAN AMERICAN ALONE)
              
              # Disability status, ages 18-64 White
              "B18101H_005",	#Estimate!!Total:!!18 to 64 years:	AGE BY DISABILITY STATUS (WHITE ALONE, NOT HISPANIC OR LATINO)
              "B18101H_006",	#Estimate!!Total:!!18 to 64 years:!!With a disability	AGE BY DISABILITY STATUS (WHITE ALONE, NOT HISPANIC OR LATINO)
              
              #Health Insurance Coverage Black, by Age
              "C27001B_001",	#Estimate!!Total:	HEALTH INSURANCE COVERAGE STATUS BY AGE (BLACK OR AFRICAN AMERICAN ALONE)
              "C27001B_002",	#Estimate!!Total:!!Under 19 years:	HEALTH INSURANCE COVERAGE STATUS BY AGE (BLACK OR AFRICAN AMERICAN ALONE)
              "C27001B_003",	#Estimate!!Total:!!Under 19 years:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (BLACK OR AFRICAN AMERICAN ALONE)
              "C27001B_004",	#Estimate!!Total:!!Under 19 years:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (BLACK OR AFRICAN AMERICAN ALONE)
              "C27001B_005",	#Estimate!!Total:!!19 to 64 years:	HEALTH INSURANCE COVERAGE STATUS BY AGE (BLACK OR AFRICAN AMERICAN ALONE)
              "C27001B_006",	#Estimate!!Total:!!19 to 64 years:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (BLACK OR AFRICAN AMERICAN ALONE)
              "C27001B_007",	#Estimate!!Total:!!19 to 64 years:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (BLACK OR AFRICAN AMERICAN ALONE)
              "C27001B_008",	#Estimate!!Total:!!65 years and over:	HEALTH INSURANCE COVERAGE STATUS BY AGE (BLACK OR AFRICAN AMERICAN ALONE)
              "C27001B_009",	#Estimate!!Total:!!65 years and over:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (BLACK OR AFRICAN AMERICAN ALONE)
              "C27001B_010",	#Estimate!!Total:!!65 years and over:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (BLACK OR AFRICAN AMERICAN ALONE)
              
              #Health Insurance Coverage White, by Age
              "C27001H_001",	#Estimate!!Total:	HEALTH INSURANCE COVERAGE STATUS BY AGE (White NH)
              "C27001H_002",	#Estimate!!Total:!!Under 19 years:	HEALTH INSURANCE COVERAGE STATUS BY AGE (White NH)
              "C27001H_003",	#Estimate!!Total:!!Under 19 years:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (White NH)
              "C27001H_004",	#Estimate!!Total:!!Under 19 years:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (White NH)
              "C27001H_005",	#Estimate!!Total:!!19 to 64 years:	HEALTH INSURANCE COVERAGE STATUS BY AGE (White NH)
              "C27001H_006",	#Estimate!!Total:!!19 to 64 years:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (White NH)
              "C27001H_007",	#Estimate!!Total:!!19 to 64 years:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (White NH)
              "C27001H_008",	#Estimate!!Total:!!65 years and over:	HEALTH INSURANCE COVERAGE STATUS BY AGE (White NH)
              "C27001H_009",	#Estimate!!Total:!!65 years and over:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (White NH)
              "C27001H_010"	#Estimate!!Total:!!65 years and over:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (White NH)
)