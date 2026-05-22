# eiFactor5

Totality of Circumstances Factor 5 Analysis Using Census ACS Data

## Overview

`eiFactor5` retrieves American Community Survey (ACS) data from the U.S. Census Bureau and computes 12 socioeconomic status (SES) indicators by racial/ethnic group for Voting Rights Act Section 2 "totality of circumstances" Factor 5 analysis.

Under the *Gingles* framework, Factor 5 examines whether members of the minority group bear the effects of discrimination in areas such as education, employment, and health, which hinder their ability to participate effectively in the political process.

Part of the [eiCompare](https://github.com/RPVote/eiCompare) ecosystem for voting rights analysis.

## Installation

```r
# install.packages("devtools")
devtools::install_github("RPVote/eiFactor5")
```

You will also need a Census API key:

```r
tidycensus::census_api_key("YOUR_KEY_HERE", install = TRUE)
```

Get a free key at: https://api.census.gov/data/key_signup.html

## Quick Start

```r
library(eiFactor5)

# Fetch county-level data for Mississippi: White vs Black
dat <- f5_fetch(state = "MS", geography = "county", year = 2022,
                groups = c("white", "black"))

# Comparison table with t-tests
f5_table(dat, ref_group = "white", compare_groups = "black")

# Bar chart
f5_plot(dat, ref_group = "white", compare_groups = "black")

# Detailed pairwise statistical tests
f5_compare(dat, ref_group = "white", compare_group = "black")
```

## SES Indicators

The package computes 12 indicators for each racial/ethnic group:

| Indicator | ACS Table | Summary |
|---|---|---|
| Median Household Income | B19013 | Median |
| Pct. HH Income > $100K | B19001 | Proportion |
| Pct. HH Income > $125K | B19001 | Proportion |
| Pct. Receiving SNAP | B22005 | Proportion |
| Pct. Below Poverty Line | B17001 | Proportion |
| Pct. Below Poverty (Children) | B17001 | Proportion |
| Pct. Below Poverty (Adults) | B17001 | Proportion |
| Pct. Less than HS Diploma | C15002 | Proportion |
| Pct. Bachelor's Degree+ | C15002 | Proportion |
| Pct. Unemployed (16-64) | C23002 | Proportion |
| Pct. Disabled (18-64) | B18101 | Proportion |
| Pct. Uninsured (19-64) | C27001 | Proportion |

## Racial/Ethnic Groups

- **White**: White alone, not Hispanic or Latino (ACS suffix H)
- **Black**: Black or African American alone (suffix B)
- **Hispanic**: Hispanic or Latino (suffix I)
- **AAPI**: Asian alone + Native Hawaiian/Pacific Islander alone (suffixes D + E)
- **Native**: American Indian and Alaska Native alone (suffix C)

## Functions

| Function | Description |
|---|---|
| `f5_fetch()` | Retrieve ACS data and compute SES indicators |
| `f5_table()` | Create comparison table with significance tests |
| `f5_compare()` | Run pairwise statistical tests |
| `f5_plot()` | Generate bar or dot chart visualizations |
| `f5_map()` | Create choropleth maps of individual indicators |
| `f5_indicators()` | List available SES indicators and metadata |

## Geographic Levels

Data can be retrieved at:
- State level (all states)
- County level (within a state)
- Census tract level (within counties)
- Block group level (within counties)
- Congressional district level

## Example: Northern New Mexico

```r
# Northern NM: Native vs Hispanic vs White, tract-level
north_nm_counties <- c("049", "039", "055", "045", "031", "043", "028", "007")

dat <- f5_fetch(state = "NM", county = north_nm_counties,
                geography = "tract", year = 2022,
                groups = c("white", "hispanic", "native"),
                geometry = TRUE)

# Comparison table
f5_table(dat, ref_group = "white",
         compare_groups = c("hispanic", "native"))

# Poverty map for Native Americans
f5_map(dat, indicator = "pct_below_poverty", group = "native")
```

## Citation

If you use this package in academic work, please cite:

> Collingwood, L. (2026). eiFactor5: Totality of Circumstances Factor 5
> Analysis Using Census ACS Data. R package version 1.0.0.
> https://github.com/RPVote/eiFactor5

## License

GPL-3
