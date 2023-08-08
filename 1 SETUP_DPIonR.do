*** Effect of DPI on R project

* SETUP  
*  - Loading the dataset
*  - Calculation of Daily Repruduction Numbers and Death Rates
*  - Calculation of DPI indicators: Treatment and Later Changes
*  - Calculation of Social Mobility Index by PCA
*  - Calculation of Control variables including imported cases
*  - Descriptive Stats and Graphs

********************************************************************************
*  - Loading the dataset

cd "/Users/oliverracz/!RESEARCH/Covid 19 A/Git"
use "Data/Panel.dta", clear

macro drop _

********************************************************************************
*  - Calculation of Daily Repruduction Numbers and Death Rates

do "Do/1a R DR.do"


********************************************************************************
*  - Calculation of Outcome variable R

do "Do/1b DPIs.do"

********************************************************************************
*  - Calculation of Social Mobility Index by PCA

global GMR grocery retail parks stations workplaces residential

do "Do/2 Social Activity.do"

********************************************************************************
*  - Calculation of Control variables including imported cases

do "Do/3 Controls.do"


********************************************************************************
*  - Descriptive Stats and Graphs

do "Do/4 Descriptives.do"


save "Data/Panel_prepared.dta", replace
