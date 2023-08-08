*  - Decomposition of DPI induced and other effects


* Calculating Vhat by sequentially removing policy effects

	cap drop Vhat 
gen Vhat = activity
lab var Vhat "Voluntary"



* 1) removing Treatment effects: First DPIs
	cap drop dThat That
gen dThat = _b[dTreatment]*dTreatment
bysort id: gen That = sum(dThat)
replace Vhat = Vhat - That
lab var That "DPI induced"

* 3) removing Extensity and Intensity effects
	cap drop dIhat Ihat
gen dIhat = _b[dIntensity]*dIntensity
bysort id: gen Ihat = sum(dIhat)
replace Vhat = Vhat - Ihat  

lab var Ihat "Further DPI changes"



* 3) removing other preventive policy effects 
	cap drop dphat phat
gen dphat = 0

disp "Other preventive policies: $control_pols"
	
foreach var of varlist $control_pols {
replace dphat = dphat + _b[d`var']*d`var'
}
	cap drop phat
bysort id: gen phat = sum(dphat)
replace Vhat = Vhat - phat

lab var phat "Other Interventions"

* Other interventions + further DPI changes
gen Phat = phat +  Ihat
lab var Phat "Other Interventions"



preserve

collapse (mean) activity Vhat phat Phat That Ihat, by(date)

sort date

keep if date>td(15feb2020) & date<td(15dec2020)

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

collapse (mean) activity Vhat phat Phat That Ihat, by(tDP)

sort tDP

keep if tDP>-10 & tDP<71


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

	cap drop dVhat 
gen dVhat = dactivity

foreach var of varlist  $spillovers $domestic $weather{
 gen fit`var' = _b[d`var']*d`var'
}

tabstat dVhat fit* res1 if smp, s(v) c(s)
