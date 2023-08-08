*** Effect of DPI on R project

* FIRST STAGE ESTIMATIONS and ROBUSTNESS of 
*  - First Stage: Voluntary Mobility (First Diff)
*  - Decomposition of DPI induced and other effects
*  - Robustness: Spillovers
*  - Robustness: Fixed effects
*  (- Robustness: FD vs Level)


**********************************************************

cd "/Users/oliverracz/!RESEARCH/Covid 19 A/Git"
use "Data/Panel_prepared.dta", clear

**********************************************************
****** I.A) FIRST STAGE: All goes First Difference, because it is more convincing

* Outcome 
		cap drop dactivity
	gen dactivity = d.activity
	lab var dactivity " "

* DPIs
	cap drop dTreatment
gen dTreatment = d.Treatment 
	lab var dTreatment "\$\Delta\$ DPI (first 7 days)"
	


* spillovers: neighbors cases, deaths and DPIs (average Dbar)
global spillovers f1 f7 f14 f1death f7death f14death cov1 cov7 cov14
	global dspillovers
	foreach var of varlist $spillovers{
		gen d`var'=d.`var'
		global dspillovers $dspillovers d`var'
		}

* domestic COVID reports: cases and deaths in the past 1, 2-7, 8-14 days
global domestic  d1 d7 d14 d1death d7death d14death
	global ddomestic
	foreach var of varlist $domestic{
		gen d`var'=d.`var'
		global ddomestic $ddomestic d`var'
		}


* other COVID related policies
global control_pols Intensity travelc_* testing_* contact_* masks_* incomes_* relief_* ///
	infoc_* elderly_* fiscal tested positives vacshare 
	global dcontrol_pols
	foreach var of varlist $control_pols{
		gen d`var'=d.`var'
		global dcontrol_pols $dcontrol_pols d`var'
		}
	
* Weather: country averages per day
global weather temperature rainfall snowfall dewp humidity
	global dweather
	foreach var of varlist $weather{
		gen d`var'=d.`var'
		global dweather $dweather d`var'
		}

	
* seasonality: $season *days of the week)
global season weekend
*global season S1 S2 S3 S4 S5 S6 S7

* all controls
global controls $domestic $control_pols  $weather  $season
	global dcontrols $ddomestic $dcontrol_pols  $dweather  $season


* Baseline model (All DPIs) + setting the sample
*****************

	cap drop smp res1
	gen smp = 1	
qui reghdfe dactivity dTreatment $dspillovers $dcontrols  if smp, absorb(id date tDP) ///
	vce(cl id) nocons res(res1)
	replace smp = e(sample)
	

* All DPIs	
	outreg2 using Results/1stst.tex, tex(frag) ///
		keep(dTreatment) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Fixed Effects\$^\dag\$, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) replace label nocons

	* Calculating social activity components
	do "Do/5 Decomposition.do"

* Targeted / General

cap drop dTargeted
gen dTargeted = d.Targeted
	lab var dTargeted "\$\Delta\$ Targeted (first 7 days)"

cap drop dGeneral
gen dGeneral = d.General
	lab var dGeneral "\$\Delta\$ General (first 7 days)"
	
global policies dTargeted dGeneral	
	
	cap drop res2
reghdfe dactivity $policies $dspillovers $dcontrols  if smp, absorb(id date tDP) ///
	vce(cl id) nocons res(res2)
	outreg2 using Results/1stst.tex, tex(frag) ///
		keep($policies) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Fixed Effects\$^\dag\$, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) append label nocons
	* Calculating social activity components
	do "Do/5b Decomposition GT.do"

* 1. Robustness: SPILLOVERS
global policies dTreatment
do "Do/6a Spillovers.do"

* 2. Robustness: Fixed effects 
do "Do/6b FEs.do"
* do "6b2 FEs in diff.do"

* Results
seeout using "Results/1stst.txt", label
seeout using "Results/1stst_dspillovers.txt", label
seeout using "Results/1stst_FEs_diff.txt", label

save "Data/Panel_firststage.dta", replace
