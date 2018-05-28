Read Me file for linked_cps.do
Kevin Rinz
This version: 2017-08-07

Disclaimer: I make no guarantees as the the accuracy or completeness of the files produced by this script. I make it available as a starting point for exploratory analysis of the panel dimension of Current Population Survey data.

This script creates uses the longitudinal information in the Current Population Survey to create a panel dataset based on the methods described in Nekarda (2009).

The script takes as its inputs the public use basic monthly CPS files. These files can be obtained in .dat format from http://thedataweb.rm.census.gov/ftp/cps_ftp.html#cpsbasic. They can then be converted into .dta files using scripts available from http://www.nber.org/data/cps_basic_progs.html. Codebooks for the basic monthly files are available from http://ceprdata.org/cps-uniform-data-extracts/cps-basic-programs/cps-basic-documentation/.

The naming convention used for the basic monthly files in this script is cpsbYYYYMM.dta, where YYYY represents the year and MM represents the number of the month (including a leading zero for the first nine months of the year).

The script also requires specification of two filepaths:
1. The folder containing the basic monthly files
2. The folder in which the final linked file will be saved
These filepaths can be specified by editing the global variables on lines 11 and 12.

As written, the script includes several demographic and labor market variables along with those required to create the panel. Variables can be selected or deselected by editing the global variables in lines 14 and 15. The script uses two globals to select variables because some key variables change names between April and May of 2004.

This script as written is set up to combine data from January 2016 through June 2017. As of the creation of this document, the script is capable of creating a panel that begins in January 1996 or later. The length of the panel is constrained only by memory.