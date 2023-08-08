*  - Decomposition of DPI induced and other effects


* Calculating Vhat2 by sequentially removing policy effects

	cap drop Vhat2
gen Vhat2 = activity
lab var Vhat2 "Voluntary"



* 1) removing Treatment effects: First DPIs
	cap drop Tghat2 dTghat2
	cap drop Ghat2 dGhat2
gen dTghat2 = _b[dTargeted]*dTargeted
gen dGhat2 = _b[dGeneral]*dGeneral
	bysort id: gen Tghat2 = sum(dTghat2)
	bysort id: gen Ghat2 = sum(dGhat2)

replace Vhat2 = Vhat2 - Tghat2 - Ghat2
lab var Tghat2 "Targeted DPI induced"
lab var Ghat2 "General DPI induced"


* 3) removing Extensity and Intensity effects
	cap drop dIhat2 Ihat2
gen dIhat2 = _b[dIntensity]*dIntensity
bysort id: gen Ihat2 = sum(dIhat2)


replace Vhat2 = Vhat2 - Ihat2  

lab var Ihat2 "Further DPI changes"


* 3) removing other preventive policy effects 
	cap drop dphat2
gen dphat2 = 0

disp "Other preventive policies: $control_pols"
	
foreach var of varlist $control_pols {
replace dphat2 = dphat2 + _b[d`var']*d`var'
}
	cap drop phat2
bysort id: gen phat2 = sum(dphat2)

replace Vhat2 = Vhat2 - phat2

lab var phat2 "Effect of Other Interventions"

* Other interventions + further DPI changes
gen Phat2 = phat2 +  Ihat2


preserve

collapse (mean) activity Vhat2 phat2 Phat2 Tghat2 Ghat2 Ihat2, by(date)

sort date

keep if date>td(15feb2020) & date<td(15dec2020)

foreach var of varlist activity *hat2 {
tostring `var', replace force
replace `var'="nan" if `var'=="." | `var'==""
}
export delimited date activity *hat2 using ///
"/Users/oliverracz/Dropbox/Apps/Overleaf/Distancing Policies on Covid Reproduction Numbers (Full)/tables/Components2_dated.txt", ///
		delimiter(tab) datafmt replace
restore

preserve

collapse (mean) activity Vhat2 phat2 Phat2 Tghat2 Ghat2 Ihat2, by(tDP)

sort tDP

keep if tDP>-10 & tDP<71

foreach var of varlist activity *hat2  tDP {
tostring `var', replace force
replace `var'="nan" if `var'=="." | `var'==""
}

		 
export delimited tDP activity *hat2 using ///
"/Users/oliverracz/Dropbox/Apps/Overleaf/Distancing Policies on Covid Reproduction Numbers (Full)/tables/Components2.txt", ///
		delimiter(tab) datafmt replace
restore

********************************************************************************
* Covariance Tables

*		 DPIs

tabstat Targeted General if smp, s(mean sd max min n) c(s)


********************************************************************************
* Variance table: factors explaining the variance in  the Voluntary component

	cap drop dVhat2 
gen dVhat2 = d.Vhat2

foreach var of varlist  $dspillovers $ddomestic $dweather{
 gen fit2`var' = _b[`var']*`var'
}

tabstat dVhat2 fit2* res2 if smp, s(v) c(s)
