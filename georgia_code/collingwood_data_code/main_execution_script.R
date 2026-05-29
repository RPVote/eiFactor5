# Loren Collingwood     #
# Main Execution Script #
# Check the harvest functions script that loads some packags and 
# if needed, might need to set up an api password for tidycensus...
library(knitr)
library(kableExtra)

options(knitr.table.format = 'simple')

# Gwinnett #
# FIPS Codes
county <- "135"

acs_dat <- acs_factor5(vars = acs_vars, 
                       geography = "county",
                       year = 2021,
                       state = "GA",
                       county = county)

summary_table <- post_harvest(acs_dat = acs_dat)

knitr::kable(summary_table)


# Gwinnett and Fulton #
# FIPS Codes
county <- c("135", "121")

acs_dat <- acs_factor5(vars = acs_vars, 
            geography = "county",
            year = 2021,
            state = "GA",
            county = county)

summary_table <- post_harvest(acs_dat = acs_dat)


knitr::kable(summary_table)


