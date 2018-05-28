*** This code longitudinally matches Current Population Survey monthly observations, based on
*** methods described in Nekarda (2009). Code is functional from Jan-1996 on (i.e. start_year
*** below can take any value greater than or equal to 1996 and the code will produce unique
*** address, household, and person identifiers).

*** This version current as of 2017-08-07

clear *
set more off

global data "[FILEPATH]"
global output "[FILEPATH]"

global uselist1 hryear* hrmonth hrhhid hrsample hrsersuf huhhnum pulineno hrmis hrintsta pesex gestfips *age pemaritl peeduca *race *hspnon pemlr prdisc pehrusl1 pehract1 peernhry prernwa prmjocc1 prmjind1 peio1cow prunedur pruntype puiodp1 pwsswgt pworwgt pwlgwgt pwcmpwgt prwernal pxhrusl1 pedwlko pejhwant
global uselist2 hryear* hrmonth hrhhid hrhhid2 pulineno hrmis hrintsta pesex gestfips *age pemaritl peeduca *race *hspnon pemlr prdisc pehrusl1 pehract1 peernhry prernwa prmjocc1 prmjind1 peio1cow prunedur pruntype puiodp1 pwsswgt pworwgt pwlgwgt pwcmpwgt prwernal pxhrusl1 pedwlko pejhwant

local start_year 2016
local start_month 1
local end_year 2017
local end_month 6

forvalues year = `start_year'/`end_year' {
	forvalues month = 1/12 {
		local mm = string(`month',"%02.0f")
		if !(`year'==`start_year' & `month'<`start_month') & !(`year'==`end_year' & `month'>`end_month') {
			if (`year'<2004 | (`year'==2004 & `month'<5)) qui append using "$data/cpsb`year'`mm'.dta", keep($uselist1)
			if ((`year'==2004 & `month'>=5) | `year'>2004) qui append using "$data/cpsb`year'`mm'.dta", keep($uselist2)
			disp "`year'-`mm' appended"
		}
	}
}

capture replace hryear4 = hryear+1900 if hryear<=97
gen time_str = string(hryear4) + "-" + string(hrmonth)
gen time = monthly(time_str,"YM")
format time %tm
drop time_str

// Fix inconsistency in name of age variable and drop age flags
capture replace peage = prtage if peage==.
capture drop prtage
capture drop prtfage
capture drop ptage
capture drop pxage

// Fix inconsistency in name of race variable and drop race flags
capture replace ptdtrace = prdtrace if ptdtrace==.
capture replace ptdtrace = perace if ptdtrace==.
capture drop prdtrace
capture drop perace
capture drop pxrace1
capture drop pxrace
capture replace pehspnon = prhspnon if pehspnon==.
capture drop prhspnon

// Translate address ID variables to consistent syntax
capture gen hrsamplet1 = regexr(hrsample,"A","")
capture gen hrsamplet2 = regexr(hrsamplet1,"B","")
capture replace hrsample = hrsamplet2
capture drop hrsamplet1 hrsamplet2

capture {
replace hrsersuf = "00" if hrsersuf=="-1"
replace hrsersuf = "01" if hrsersuf=="A"
replace hrsersuf = "02" if hrsersuf=="B"
replace hrsersuf = "03" if hrsersuf=="C"
replace hrsersuf = "04" if hrsersuf=="D"
replace hrsersuf = "05" if hrsersuf=="E"
replace hrsersuf = "06" if hrsersuf=="F"
replace hrsersuf = "07" if hrsersuf=="G"
replace hrsersuf = "08" if hrsersuf=="H"
replace hrsersuf = "09" if hrsersuf=="I"
replace hrsersuf = "10" if hrsersuf=="J"
replace hrsersuf = "11" if hrsersuf=="K"
replace hrsersuf = "12" if hrsersuf=="L"
replace hrsersuf = "13" if hrsersuf=="M"
replace hrsersuf = "14" if hrsersuf=="N"
replace hrsersuf = "15" if hrsersuf=="O"
replace hrsersuf = "16" if hrsersuf=="P"
replace hrsersuf = "17" if hrsersuf=="Q"
replace hrsersuf = "18" if hrsersuf=="R"
replace hrsersuf = "19" if hrsersuf=="S"
replace hrsersuf = "20" if hrsersuf=="T"
replace hrsersuf = "21" if hrsersuf=="U"
replace hrsersuf = "22" if hrsersuf=="V"
replace hrsersuf = "23" if hrsersuf=="W"
replace hrsersuf = "24" if hrsersuf=="X"
replace hrsersuf = "25" if hrsersuf=="Y"
replace hrsersuf = "26" if hrsersuf=="Z"
}

capture rename huhhnum old_huhhnum

capture gen str hrsample = ""
capture gen str hrsersuf = ""
capture gen str huhhnum = ""

