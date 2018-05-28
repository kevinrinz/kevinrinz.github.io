* laus.do
* Kevin Rinz
* This version: 2017-11-29
* This script combines all available years of county-level average annual
* labor force data available from BLS's Local Area Unemployment Statistics
* program. Download the average annual county data tables in Excel format
* from https://www.bls.gov/lau/. 

clear *
set more off

global laus "[FILEPATH]" /* Location of the Excel files downloaded from BLS */
global output "[FILEPATH]" /* Location where combined dta file will be saved */

forvalues year = 1990/2016 {
	local yy = substr("`year'",3,2)
	import excel using "$laus/laucnty`yy'.xlsx", clear cellrange(B7)
	rename *, lower
	drop f
	drop if b==""
	rename (b c d e g h i j) (stfips county cntyname year lf emp unemp ur)
	gen cfips = stfips + county
	drop county
	foreach var in stfips year lf emp unemp ur {
		capture replace `var' = "-1" if `var'=="N.A." /* These are estimates for Louisiana parishes heavily impacted by Hurricanes Katrina and Rita */
		destring `var', replace
	}
	tempfile cty`year'
	save `cty`year''
}

use `cty1990', clear
forvalues y = 1991/2016 {
	append using `cty`y''
}

gen postal = substr(cntyname,-2,2)
order stfips postal cfips cntyname
sort cfips year

saveold "$output/laus.dta", replace
