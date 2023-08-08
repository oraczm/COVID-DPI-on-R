*  - Decomposition of DPI induced and other effects


* Calculating Vhat2 by sequentially removing policy effects

	cap drop Vhat2
gen Vhat2 = activity
lab var Vhat2 "Voluntary"



* 1) removing Treatment effects: First DPIs
	cap drop Tghat2
gen Tghat2 = _b[Targeted]*Targeted
gen Ghat2 = _b[General]*General
replace Vhat2 = Vhat2 - Tghat2 - Ghat2
lab var Tghat2 "Targeted DPI induced"
lab var Ghat2 "General DPI induced"


* 3) removing Extensity and Intensity effects
	cap drop Ihat2
gen Ihat2 = _b[Intensity]*Intensity
replace Vhat2 = Vhat2 - Ihat2  

lab var Ihat2 "Further DPI changes"



* 3) removing other preventive policy effects 
	cap drop phat2
gen phat2 = 0

disp "Other preventive policies: $control_pols"
	
foreach var of varlist $control_pols {
replace phat2 = phat2 + _b[`var']*`var'
}
replace Vhat2 = Vhat2 - phat2

lab var phat2 "Effect of Other Interventions"

* Counter-factual graphs
gen dphat2 = phat2 +  Ihat2


preserve

collapse (mean) activity Vhat2 phat2 dphat2 Tghat2 Ghat2 Ihat2, by(date)

sort date

foreach var of varlist activity *hat2 {
tostring `var', replace force
replace `var'="nan" if `var'=="." | `var'==""
}
export delimited date activity *hat2 using ///
"/Users/oliverracz/Dropbox/Apps/Overleaf/Distancing Policies on Covid Reproduction Numbers (Full)/tables/Components2_dated.txt", ///
		delimiter(tab) datafmt replace
restore

preserve

collapse (mean) activity Vhat2 phat2 dphat2 Tghat2 Ghat2 Ihat2, by(tDP)

sort tDP

foreach var of varlist activity *hat2  tDP {
tostring `var', replace force
replace `var'="nan" if `var'=="." | `var'==""
}

		 
export delimited tDP activity *hat2 using ///
"/Users/oliverracz/Dropbox/Apps/Overleaf/Distancing Policies on Covid Reproduction Numbers (Full)/tables/Components2.txt", ///
		delimiter(tab) datafmt replace
restore

********************************************************************************
* Covariate Tables

*		 DPIs

tabstat Treatment Intensity if smp, s(mean sd max min n) c(s)

*		OPs

tabstat $control_pols if smp, s(mean sd max min n) c(s)
		
*		Voluntary

tabstat $spillovers $domestic $weather  if smp, s(mean sd max min n) c(s)

********************************************************************************
* Variance table

foreach var of varlist  $spillovers $domestic {
 gen fit2`var' = _b[`var']*`var'
}

tabstat Vhat2 fit2* res2 if smp, s(v) c(s)
