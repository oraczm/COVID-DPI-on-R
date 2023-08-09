*** Effect of DPI on R project

* SECOND STAGE ESTIMATIONS and ROBUSTNESS of 
*  - Second Stage: DPI effects on R
*  - Robustenss: Assumed latency
*  - Heterogeneity: Targeted or General policies (earlier: Place/Mobility restrictions)
*  - Heterogeneity: dynamic effects?
*  - Heterogeneity: Stringency levels?
*  - Effect of Information?
*  - Effect of Rule of Law?
*  - Effect of population density?
**********************************************************

cd "/Users/oliverracz/!RESEARCH/Covid 19 A/Git"
use "Data/Panel_firststage.dta", clear


* Outcome
loc outcome R

	* latency (incubation)
sca late = 11

	cap drop outcome
gen outcome = f`=late'.`outcome'

* DPIs
global policies Treatment


forvalues val=2(1)5 {
		cap drop ImpXtc`val'
	gen ImpXtc`val' = Imp * travelc_`val'
}

* Imported cases X Travel controls
lab var ImpXtc2 "Import \$ \times \$ Screening \$ _{ t}\$"
lab var ImpXtc3 "Import \$ \times \$ Quarantine \$ _{ t}\$"
lab var ImpXtc4 "Import \$ \times \$ Targeted Ban \$ _{ t}\$"
lab var ImpXtc5 "Import \$ \times \$ General Ban \$ _{ t}\$"

global imports Imp ImpXtc2 ImpXtc3 ImpXtc4 ImpXtc5


* domestic COVID reports: cases and deaths in the past 1, 2-7, 8-14 days
global global domestic  d1 d7 d1death d7death 


* other COVID related policies
global control_pols Intensity travelc_* testing_* contact_* masks_* incomes_* relief_* ///
	infoc_* elderly_* fiscal tested positives vacshare 
	
* Weather: country averages per day
global weather temperature rainfall snowfall dewp humidity

	
* seasonality: $season *days of the week)
global season weekend
*global season S1 S2 S3 S4 S5 S6 S7

* all controls
global controls $domestic $control_pols $weather  $season


* Setting the common sample

	cap drop smp
	gen smp = 1
foreach var of varlist outcome $policies Vhat $imports $controls {
replace smp = 0 if `var'==.
} 



**********************************************************
*** Estimations

* 1) Baseline
global parts
qui ppmlhdfe outcome $policies $parts $controls if smp, ///
		a(id) vce(cl id) noconst


	outreg2 using Results/2ndst.tex, tex(frag) ///
		keep($policies $parts) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Country FE, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) replace label nocons
		
* 2) Voluntary
global parts Vhat
qui ppmlhdfe outcome $policies $parts $controls if smp, ///
		a(id) vce(cl id) noconst


	outreg2 using Results/2ndst.tex, tex(frag) ///
		keep($policies $parts) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Country FE, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) append label nocons
		
* 3) Imported cases
global parts Vhat Imp
qui ppmlhdfe outcome $policies $parts $controls if smp, ///
		a(id) vce(cl id) noconst


	outreg2 using Results/2ndst.tex, tex(frag) ///
		keep($policies $parts) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Country FE, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) append label nocons

* 4) Imported cases X Travel controls
global parts Vhat $imports
qui ppmlhdfe outcome $policies $parts $controls if smp, ///
		a(id) vce(cl id) noconst


	outreg2 using Results/2ndst.tex, tex(frag) ///
		keep($policies $parts) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Country FE, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) append label nocons
		
	outreg2 using Results/2ndst_controls.tex, tex(frag) ///
		keep($policies $controls) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Country FE, \$ \bullet \$) ///
		dec(3) replace label nocons
		
**********************************************************
* Reduced form and comparable effects
do "Do/7a Reduced forms.do"

**********************************************************
* Heterogeneity: Targeted, General
do "Do/7b Targeted General.do"

**********************************************************
* Robustness: Assumed latency
do "Do/7c Latency.do"

**********************************************************
* Heterogeneity: Stringency levels
do "Do/7d Stringency.do"

**********************************************************	
* Results
seeout using "Results/2ndst.txt", label
seeout using "Results/2ndst_controls.txt", label
seeout using "Results/2ndst_reduced.txt", label
seeout using "Results/2ndst_target.txt", label
seeout using "Results/2ndst_latency.txt", label
seeout using "Results/2ndst_stringency.tex", label


