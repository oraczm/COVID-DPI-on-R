*  - Decomposition of DPI induced and other effects


* Calculating Vhat by sequentially removing policy effects

	cap drop Vhat
gen Vhat = activity
lab var Vhat "Voluntary"



* 1) removing Treatment effects: First DPIs
	cap drop That
gen That = _b[Treatment]*Treatment
replace Vhat = Vhat - That
lab var That "DPI induced"

* 3) removing Extensity and Intensity effects
	cap drop Ihat
gen Ihat = _b[Intensity]*Intensity
replace Vhat = Vhat - Ihat  

lab var Ihat "Further DPI changes"



* 3) removing other preventive policy effects 
	cap drop phat
gen phat = 0

disp "Other preventive policies: $control_pols"
	
foreach var of varlist $control_pols {
replace phat = phat + _b[`var']*`var'
}
replace Vhat = Vhat - phat

lab var phat "Effect of Other Interventions"

* Counter-factual graphs
gen dphat = phat +  Ihat


preserve

collapse (mean) activity Vhat phat dphat That Ihat, by(date)

sort date

foreach var of varlist activity *hat {
tostring `var', replace force
replace `var'="nan" if `var'=="." | `var'==""
}
export delimited date activity *hat using ///
"/Users/oliverracz/Dropbox/Apps/Overleaf/Distancing Policies on Covid Reproduction Numbers (Full)/tables/Components_dated.txt", ///
		delimiter(tab) datafmt replace
restore

preserve

codebook id

collapse (mean) activity Vhat phat dphat That Ihat, by(tDP)


sort tDP

foreach var of varlist activity *hat  tDP {
tostring `var', replace force
replace `var'="nan" if `var'=="." | `var'==""
}

		 
export delimited tDP activity *hat using ///
"/Users/oliverracz/Dropbox/Apps/Overleaf/Distancing Policies on Covid Reproduction Numbers (Full)/tables/Components.txt", ///
		delimiter(tab) datafmt replace
restore

********************************************************************************
* Covariate Tables

*		 DP's

tabstat Treatment Intensity if smp, s(mean sd max min n) c(s)

*		OP's

tabstat $control_pols if smp, s(mean sd max min n) c(s)
		
*		Voluntary

tabstat $spillovers $domestic $weather  if smp, s(mean sd max min n) c(s)

********************************************************************************
* Variance table

foreach var of varlist  $spillovers $domestic {
 gen fit`var' = _b[`var']*`var'
}

tabstat Vhat fit* res1 if smp, s(v) c(s)
