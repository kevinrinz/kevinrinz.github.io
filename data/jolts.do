* This script assembles a dataset that contains all JOLTS variables available
* through FRED. It takes as its inputs the set of individual-variable CSV files
* available at https://fred.stlouisfed.org/categories/32241/downloaddata
* This version: 2017-08-29

clear *
set more off

global csv "[FILEPATH]" /* Location of CSVs downloaded from FRED */
global dta "[FILEPATH]" /* DTA versions of FRED CSVs will be saved here (should be different from output) */
global output "[FILEPATH]" /* Final combined dataset will be saved here*/

local files : dir "$csv" files "*.csv"
foreach f in `files' {
	import delimited using "$csv/`f'", varn(1) case(lower) clear
	local name = subinstr("`f'",".csv","",1)
	rename value `name'
	save "$dta/`name'.dta", replace
}

local counter = 0
local files : dir "$dta" files "*.dta"
foreach f in `files' {
	local counter = `counter' + 1
	if `counter'==1 use "$dta/`f'", clear
	if `counter'>1 {
		merge 1:1 date using "$dta/`f'"
		asser _m==3
		drop _m
	}
}

foreach f in `files' {
	rm "$dta/`f'"
}

foreach var of varlist _all {
	label var `var' ""
}

gen ddate = daily(date,"YMD")
format ddate %td
gen year = year(ddate)
gen month = month(ddate)
gen mdate = substr(date,1,7)
drop date ddate
gen date=monthly(mdate,"YM")
format date %tm
drop mdate
order date year month

capture rename *, lower
rename jts* jt*_sa
rename jtu* jt*_nsa
rename *ldl* *_layoff_lev*
rename *ldr* *_layoff_rate*
rename *hil* *_hire_lev*
rename *hir_* *_hire_rate_*
rename *jol* *_open_lev*
rename *jor* *_open_rate*
rename *osl* *_othsep_lev*
rename *osr* *_othsep_rate*
rename *qul* *_quit_lev*
rename *qur* *_quit_rate*
rename *tsl* *_totsep_lev*
rename *tsr* *_totsep_rate*
rename jt00mw_* *_mw
rename jt00ne_* *_ne
rename jt00so_* *_so
rename jt00we_* *_we
rename jt1000_* *_priv
rename jt110099_* *_minelog
rename jt2300_* *_constr
rename jt3000_* *_manuf
rename jt3200_* *_durable
rename jt3400_* *_nondur
rename jt4000_* *_ttu
rename jt4200_* *_wholesale
rename jt4400_* *_retail
rename jt480099_* *_transutil
rename jt5100_* *_info
rename jt510099_* *_finance
rename jt5200_* *_finins
rename jt5300_* *_rerl
rename jt540099_* *_probus
rename jt540099sl_nsa othsep_lev_nsa_probus
rename jt540099sr_nsa othsep_rate_nsa_probus
rename jt540099ul_nsa quit_lev_nsa_probus
rename jt6000_* *_edhealth
rename jt6100_* *_educ
rename jt6200_* *_hcsa
rename jt7000_* *_leisure
rename jt7100_* *_artsrec
rename jt7200_* *_food
rename jt8100_* *_othserve
rename jt9000_* *_gov
rename jt9100_* *_fedgov
rename jt9200_* *_slgov
rename jt_* *

save "$output/jolts.dta", replace
