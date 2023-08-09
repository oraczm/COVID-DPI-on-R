* 3. Heterogeneity: Stringency levels

cap drop dRecommended
gen dRecommended = d.Recommended
	lab var dRecommended "\$\Delta\$ Recommended (first 7 days)"

cap drop dMandatory
gen dMandatory = d.Mandatory
	lab var dMandatory "\$\Delta\$ Mandatory (first 7 days)"
	
global policies dRecommended dMandatory	
	
	cap drop res2
qui reghdfe dactivity $policies $dspillovers $dcontrols  if smp, absorb(id date tDP) ///
	vce(cl id) nocons res(res2)
	outreg2 using Results/1stst_stringency.tex, tex(frag) ///
		keep($policies) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Fixed Effects\$^\dag\$, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) append label nocons
	* Calculating social activity components
	do "Do/5b Decomposition GT.do"
