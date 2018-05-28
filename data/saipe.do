* saipe.do
* Kevin Rinz
* This version: 2017-11-29
* This script assembles a dataset that contains all available years of
* county-level poverty and median household income estimates from the 
* Small Area Income and Poverty Estimates (SAIPE) program. Raw files are
* available at https://www.census.gov/programs-surveys/saipe/data/datasets.All.html.
* Download the state and county estimate files. For pre-2003 years, save by
* copying the text of each file and saving as txt (or modiy the file extension
* used in the code below. Variables are named using the following conventions:
	* pov = poverty
	* medhhinc = median household income
	* all = all people
	* 017 = all children age 0-17
	* 517f = children age 5-17 in families
	* n = number of people
	* r = rate
	* ci90lb = lower bound for 90% confidence interval
	* ci90ub = upper bound for 90% confidence interval

clear *
set more off

global saipe "[FILEPATH]" /* Location of downoaded SAIPE files */
global output "[FILEPATH]" /* Location where combined dta file will be saved */

forvalues year = 1989/2015 {
	local yy = substr("`year'",3,2)
	disp "`yy'"
	if `year'<2003 {
		capture {
			infix ///
				stfips 				1-2		///
				county 				4-6		///
				pov_all_n			8-15	///
				pov_all_n_ci90lb	17-24	///
				pov_all_n_ci90ub	26-33	///
				pov_all_r 			35-38	///
				pov_all_r_ci90lb	40-43	///
				pov_all_r_ci90ub	45-48	///
				pov_017_n			50-57	///
				pov_017_n_ci90lb	59-66	///
				pov_017_n_ci90ub	68-75	///
				pov_017_r			77-80	///
				pov_017_r_ci90lb	82-85	///
				pov_017_r_ci90ub	87-90	///
				pov_517f_n			92-99	///
				pov_517f_n_ci90lb	101-108	///
				pov_517f_n_ci90ub	110-117	///
				pov_517f_r			119-122	///
				pov_517f_r_ci90lb	124-127	///
				pov_517f_r_ci90ub	129-132	///
				medhhinc			134-139	///
				medhhinc_ci90lb		141-146	///
				medhhinc_ci90ub		148-153	///
				str cntyname		194-238	///
				str postal			240-241	///
			using "$saipe/est`yy'all.txt", clear
			drop if county==0
			tostring stfips, replace format(%02.0f)
			tostring county, replace format(%03.0f)
			gen cfips = stfips+county
			destring stfips, replace
			drop county
			gen year = `year'
			order stfips cfips postal cntyname year
			foreach var of varlist pov* medhhinc* {
				destring `var', replace
			}
			tempfile pov`year'
			save `pov`year''
		}
	}
	if inrange(`year',2003,2004) {
		import excel using "$saipe/est`yy'all.xls", clear cellrange(A3)
		rename *, lower
		drop z aa ab ac ad ae
		rename (a b c d e f g h i j k l m n o p q r s t u v w x y) (stfips county postal cntyname pov_all_n pov_all_n_ci90lb pov_all_n_ci90ub pov_all_r pov_all_r_ci90lb pov_all_r_ci90ub pov_017_n pov_017_n_ci90lb pov_017_n_ci90ub pov_017_r pov_017_r_ci90lb pov_017_r_ci90ub pov_517f_n pov_517f_n_ci90lb pov_517f_n_ci90ub pov_517f_r pov_517f_r_ci90lb pov_517f_r_ci90ub medhhinc medhhinc_ci90lb medhhinc_ci90ub)
		drop if county==0
		tostring stfips, replace format(%02.0f)
		tostring county, replace format(%03.0f)
		gen cfips = stfips+county
		destring stfips, replace
		drop county
		gen year = `year'
		order stfips cfips postal cntyname year
		foreach var of varlist pov* medhhinc* {
			destring `var', replace
		}
		tempfile pov`year'
		save `pov`year''
	}
	if inrange(`year',2005,2012) {
		import excel using "$saipe/est`yy'all.xls", clear cellrange(A4)
		rename *, lower
		drop z aa ab ac ad ae
		rename (a b c d e f g h i j k l m n o p q r s t u v w x y) (stfips county postal cntyname pov_all_n pov_all_n_ci90lb pov_all_n_ci90ub pov_all_r pov_all_r_ci90lb pov_all_r_ci90ub pov_017_n pov_017_n_ci90lb pov_017_n_ci90ub pov_017_r pov_017_r_ci90lb pov_017_r_ci90ub pov_517f_n pov_517f_n_ci90lb pov_517f_n_ci90ub pov_517f_r pov_517f_r_ci90lb pov_517f_r_ci90ub medhhinc medhhinc_ci90lb medhhinc_ci90ub)
		capture drop if postal==""
		capture destring stfips, replace
		capture destring county, replace
		drop if county==0
		tostring stfips, replace format(%02.0f)
		tostring county, replace format(%03.0f)
		gen cfips = stfips+county
		destring stfips, replace
		drop county
		gen year = `year'
		order stfips cfips postal cntyname year
		foreach var of varlist pov* medhhinc* {
			destring `var', replace
		}
		tempfile pov`year'
		save `pov`year''
	}
	if inrange(`year',2013,2015) {
		import excel using "$saipe/est`yy'all.xls", clear cellrange(A5)
		rename *, lower
		drop z aa ab ac ad ae
		rename (a b c d e f g h i j k l m n o p q r s t u v w x y) (stfips county postal cntyname pov_all_n pov_all_n_ci90lb pov_all_n_ci90ub pov_all_r pov_all_r_ci90lb pov_all_r_ci90ub pov_017_n pov_017_n_ci90lb pov_017_n_ci90ub pov_017_r pov_017_r_ci90lb pov_017_r_ci90ub pov_517f_n pov_517f_n_ci90lb pov_517f_n_ci90ub pov_517f_r pov_517f_r_ci90lb pov_517f_r_ci90ub medhhinc medhhinc_ci90lb medhhinc_ci90ub)
		capture destring stfips, replace
		capture destring county, replace
		drop if county==0
		tostring stfips, replace format(%02.0f)
		tostring county, replace format(%03.0f)
		gen cfips = stfips+county
		destring stfips, replace
		drop county
		gen year = `year'
		order stfips cfips postal cntyname year
		foreach var of varlist pov* medhhinc* {
			destring `var', replace
		}
		tempfile pov`year'
		save `pov`year''
	}
}

use `pov1989', clear
forvalues y = 1990/2015 {
	capture append using `pov`y''
}

sort cfips year

saveold "$output/saipe.dta", replace
