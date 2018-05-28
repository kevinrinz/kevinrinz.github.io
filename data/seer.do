* seer.do
* Kevin Rinz
* This version: 2017-11-29
* This script converts county-level population data downloaded from SEER into
* DTA format. It takes as its input a text file downloaded  from 
* https://seer.cancer.gov/popdata/download.html. This script should work for
* any file downloaded from that site. The corresponding data dictionary is
* available at https://seer.cancer.gov/popdata/popdic.html. Variables have been
* renamed intuitively.

clear *
set more off

global seer "[FILEPATH]" /* Location of text file downloaded from SEER */
global output "[FILEPATH]" /* Location where dta file will be saved */
global name "[FILENAME.EXT]" /* Name of file downloaded from SEER */

infix ///
	year 1-4 ///
	str postal 5-6 ///
	str stfips 7-8 ///
	str county 9-11 ///
	registry 12-13 ///
	race 14 ///
	hispanic 15 ///
	sex 16 ///
	age 17-18 ///
	population 19-26 ///
using "$seer/$name", clear

gen cfips = stfips+county
order year postal stfips cfips
drop county

compress
saveold "$output/seer.dta", replace
