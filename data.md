---
layout: default
---

## Data

### Data from papers

**Re-examining Regional Income Convergence: A Distributional Approach**
- State-level income distribution data, 1998--2019. Includes data for full populations and subgroups defined by gender and race/ethnicity. ([readme](./data/state_income_data_readme.pdf){:target="_blank"}, [data](./data/state_income_data.zip){:target="_blank"})

**Who Values Human Capitalists' Human Capital? Healthcare Spending and Physician Earnings**
- Data on mean physician earnings in 2017 for the 125 largest commuting zones (1990 vintage), for all physicians and by Medicare specialty. ([readme](./data/physician_earnings_data_readme.pdf){:target="_blank"}, [dta](./data/physician_earnings_data.dta){:target="_blank"}, [csv](./data/physician_earnings_data.csv){:target="_blank"}, [download all](./data/physician_earnings_data.zip){:target="_blank"})

### Code for using public data
<!---
**JOLTS:** Create a single Stata dataset that contains the full time series of all JOLTS variables available through FRED, named in a way that is comprehensible to humans. ([do](./data/jolts.do){:target="_blank"}, [readme](./data/jolts_readme.txt){:target="_blank"})
--->

**Longitudinally linked basic monthly CPS:** Panelize the Current Population Survey based on the methods described in Nekarda (2009), retaining key demographic and labor market variables. ([do](./data/linked_cps.do){:target="_blank"}, [readme](./data/linked_cps_readme.txt){:target="_blank"}, [example dta](./data/linked_cps.zip){:target="_blank"}, [Nekarda 2009](https://chrisnekarda.com/2009/05/a-longitudinal-analysis-of-the-current-population-survey/){:target="_blank"})

**Common county-level datasets:** Assemble panels of measures commonly used as covariates or outcomes of interest in county-level analysis.
- Employment, unemployment, and participation from BLS's Local Area Unemployment Statistics (LAUS) program
  - Average annual measures of employment, unemployment, and labor force participation, available since 1990
  - [do](./data/laus.do){:target="_blank"}, [dta](./data/laus.zip){:target="_blank"}
- Income and poverty data from Census’s Small Area Income and Poverty Estimates (SAIPE) program
  - Annual data on poverty rates for all individuals, children under 18, and children 5-17 in families, as well as median household income
  - [do](./data/saipe.do){:target="_blank"}, [dta](./data/saipe.zip){:target="_blank"}
- Population data from the Surveillance, Epidemiology, and End Results (SEER) program
  - Annual data on the population of each county for groups defined by age, race, ethnicity, and sex, available since 1969
  - [do](./data/seer.do){:target="_blank"}, [example dta](./data/seer.zipx){:target="_blank"} - all counties, 1990-2015
