Read Me file for jolts.do
Kevin Rinz
This version: 2017-08-29

This script assembles a dataset that contains all JOLTS variables available through FRED. It takes as its inputs the set of individual-variable CSV files available at https://fred.stlouisfed.org/categories/32241/downloaddata.

The script also requires specification of three filepaths:
1. The folder containing the FRED CSV files
2. The folder where DTA versions of those CSV files will be saved
3. The folder where the final combined dataset will be saved
These filepaths can be specified by editing the global variables on lines 8-10. Note that the folder specified in 2 should contain no other DTA files. Consequently, folders 2 and 3 should be different if you want to simply download new CSVs and run this file when new data are published.

The variables in the final dataset are named using a set of recurring stubs that hopefully make some intuitive sense. Renaming occurs on lines 47-92. The correspondence between the stubs used in this script and exact definitions is described below. Several JOLTS variables pertain to specific industries. JOLTS industrial classification is based on 2012 NAICS codes. See https://www.bls.gov/jlt/jltnaics.htm

Stub		Definition

sa			Seasonally adjusted
nsa			Not seasonally adjusted
lev			Level, in thousands
rate		Rate
layoff		Layoffs and discharges
hire		Hires
open		Job openings
othsep		Other separations
quit		Quits
totsep		Total separations
mw			Midwest Census region
ne			Northeast Census region
so			South Census region
we			West Census region
priv		Private
minelog		Mining and logging
constr		Construction
manuf		Manufacturing
durable		Durable goods manufacturing
nondur		Nondurable goods manufacturing
ttu			Trade, transportation and utilities
wholesale	Wholesale trade
retail		Retail trade
transutil	Transportation, warehousing, and utilities
info		Information
finance		Financial activities
finins		Finance and insurance
rerl		Real estate and rental and leasing
probus		Professional and business services
edhealth	Education and health services
educ		Education services
hcsa		Health care and social assistance
leisure		Leisure and hospitality
artsrec		Arts, entertainment, and recreation
food		Accommodation and food services
othserve	Other services
gov			Government
fedgov		Federal government
slgov		State and local government