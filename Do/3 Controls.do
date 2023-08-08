*  Calculation of Control variables including imported cases

* Other Interventions

foreach var of varlist travelc testing contact masks incomes relief infoc elderly{
qui tab `var', gen(`var'_)
drop `var'_1
}


* weekly seasonality dummies
cap gen dow=dow(date) /*0 is sunday*/
lab def dow 0 "Sun" 1 "Mon" 2 "Tue" 3 "Wen" 4 "Thu" 5 "Fri" 6 "Sat"
lab val dow dow

recode dow (0 = 1) (6 = 1) (nonm = 0), g(weekend)
qui tab dow, g(S)


* Imported cases (based on cross border travels)
qui su imc
gen Imp = imc/r(sd)

lab var Imp "Imported cases \$ _{ t}\$"

* Share of Positive tests 

gen positives = newcases/tested
lab var positives "Share of positive COVID-19 tests on this date"

replace tested = 0 if tested==. | tested<0
replace positives = 0 if positives==. | positives<0

******INFORMATION ******

* Foreign Threat
disp "`ps'"
xtset id tDP
* neighbor reproduction rate
replace n1_ndeaths = 0 if n1_ndeaths==.
replace n1_ncases = 0 if n1_ncases==.
replace n1_infected = 0 if n1_infected==.
replace n1_pop = 0 if n1_pop==.

egen foreign_d = rowtotal(n1_ndeaths)
egen foreign_c = rowtotal(n1_ncases)
egen foreign_inf = rowtotal(n1_infected)
egen foreign_pop = rowtotal(n1_pop)
gen fthreat = foreign_c/foreign_pop*10000 /*l.foreign_inf*/
gen fthreat2 = foreign_d/foreign_pop*10000

replace fthreat = 0 if fthreat == .
replace fthreat2 = 0 if fthreat2 == .


* Domestic Threat

gen dthreat= newc/population*10000
gen dthreat2= newd/population*10000

* Local popularity of policies
replace n1_places = 0 if n1_places==.
replace n1_mobility = 0 if n1_mobility==.


* coverage of policies at neighbors

gen pplace = n1_places / n1_number
gen pmobility = n1_mobility / n1_number


* Time lags
xtset id tDP
	* Number of lags in Information set
sca K=14

	cap drop f1 f7
gen f1 = l1.fthreat
gen f1death = l1.fthreat2
gen d1 = l1.dthreat
gen d1death = l1.dthreat2
gen p1place = l1.pplace
gen p1mob = l1.pmobility

lab var f1 "Neighbors' Cases \$ _{t-1}\$"
lab var f1death "Neighbors' Deaths \$ _{t-1}\$"
lab var d1 "Cases \$ _{t-1}\$"
lab var d1death "Deaths \$ _{t-1}\$"
lab var p1place "Neighbors' Place R's \$ _{t-1}\$"
lab var p1mob "Neighbors' Mobility R's \$ _{t-1}\$"


global dthreat  d1 d1death
global fthreat  f1 f1death
global popularity  p1place p1mob

gen f7 = l2.fthreat
gen f7death = l2.fthreat2
gen d7 = l2.dthreat
gen d7death = l2.dthreat2
gen p7place =l2.pplace
gen p7mob = l2.pmobility

forvalues kk=3(1)7{

replace f7 = f7 + l`kk'.fthreat
replace f7death = f7death + l`kk'.fthreat2
replace d7 = d7 + l`kk'.dthreat
replace d7death = d7death + l`kk'.dthreat2
replace p7place = p7place + l`kk'.pplace
replace p7mob =  p7mob + l`kk'.pmobility
}

gen f`=K' = l7.fthreat
gen f`=K'death = l7.fthreat2
gen d`=K' = l7.dthreat
gen d`=K'death = l7.dthreat2
gen p`=K'place =l7.pplace
gen p`=K'mob = l7.pmobility

forvalues kk=8(1)`=K'{

replace f`=K'		= f`=K' + l`kk'.fthreat
replace f`=K'death	= f`=K'death + l`kk'.fthreat2
replace d`=K'		= d`=K' + l`kk'.dthreat
replace d`=K'death	= d`=K'death + l`kk'.dthreat2
replace p`=K'place	= p`=K'place + l`kk'.pplace
replace p`=K'mob	= p`=K'mob + l`kk'.pmobility
}

replace f7 = f7/6
replace f7death = f7death/6
replace d7 = d7/6
replace d7death = d7death/6
replace p7place = p7place/6
replace p7mob =  p7mob/6

replace f`=K' = f`=K'/`=K-7'
replace f`=K'death = f`=K'death/`=K-7'
replace d`=K' = d`=K'/`=K-7'
replace d`=K'death = d`=K'death/`=K-7'
replace p`=K'place = p`=K'place/`=K-7'
replace p`=K'mob =  p`=K'mob/`=K-7'


lab var f7 "\$\sum_{s=2}^7\$N's' Cases \$ _{t-s}\$"
lab var f7death "\$\sum_{s=2}^7\$N's' Deaths \$ _{t-s}\$"
lab var d7 "\$\sum_{s=2}^7\$Cases \$ _{t-s}\$"
lab var d7death "\$\sum_{s=2}^7\$Deaths \$ _{t-s}\$"
lab var p7place "\$\sum_{s=2}^7\$N's' Place R's \$ _{t-s}\$"
lab var p7mob "\$\sum_{s=2}^7\$N's' Mobility R's \$ _{t-s}\$"

lab var f`=K' "\$\sum_{s=8}^14\$N's' Cases \$ _{t-s}\$"
lab var f`=K'death "\$\sum_{s=8}^14\$N's' Deaths \$ _{t-s}\$"
lab var d`=K' "\$\sum_{s=8}^14\$Cases \$ _{t-s}\$"
lab var d`=K'death "\$\sum_{s=8}^14\$Deaths \$ _{t-s}\$"
lab var p`=K'place "\$\sum_{s=8}^14\$N's' Place R's \$ _{t-s}\$"
lab var p`=K'mob "\$\sum_{s=8}^14\$N's' Mobility R's \$ _{t-s}\$"

global dthreat  d1 d7 d`=K' d1death d7death d`=K'death
global fthreat  f1 f7 f`=K' f1death f7death f`=K'death
global popularity p1place p7place p`=K'place p1mob p7mob p`=K'mob

save "Data/Panel_2.dta", replace

* DPIs at neighoring countries

clear
set obs 30000
gen date = _n if inrange(_n, 21914, 22415)
drop if date == .
tempfile date
save `date'


import delimited "/Users/oliverracz/!RESEARCH/Covid 19 A/raw data/Borders.txt", delimiter(";") varnames(1) encoding(UTF-8) clear
drop v5

gen iso2 = country_border_code
merge m:1 iso2 using  "/Users/oliverracz/!RESEARCH/Covid 19 A/raw data/CountryISO.dta", keep(match master) keepusing(iso3) nogen
sort country_name iso3

cross using `date'

tempfile bridge
save `bridge'

merge m:1 iso3 date using "Data/Panel_2.dta", keep(match master) ///
		keepusing(country Dbar date population)
		

replace iso2 = country_code
rename iso3 n1_iso3
merge m:1 iso2 using  "/Users/oliverracz/!RESEARCH/Covid 19 A/raw data/CountryISO.dta", ///
		keep(match master) keepusing(iso3) nogen

sort iso3 n1_iso3 date

gen ones = 1

collapse (sum) n1_number = ones n1_Dbar = Dbar,	 by(iso3 date) fast

sort iso3 date
compress
save "Data/Borders_Dbar.dta", replace

use `bridge', clear
merge m:1 iso3 date using "Data/Borders_Dbar.dta", keep(match master)

replace iso2 = country_code
rename iso3 n1_iso3
merge m:1 iso2 using  "/Users/oliverracz/!RESEARCH/Covid 19 A/raw data/CountryISO.dta", ///
		keep(match master) keepusing(iso3) nogen

sort iso3 date country_name 

collapse (sum) n2_number = n1_number n2_Dbar = n1_Dbar,	 by(iso3 date) fast

sort iso3 date
compress
save "Data/Borders2_Dbar.dta", replace

use "Data/Panel_2.dta", clear
	cap drop _merge
merge 1:1 iso3 date using "Data/Borders_Dbar.dta", keep(match master) keepusing(n1*)

cap drop merge_coverage
rename _merge merge_coverage

	cap drop _merge
merge 1:1 iso3 date using "Data/Borders2_Dbar.dta", keep(match master) keepusing(n2*)

cap drop merge_coverage2
rename _merge merge_coverage2

* average DPI coverage at 1st neighbors
replace n1_Dbar = 0 if n1_Dbar==.
replace n2_Dbar = 0 if n2_Dbar==.

* coverage of policies at 1st neighbors

	cap drop coverage*
gen coverage = n1_Dbar / n1_number
lab var coverage "Neighbors' DPIs"



gen coverage2 = n2_Dbar / n2_number
lab var coverage2 "2nd neighbors' DPIs"


sca K=14

xtset id date

	cap drop cov1 cov7
gen cov1 = l1.coverage

lab var cov1 "Neighbors' DPIs \$ _{t-1}\$"


gen cov7 = l2.coverage

forvalues kk=3(1)7{

replace cov7 = cov7 + l`kk'.coverage
}
replace cov7=cov7/6

gen cov`=K' = l8.coverage


forvalues kk=8(1)`=K'{

replace cov`=K'		= cov`=K' + l`kk'.coverage
}
replace cov`=K'=cov`=K'/`=K-7'


lab var cov7 "\$\sum_{s=2}^7\$N's' DPIs \$ _{t-s}\$"
lab var cov`=K' "\$\sum_{s=8}^14\$N's' DPIs \$ _{t-s}\$"

global coverage cov1 cov7 cov`=K'

compress


