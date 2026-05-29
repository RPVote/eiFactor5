# Relevant Population Variables #
acs_vars <- c("B01003_001",  # Total Pop
              "B03002_003",  # White NH
              "B03002_004",  # Black NH
              "B03002_012",  # Hispanic
              "B03002_006",  # Asian NH
              "B03002_007",  # Pac Island NH
              "B03002_005",  # Native American NH
              
              # Median HH Income
              "B19013_001",  # Median HH Income inc (all),
              "B19013B_001", # Median HH Income (black),
              "B19013H_001", # Median White alone NH
              "B19013I_001", # Median HH Income Hispanic 
              "B19013D_001", # Median HH Income Asian
              "B19013E_001", # Pac Island (lowest is county unit)
              "B19013C_001", # Native
              
              # Income Total #
              "B19001_001",  #Income total households
              "B19001B_001", #Income total black households 
              "B19001H_001", #Income total white households 
              "B19001I_001", # Income total Hispanic households
              "B19001D_001", # Income total Asian Households
              "B19001E_001", # Income total Pac Island households
              "B19001C_001", # Income total Native Households
              
              # Higher Income
              # Black
              "B19001B_014", #HH income Black > 100,000 to $124,999
              "B19001B_015", #HH income Black 125,000 to $149,999
              "B19001B_016", #HH income Black 150,000 to $199,999
              "B19001B_017", #HH income Black 200,000 or more
              
              # White
              "B19001H_014", #HH income white > 100,000 to $124,999
              "B19001H_015", #HH income white 125,000 to $149,999
              "B19001H_016", #HH income white 150,000 to $199,999
              "B19001H_017", #HH income white 200,000 or more
              
              # Hispanic
              "B19001I_014", #HH income Hispanic > 100,000 to $124,999
              "B19001I_015", #HH income Hispanic 125,000 to $149,999
              "B19001I_016", #HH income Hispanic 150,000 to $199,999
              "B19001I_017", #HH income Hispanic 200,000 or more
              
              # Asian
              "B19001D_014", #HH income Asian > 100,000 to $124,999
              "B19001D_015", #HH income Asian 125,000 to $149,999
              "B19001D_016", #HH income Asian 150,000 to $199,999
              "B19001D_017", #HH income Asian 200,000 or more
              
              # Pac Island
              "B19001E_014", #HH income PAC > 100,000 to $124,999
              "B19001E_015", #HH income PAC 125,000 to $149,999
              "B19001E_016", #HH income PAC 150,000 to $199,999
              "B19001E_017", #HH income PAC 200,000 or more
              
              # SNAP #
              "B22005B_002", # Snap Black
              "B22005H_002", # Snap White
              "B22005I_002", # SNAP Hispanic,
              "B22005D_002", # SNAP Asian
              "B22005E_002", # Snap PAC
              "B22005C_002", #Snap Native
              
              # SNAP Denominator #
              "B22005B_001", # Snap Black Denominator 
              "B22005H_001", # Snap White Denominator 
              "B22005I_001", # SNAP Hispanic Denominator
              "B22005D_001", # SNAP Asian Denominator
              "B22005E_001", # Snap PAC Denominator
              "B22005C_001", #Snap Native Denominator
              
              # Poverty Status #
              # Black #
              "B17001B_001", # POVERTY STATUS (BLACK OR AFRICAN AMERICAN ALONE) # Denominator
              "B17001B_002", # Income Below poverty level (Black)
              
              # White #
              "B17001H_001", # POVERTY STATUS (NH White) # Denominator
              "B17001H_002", # Income Below poverty level (White)
              
              # Hispanic #
              "B17001I_001", # Poverty Status Hispaanic Denominator
              "B17001I_002", # Income Below poverty level (Hispanic)
              
              # Asian
              "B17001D_001", # Poverty Status Asian Denominator
              "B17001D_002", # Income below poverty level (Asian)
              
              # PAC #
              "B17001E_001", # Poverty Status PAC Denominator
              "B17001E_002", # Income below poverty level (PAC)
              
              # Native #
              "B17001C_001", # Poverty Status Native Denominator
              "B17001C_002", # Income Below poverty level (Native)
              
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
              
              # Poverty Status Hispanic Men #
              
              "B17001I_004",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
              "B17001I_005",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
              "B17001I_006",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
              "B17001I_007",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
              "B17001I_008",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
              "B17001I_009",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
              "B17001I_010",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
              "B17001I_011",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
              "B17001I_012",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
              "B17001I_013",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
              "B17001I_014",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
              "B17001I_015",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
              "B17001I_016",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
              
              # At or Above Poverty status Hispanic Men (use this to combine with above for Denominator)
              "B17001I_033",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!Under 5 years
              "B17001I_034",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!5 years
              "B17001I_035",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!6 to 11 years
              "B17001I_036",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!12 to 14 years
              "B17001I_037",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!15 years
              "B17001I_038",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!16 and 17 years
              "B17001I_039",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!18 to 24 years
              "B17001I_040",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!25 to 34 years
              "B17001I_041",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!35 to 44 years
              "B17001I_042",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!45 to 54 years
              "B17001I_043",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!55 to 64 years
              "B17001I_044",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!65 to 74 years
              "B17001I_045",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!75 years and over
              
              # Poverty Status Black Women #
              
              "B17001I_018",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
              "B17001I_019",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
              "B17001I_020",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
              "B17001I_021",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
              "B17001I_022",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
              "B17001I_023",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
              "B17001I_024",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
              "B17001I_025",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
              "B17001I_026",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
              "B17001I_027",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
              "B17001I_028",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
              "B17001I_029",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
              "B17001I_030",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
              
              # At or Above Poverty status Black Women (use this to combine with above for Denominator)              
              
              "B17001I_047",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!Under 5 years
              "B17001I_048",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!5 years
              "B17001I_049",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!6 to 11 years
              "B17001I_050",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!12 to 14 years
              "B17001I_051",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!15 years
              "B17001I_052",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!16 and 17 years
              "B17001I_053",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!18 to 24 years
              "B17001I_054",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!25 to 34 years
              "B17001I_055",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!35 to 44 years
              "B17001I_056",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!45 to 54 years
              "B17001I_057",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!55 to 64 years
              "B17001I_058",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!65 to 74 years
              "B17001I_059",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!75 years and over              
              
              # Poverty Status Hispanic Men #
              
              "B17001I_004",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
              "B17001I_005",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
              "B17001I_006",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
              "B17001I_007",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
              "B17001I_008",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
              "B17001I_009",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
              "B17001I_010",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
              "B17001I_011",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
              "B17001I_012",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
              "B17001I_013",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
              "B17001I_014",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
              "B17001I_015",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
              "B17001I_016",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
              
              # At or Above Poverty status Hispanic Men (use this to combine with above for Denominator)
              "B17001I_033",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!Under 5 years
              "B17001I_034",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!5 years
              "B17001I_035",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!6 to 11 years
              "B17001I_036",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!12 to 14 years
              "B17001I_037",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!15 years
              "B17001I_038",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!16 and 17 years
              "B17001I_039",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!18 to 24 years
              "B17001I_040",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!25 to 34 years
              "B17001I_041",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!35 to 44 years
              "B17001I_042",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!45 to 54 years
              "B17001I_043",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!55 to 64 years
              "B17001I_044",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!65 to 74 years
              "B17001I_045",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!75 years and over
              
              # Poverty Status Hispanic Women #
              
              "B17001I_018",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
              "B17001I_019",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
              "B17001I_020",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
              "B17001I_021",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
              "B17001I_022",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
              "B17001I_023",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
              "B17001I_024",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
              "B17001I_025",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
              "B17001I_026",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
              "B17001I_027",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
              "B17001I_028",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
              "B17001I_029",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
              "B17001I_030",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
              
              # At or Above Poverty status Hispanic Women (use this to combine with above for Denominator)              
              
              "B17001I_047",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!Under 5 years
              "B17001I_048",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!5 years
              "B17001I_049",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!6 to 11 years
              "B17001I_050",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!12 to 14 years
              "B17001I_051",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!15 years
              "B17001I_052",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!16 and 17 years
              "B17001I_053",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!18 to 24 years
              "B17001I_054",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!25 to 34 years
              "B17001I_055",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!35 to 44 years
              "B17001I_056",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!45 to 54 years
              "B17001I_057",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!55 to 64 years
              "B17001I_058",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!65 to 74 years
              "B17001I_059",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!75 years and over              
              
              # Poverty Status Asian #
              
              # Poverty Status Asian Men #
              
              "B17001D_004",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
              "B17001D_005",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
              "B17001D_006",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
              "B17001D_007",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
              "B17001D_008",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
              "B17001D_009",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
              "B17001D_010",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
              "B17001D_011",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
              "B17001D_012",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
              "B17001D_013",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
              "B17001D_014",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
              "B17001D_015",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
              "B17001D_016",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
              
              # At or Above Poverty status Asian Men (use this to combine with above for Denominator)
              "B17001D_033",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!Under 5 years
              "B17001D_034",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!5 years
              "B17001D_035",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!6 to 11 years
              "B17001D_036",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!12 to 14 years
              "B17001D_037",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!15 years
              "B17001D_038",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!16 and 17 years
              "B17001D_039",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!18 to 24 years
              "B17001D_040",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!25 to 34 years
              "B17001D_041",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!35 to 44 years
              "B17001D_042",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!45 to 54 years
              "B17001D_043",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!55 to 64 years
              "B17001D_044",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!65 to 74 years
              "B17001D_045",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!75 years and over
              
              # Poverty Status Asian Women #
              
              "B17001D_018",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
              "B17001D_019",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
              "B17001D_020",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
              "B17001D_021",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
              "B17001D_022",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
              "B17001D_023",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
              "B17001D_024",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
              "B17001D_025",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
              "B17001D_026",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
              "B17001D_027",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
              "B17001D_028",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
              "B17001D_029",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
              "B17001D_030",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
              
              # At or Above Poverty status Asian Women (use this to combine with above for Denominator)              
              
              "B17001D_047",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!Under 5 years
              "B17001D_048",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!5 years
              "B17001D_049",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!6 to 11 years
              "B17001D_050",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!12 to 14 years
              "B17001D_051",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!15 years
              "B17001D_052",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!16 and 17 years
              "B17001D_053",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!18 to 24 years
              "B17001D_054",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!25 to 34 years
              "B17001D_055",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!35 to 44 years
              "B17001D_056",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!45 to 54 years
              "B17001D_057",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!55 to 64 years
              "B17001D_058",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!65 to 74 years
              "B17001D_059",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!75 years and over              
              
              # Poverty Status Pac Islander #
              
              # Poverty Status Pac Men #
              
              "B17001E_004",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
              "B17001E_005",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
              "B17001E_006",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
              "B17001E_007",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
              "B17001E_008",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
              "B17001E_009",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
              "B17001E_010",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
              "B17001E_011",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
              "B17001E_012",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
              "B17001E_013",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
              "B17001E_014",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
              "B17001E_015",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
              "B17001E_016",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
              
              # At or Above Poverty status Pac Men (use this to combine with above for Denominator)
              "B17001E_033",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!Under 5 years
              "B17001E_034",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!5 years
              "B17001E_035",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!6 to 11 years
              "B17001E_036",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!12 to 14 years
              "B17001E_037",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!15 years
              "B17001E_038",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!16 and 17 years
              "B17001E_039",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!18 to 24 years
              "B17001E_040",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!25 to 34 years
              "B17001E_041",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!35 to 44 years
              "B17001E_042",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!45 to 54 years
              "B17001E_043",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!55 to 64 years
              "B17001E_044",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!65 to 74 years
              "B17001E_045",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!75 years and over
              
              # Poverty Status Pac Women #
              
              "B17001E_018",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
              "B17001E_019",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
              "B17001E_020",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
              "B17001E_021",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
              "B17001E_022",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
              "B17001E_023",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
              "B17001E_024",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
              "B17001E_025",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
              "B17001E_026",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
              "B17001E_027",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
              "B17001E_028",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
              "B17001E_029",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
              "B17001E_030",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
              
              # At or Above Poverty status Pac Women (use this to combine with above for Denominator)              
              
              "B17001E_047",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!Under 5 years
              "B17001E_048",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!5 years
              "B17001E_049",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!6 to 11 years
              "B17001E_050",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!12 to 14 years
              "B17001E_051",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!15 years
              "B17001E_052",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!16 and 17 years
              "B17001E_053",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!18 to 24 years
              "B17001E_054",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!25 to 34 years
              "B17001E_055",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!35 to 44 years
              "B17001E_056",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!45 to 54 years
              "B17001E_057",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!55 to 64 years
              "B17001E_058",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!65 to 74 years
              "B17001E_059",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!75 years and over              
              
              # Poverty Status Native American #
              
              # Poverty Status Native Men #
              
              "B17001C_004",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!Under 5 years
              "B17001C_005",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!5 years
              "B17001C_006",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!6 to 11 years
              "B17001C_007",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!12 to 14 years
              "B17001C_008",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!15 years
              "B17001C_009",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!16 and 17 years
              "B17001C_010",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!18 to 24 years
              "B17001C_011",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!25 to 34 years
              "B17001C_012",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!35 to 44 years
              "B17001C_013",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!45 to 54 years
              "B17001C_014",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!55 to 64 years
              "B17001C_015",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!65 to 74 years
              "B17001C_016",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Male:!!75 years and over
              
              # At or Above Poverty status Native Men (use this to combine with above for Denominator)
              "B17001C_033",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!Under 5 years
              "B17001C_034",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!5 years
              "B17001C_035",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!6 to 11 years
              "B17001C_036",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!12 to 14 years
              "B17001C_037",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!15 years
              "B17001C_038",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!16 and 17 years
              "B17001C_039",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!18 to 24 years
              "B17001C_040",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!25 to 34 years
              "B17001C_041",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!35 to 44 years
              "B17001C_042",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!45 to 54 years
              "B17001C_043",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!55 to 64 years
              "B17001C_044",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!65 to 74 years
              "B17001C_045",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Male:!!75 years and over
              
              # Poverty Status Native Women #
              
              "B17001C_018",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!Under 5 years
              "B17001C_019",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!5 years
              "B17001C_020",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!6 to 11 years
              "B17001C_021",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!12 to 14 years
              "B17001C_022",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!15 years
              "B17001C_023",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!16 and 17 years
              "B17001C_024",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!18 to 24 years
              "B17001C_025",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!25 to 34 years
              "B17001C_026",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!35 to 44 years
              "B17001C_027",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!45 to 54 years
              "B17001C_028",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!55 to 64 years
              "B17001C_029",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!65 to 74 years
              "B17001C_030",	#Estimate!!Total:!!Income in the past 12 months below poverty level:!!Female:!!75 years and over              
              
              # At or Above Poverty status Native Women (use this to combine with above for Denominator)              
              
              "B17001C_047",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!Under 5 years
              "B17001C_048",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!5 years
              "B17001C_049",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!6 to 11 years
              "B17001C_050",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!12 to 14 years
              "B17001C_051",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!15 years
              "B17001C_052",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!16 and 17 years
              "B17001C_053",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!18 to 24 years
              "B17001C_054",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!25 to 34 years
              "B17001C_055",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!35 to 44 years
              "B17001C_056",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!45 to 54 years
              "B17001C_057",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!55 to 64 years
              "B17001C_058",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!65 to 74 years
              "B17001C_059",	#Estimate!!Total:!!Income in the past 12 months at or above poverty level:!!Female:!!75 years and over              
              
              
              ##########################
              # Educational Attainment #
              ##########################
              
              # Black #
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
              
              #Educational Attainment, Hispanic #
              #Total Hispanic
              "C15002I_001",	#Estimate!!Total:	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic NH)
              #Hispanic Men
              "C15002I_003",	#Estimate!!Total:!!Male:!!Less than high school diploma	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic NH)
              "C15002I_004",	#Estimate!!Total:!!Male:!!High school graduate (includes equivalency)	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic NH)
              "C15002I_005",	#Estimate!!Total:!!Male:!!Some college or associate's degree	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic NH)
              "C15002I_006",	#Estimate!!Total:!!Male:!!Bachelor's degree or higher	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic NH)
              #Hispanic Women
              "C15002I_008",	#Estimate!!Total:!!Female:!!Less than high school diploma	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic NH)
              "C15002I_009",	#Estimate!!Total:!!Female:!!High school graduate (includes equivalency)	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic NH)
              "C15002I_010",	#Estimate!!Total:!!Female:!!Some college or associate's degree	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic NH)
              "C15002I_011",  #Estimate!!Total:!!Female:!!Bachelor's degree or higher	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Hispanic NH)
              
              #Educational Attainment, Asian #
              #Total Asian
              "C15002D_001",	#Estimate!!Total:	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Asian NH)
              #Asian Men
              "C15002D_003",	#Estimate!!Total:!!Male:!!Less than high school diploma	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Asian NH)
              "C15002D_004",	#Estimate!!Total:!!Male:!!High school graduate (includes equivalency)	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Asian NH)
              "C15002D_005",	#Estimate!!Total:!!Male:!!Some college or associate's degree	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Asian NH)
              "C15002D_006",	#Estimate!!Total:!!Male:!!Bachelor's degree or higher	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Asian NH)
              #Asian Women
              "C15002D_008",	#Estimate!!Total:!!Female:!!Less than high school diploma	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Asian NH)
              "C15002D_009",	#Estimate!!Total:!!Female:!!High school graduate (includes equivalency)	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Asian NH)
              "C15002D_010",	#Estimate!!Total:!!Female:!!Some college or associate's degree	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Asian NH)
              "C15002D_011",  #Estimate!!Total:!!Female:!!Bachelor's degree or higher	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Asian NH)
              
              #Educational Attainment, PAC #
              #Total PAC
              "C15002E_001",	#Estimate!!Total:	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (PAC)
              #PAC Men
              "C15002E_003",	#Estimate!!Total:!!Male:!!Less than high school diploma	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (PAC NH)
              "C15002E_004",	#Estimate!!Total:!!Male:!!High school graduate (includes equivalency)	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (PAC NH)
              "C15002E_005",	#Estimate!!Total:!!Male:!!Some college or associate's degree	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (PAC NH)
              "C15002E_006",	#Estimate!!Total:!!Male:!!Bachelor's degree or higher	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (PAC NH)
              #PAC Women
              "C15002E_008",	#Estimate!!Total:!!Female:!!Less than high school diploma	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (PAC NH)
              "C15002E_009",	#Estimate!!Total:!!Female:!!High school graduate (includes equivalency)	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (PAC NH)
              "C15002E_010",	#Estimate!!Total:!!Female:!!Some college or associate's degree	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (PAC NH)
              "C15002E_011",  #Estimate!!Total:!!Female:!!Bachelor's degree or higher	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (PAC NH)
              
              #Educational Attainment, Native #
              #Total Native
              "C15002C_001",	#Estimate!!Total:	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Native)
              #Native Men
              "C15002C_003",	#Estimate!!Total:!!Male:!!Less than high school diploma	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Native)
              "C15002C_004",	#Estimate!!Total:!!Male:!!High school graduate (includes equivalency)	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Native)
              "C15002C_005",	#Estimate!!Total:!!Male:!!Some college or associate's degree	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Native)
              "C15002C_006",	#Estimate!!Total:!!Male:!!Bachelor's degree or higher	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Native)
              #Native Women
              "C15002C_008",	#Estimate!!Total:!!Female:!!Less than high school diploma	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Native)
              "C15002C_009",	#Estimate!!Total:!!Female:!!High school graduate (includes equivalency)	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Native)
              "C15002C_010",	#Estimate!!Total:!!Female:!!Some college or associate's degree	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Native)
              "C15002C_011",  #Estimate!!Total:!!Female:!!Bachelor's degree or higher	SEX BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 25 YEARS AND OVER (Native)
              
              
              # Civilian Employment / Unemployment #

              # Civilian Employment Status 16-64 (In labor force), Black Men #
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
              
              # Civilian Employment Status 16-64 (In labor force), Hispanic Men #
              "C23002I_006", 	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Hispanic)
              #Employed vs Unemployed 
              "C23002I_007",	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:!!Employed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Hispanic)
              "C23002I_008",	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:!!Unemployed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Hispanic)
              
              #Civilian Employment Status 16-64, Hispanic Women #
              "C23002I_019",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Hispanic)                
              #Employed vs Unemployed 
              "C23002I_020",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:!!Employed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Hispanic)
              "C23002I_021",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:!!Unemployed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Hispanic)
              
              # Civilian Employment Status 16-64 (In labor force), Asian Men #
              "C23002D_006", 	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Asian)
              #Employed vs Unemployed 
              "C23002D_007",	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:!!Employed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Asian)
              "C23002D_008",	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:!!Unemployed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Asian)
              
              #Civilian Employment Status 16-64, Asian Women #
              "C23002D_019",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Asian)                
              #Employed vs Unemployed 
              "C23002D_020",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:!!Employed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Asian)
              "C23002D_021",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:!!Unemployed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Asian)
              
              # Civilian Employment Status 16-64 (In labor force), Pac Men #
              "C23002E_006", 	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Pac)
              #Employed vs Unemployed 
              "C23002E_007",	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:!!Employed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Pac)
              "C23002E_008",	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:!!Unemployed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Pac)
              
              #Civilian Employment Status 16-64, Pac Women #
              "C23002E_019",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Pac)                
              #Employed vs Unemployed 
              "C23002E_020",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:!!Employed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Pac)
              "C23002E_021",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:!!Unemployed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Pac)
              
              # Civilian Employment Status 16-64 (In labor force), Native Men #
              "C23002C_006", 	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Native)
              #Employed vs Unemployed 
              "C23002C_007",	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:!!Employed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Native)
              "C23002C_008",	#Estimate!!Total:!!Male:!!16 to 64 years:!!In labor force:!!Civilian:!!Unemployed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Native)
              
              #Civilian Employment Status 16-64, Native Women #
              "C23002C_019",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Native)                
              #Employed vs Unemployed 
              "C23002C_020",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:!!Employed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Native)
              "C23002C_021",	#Estimate!!Total:!!Female:!!16 to 64 years:!!In labor force:!!Civilian:!!Unemployed	SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER (Native)
              
              
              # Disability status, ages 18-64 Black
              "B18101B_005",	#Estimate!!Total:!!18 to 64 years:	AGE BY DISABILITY STATUS (BLACK OR AFRICAN AMERICAN ALONE)
              "B18101B_006",	#Estimate!!Total:!!18 to 64 years:!!With a disability	AGE BY DISABILITY STATUS (BLACK OR AFRICAN AMERICAN ALONE)
              
              # Disability status, ages 18-64 White
              "B18101H_005",	#Estimate!!Total:!!18 to 64 years:	AGE BY DISABILITY STATUS (WHITE ALONE, NOT HISPANIC OR LATINO)
              "B18101H_006",	#Estimate!!Total:!!18 to 64 years:!!With a disability	AGE BY DISABILITY STATUS (WHITE ALONE, NOT HISPANIC OR LATINO)
              
              # Disability status, ages 18-64 Hispanic
              "B18101I_005",	#Estimate!!Total:!!18 to 64 years:	AGE BY DISABILITY STATUS (Hispanic)
              "B18101I_006",	#Estimate!!Total:!!18 to 64 years:!!With a disability	AGE BY DISABILITY STATUS (Hispanic)
              
              # Disability status, ages 18-64 Asian
              "B18101D_005",	#Estimate!!Total:!!18 to 64 years:	AGE BY DISABILITY STATUS (Asian)
              "B18101D_006",	#Estimate!!Total:!!18 to 64 years:!!With a disability	AGE BY DISABILITY STATUS (Asian)
              
              # Disability status, ages 18-64 Pac
              "B18101E_005",	#Estimate!!Total:!!18 to 64 years:	AGE BY DISABILITY STATUS (Pac)
              "B18101E_006",	#Estimate!!Total:!!18 to 64 years:!!With a disability	AGE BY DISABILITY STATUS (Pac)
              
              # Disability status, ages 18-64 Native
              "B18101C_005",	#Estimate!!Total:!!18 to 64 years:	AGE BY DISABILITY STATUS (Native)
              "B18101C_006",	#Estimate!!Total:!!18 to 64 years:!!With a disability	AGE BY DISABILITY STATUS (Native)
              
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
              "C27001H_010",	#Estimate!!Total:!!65 years and over:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (White NH),
              
              #Health Insurance Coverage Hispanic, by Age
              "C27001I_001",	#Estimate!!Total:	HEALTH INSURANCE COVERAGE STATUS BY AGE (Hispanic)
              "C27001I_002",	#Estimate!!Total:!!Under 19 years:	HEALTH INSURANCE COVERAGE STATUS BY AGE (Hispanic)
              "C27001I_003",	#Estimate!!Total:!!Under 19 years:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Hispanic)
              "C27001I_004",	#Estimate!!Total:!!Under 19 years:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Hispanic)
              "C27001I_005",	#Estimate!!Total:!!19 to 64 years:	HEALTH INSURANCE COVERAGE STATUS BY AGE (Hispanic)
              "C27001I_006",	#Estimate!!Total:!!19 to 64 years:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Hispanic)
              "C27001I_007",	#Estimate!!Total:!!19 to 64 years:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Hispanic)
              "C27001I_008",	#Estimate!!Total:!!65 years and over:	HEALTH INSURANCE COVERAGE STATUS BY AGE (Hispanic)
              "C27001I_009",	#Estimate!!Total:!!65 years and over:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Hispanic)
              "C27001I_010",	#Estimate!!Total:!!65 years and over:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Hispanic)
              
              #Health Insurance Coverage Asian, by Age
              "C27001D_001",	#Estimate!!Total:	HEALTH INSURANCE COVERAGE STATUS BY AGE (Asian)
              "C27001D_002",	#Estimate!!Total:!!Under 19 years:	HEALTH INSURANCE COVERAGE STATUS BY AGE (Asian)
              "C27001D_003",	#Estimate!!Total:!!Under 19 years:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Asian)
              "C27001D_004",	#Estimate!!Total:!!Under 19 years:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Asian)
              "C27001D_005",	#Estimate!!Total:!!19 to 64 years:	HEALTH INSURANCE COVERAGE STATUS BY AGE (Asian)
              "C27001D_006",	#Estimate!!Total:!!19 to 64 years:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Asian)
              "C27001D_007",	#Estimate!!Total:!!19 to 64 years:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Asian)
              "C27001D_008",	#Estimate!!Total:!!65 years and over:	HEALTH INSURANCE COVERAGE STATUS BY AGE (Asian)
              "C27001D_009",	#Estimate!!Total:!!65 years and over:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Asian)
              "C27001D_010",	#Estimate!!Total:!!65 years and over:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Asian)
              
              #Health Insurance Coverage Pac, by Age
              "C27001E_001",	#Estimate!!Total:	HEALTH INSURANCE COVERAGE STATUS BY AGE (Pac)
              "C27001E_002",	#Estimate!!Total:!!Under 19 years:	HEALTH INSURANCE COVERAGE STATUS BY AGE (Pac)
              "C27001E_003",	#Estimate!!Total:!!Under 19 years:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Pac)
              "C27001E_004",	#Estimate!!Total:!!Under 19 years:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Pac)
              "C27001E_005",	#Estimate!!Total:!!19 to 64 years:	HEALTH INSURANCE COVERAGE STATUS BY AGE (Pac)
              "C27001E_006",	#Estimate!!Total:!!19 to 64 years:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Pac)
              "C27001E_007",	#Estimate!!Total:!!19 to 64 years:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Pac)
              "C27001E_008",	#Estimate!!Total:!!65 years and over:	HEALTH INSURANCE COVERAGE STATUS BY AGE (Pac)
              "C27001E_009",	#Estimate!!Total:!!65 years and over:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Pac)
              "C27001E_010",	#Estimate!!Total:!!65 years and over:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Pac)
              
              #Health Insurance Coverage Native, by Age
              "C27001C_001",	#Estimate!!Total:	HEALTH INSURANCE COVERAGE STATUS BY AGE (Native)
              "C27001C_002",	#Estimate!!Total:!!Under 19 years:	HEALTH INSURANCE COVERAGE STATUS BY AGE (Native)
              "C27001C_003",	#Estimate!!Total:!!Under 19 years:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Native)
              "C27001C_004",	#Estimate!!Total:!!Under 19 years:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Native)
              "C27001C_005",	#Estimate!!Total:!!19 to 64 years:	HEALTH INSURANCE COVERAGE STATUS BY AGE (Native)
              "C27001C_006",	#Estimate!!Total:!!19 to 64 years:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Native)
              "C27001C_007",	#Estimate!!Total:!!19 to 64 years:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Native)
              "C27001C_008",	#Estimate!!Total:!!65 years and over:	HEALTH INSURANCE COVERAGE STATUS BY AGE (Native)
              "C27001C_009",	#Estimate!!Total:!!65 years and over:!!With health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Native)
              "C27001C_010"	#Estimate!!Total:!!65 years and over:!!No health insurance coverage	HEALTH INSURANCE COVERAGE STATUS BY AGE (Native)
              
)