replace hrsample = substr(hrhhid2,1,2) if time>=monthly("2004m5","YM")
replace hrsersuf = substr(hrhhid2,3,2) if time>=monthly("2004m5","YM")
replace huhhnum = substr(hrhhid2,5,1) if time>=monthly("2004m5","YM")
drop hrhhid2
destring huhhnum, replace
capture replace huhhnum = old_huhhnum if time<monthly("2004m5","YM")
capture drop old_huhhnum

// Set up unique address ID
sort hrhhid hrsample hrsersuf huhhnum pulineno hrmis
gen aid = hrhhid + hrsample + hrsersuf
egen aid2 = group(aid)
order hrhhid hrsample hrsersuf huhhnum pulineno hrmis hrmonth
*browse hrhhid hrsample hrsersuf huhhnum pulineno hrmis hrmonth hrintsta time aid2

// Set up unique household ID
sort hrhhid hrsample hrsersuf huhhnum pulineno time
gen hhid_temp = aid + string(huhhnum)
egen hhid_temp2 = group(hhid_temp)

gen valid = inlist(hrintsta,1,2)
gen invalid = inlist(hrintsta,3,4)

preserve
bys hhid_temp2 time: keep if _n==1
sort hhid_temp2 time
forvalues i = 1/7 {
	by hhid_temp2: gen l`i'valid = valid[_n-`i']
	by hhid_temp2: gen f`i'valid = valid[_n+`i']
}

gen pastvalid = inlist(1,l1valid,l2valid,l3valid,l4valid,l5valid,l6valid,l7valid)
gen futurevalid = inlist(1,f1valid,f2valid,f3valid,f4valid,f5valid,f6valid,f7valid)
gen splithh = invalid==1 & pastvalid==1 & futurevalid==1
drop l*valid f*valid

by hhid_temp2: egen hh_is_split = max(splithh)
by hhid_temp2: egen maxhnum = max(huhhnum)
by hhid_temp2: gen splits = sum(splithh)
gen newhnum = huhhnum
replace newhnum = maxhnum + splits if splits>0 & splithh==0

duplicates report hhid_temp2 hrmis

keep hhid_temp2 time newhnum
tempfile newhnum
save `newhnum'
restore

merge m:1 hhid_temp2 time using `newhnum'
drop if _merge==2
drop _merge

drop if invalid==1
gen hid = aid + string(newhnum)
egen hid2 = group(hid)
drop valid invalid hhid_temp hhid_temp2

// Duplicate person records for Type A non-interviews
drop if time==.
sort hid2 pulineno time
gen pid_temp = hid + string(pulineno,"%02.0f")
egen pid_temp2 = group(pid_temp)

isid pid_temp2 time

* Ad-hoc manual fix to drop apparent duplicate observations
	* 11 apparently incorrect observations from Jan-2005 (either observations are extra or hrmis mis-recorded)
	* All are for children under 16
duplicates tag pid_temp2 hrmis, gen(dups)
drop if dups>0 & time==monthly("2005m1","YM")
drop dups

isid pid_temp2 hrmis

sort pid_temp2 time

gen intvw = hrintsta==1
gen nonint = hrintsta==2
bys hid2: egen hh_has_nonint = max(nonint)
bys hid2: egen hh_nonints = sum(nonint)

preserve
keep if hh_has_nonint==1
drop if pulineno==-1
keep hid2 time pulineno
rename time mergetime
rename pulineno newlineno
save "$output/temp_linenos_merge.dta", replace
restore

preserve
keep if hh_has_nonint==1
bys hid2 hrmis: keep if _n==1
xtset hid2 hrmis
gen mergetime = .
forvalues i = 1/7 {
	replace mergetime = L`i'.time if pulineno==-1 & L`i'.hrintsta==1 & mergetime==.
}
forvalues i = 1/7 {
	replace mergetime = F`i'.time if pulineno==-1 & F`i'.hrintsta==1 & mergetime==.
}
keep if pulineno==-1
keep hid2 time mergetime
joinby hid2 mergetime using "$output/temp_linenos_merge.dta", unmatched(master)
capture drop if _merge==2
capture drop _merge
replace newlineno = 1 if mergetime==.
drop mergetime
save "$output/temp_newlineno.dta", replace
restore

drop intvw nonint hh_nonints

joinby hid2 time using "$output/temp_newlineno.dta", unmatched(master)
capture drop if _merge==2
capture drop _merge
replace newlineno = pulineno if newlineno==.

sort hid2 newlineno hrmis
gen pid = hid + string(newlineno,"%02.0f")
egen pid2 = group(pid)
drop pid_temp pid_temp2

preserve
keep aid2 hid2 pid2 hrhhid hrsample hrsersuf huhhnum pulineno
duplicates drop
save "$output/linked_cps_ids.dta", replace
restore

drop aid hid pid hrhhid hrsample hrsersuf huhhnum pulineno
order aid2 hid2 pid2

compress
save "$output/linked_cps.dta", replace

rm "$output/linked_cps_ids.dta"
rm "$output/temp_linenos_merge.dta"
rm "$output/temp_newlineno.dta"
