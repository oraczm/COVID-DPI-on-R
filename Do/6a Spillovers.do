* 1. Robustness: dspillovers 
cd "/Users/oliverracz/!RESEARCH/Covid 19 A/Git"

* No spillovers
global dspillovers 
qui reghdfe dactivity $policies $dspillovers $dcontrols  if smp, absorb(id date tDP) ///
	vce(cl id) nocons
outreg2 using Results/1stst_dspillovers.tex, tex(frag) ///
		keep($policies $dspillovers) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Fixed Effects\$^\dag\$, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) replace label nocons
		
* Neighbors Cases
global dspillovers df1 df7 df14 
lab var df1 "Neighbors' Cases (last day)"
lab var df7 "Neighbors' Cases (last week)"
lab var df14 "Neighbors' Cases (week before)"

qui reghdfe dactivity $policies $dspillovers $dcontrols  if smp, absorb(id date tDP) ///
	vce(cl id) nocons
outreg2 using Results/1stst_dspillovers.tex, tex(frag) ///
		keep($policies $dspillovers) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Fixed Effects\$^\dag\$, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) append label nocons

		
* Neighbors Cases + Deaths
global dspillovers df1 df7 df14 df1death df7death df14death 
lab var df1death "Neighbors' Deaths (last day)"
lab var df7death "Neighbors' Deaths (last week)"
lab var df14death "Neighbors' Deaths (week before)"

qui reghdfe dactivity $policies $dspillovers $dcontrols  if smp, absorb(id date tDP) ///
	vce(cl id) nocons
outreg2 using Results/1stst_dspillovers.tex, tex(frag) ///
		keep($policies $dspillovers) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Fixed Effects\$^\dag\$, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) append label nocons
		
* Neighbors Cases + Deaths + DPIs
global dspillovers df1 df7 df14 df1death df7death df14death dcov1 dcov7 dcov14
lab var dcov1 "Neighbors' DPIs (last day)"
lab var dcov7 "Neighbors' DPIs (last week)"
lab var dcov14 "Neighbors' DPIs (week before)"

qui reghdfe dactivity $policies $dspillovers $dcontrols  if smp, absorb(id date tDP) ///
	vce(cl id) nocons
outreg2 using Results/1stst_dspillovers.tex, tex(frag) ///
		keep($policies $dspillovers) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Fixed Effects\$^\dag\$, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) append label nocons
		

		

