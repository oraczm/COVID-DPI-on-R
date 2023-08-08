********************************************************************************
*  - Calculation of Daily Repruduction Numbers: New Cases/l.Infected ***********
********************************************************************************

xtset id date
* Reproduction numbers
	cap drop R
gen R = newcases/l.JH_infected
replace R = 0 if R<0

* R7 7 days moving average
	cap drop R7
gen R7 = (newcases+l.newcases+l2.newcases+l3.newcases+l4.newcases+l5.newcases+l6.newcases)/ ///
		(l.JH_infected+l2.JH_infected+l3.JH_infected+l4.JH_infected+l5.JH_infected+l6.JH_infected+l7.JH_infected)
replace R7 = 0 if R7<0
* death rates
	cap drop DR
gen DR = newdeaths/l.JH_infected
replace DR = 0 if DR<0
