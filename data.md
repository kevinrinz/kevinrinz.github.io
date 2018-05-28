---
layout: default
---

## Data

### Code for using public data

**JOLTS:** Create a single Stata dataset that contains the full time series of all JOLTS variables available through FRED, named in a way that is comprehensible to humans. (do, readme)

**Longitudinally linked basic monthly CPS:** Panelize the Current Population Survey based on the methods described in Nekarda (2009), retaining key demographic and labor market variables. (do, readme, example dta, Nekarda 2009)

**Common county-level datasets:** Assemble panels of measures commonly used as covariates or outcomes of interest in county-level analysis.
- Employment, unemployment, and participation from BLS's Local Area Unemployment Statistics (LAUS) program
  - Average annual measures of employment, unemployment, and labor force participation, available since 1990
  - do, dta
- Income and poverty data from Census’s Small Area Income and Poverty Estimates (SAIPE) program
  - Annual data on poverty rates for all individuals, children under 18, and children 5-17 in families, as well as median household income
  - do, dta
- Population data from the Surveillance, Epidemiology, and End Results (SEER) program
  - Annual data on the population of each county for groups defined by age, race, ethnicity, and sex, available since 1969
  - do, example dta - all counties, 1990-2015