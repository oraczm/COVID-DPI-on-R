* Heterogeneity: Stringency levels


* 1) Baseline

global regressor Treatment Vhat
qui ppmlhdfe outcome $regressor $imports $controls if smp, ///
		a(id) vce(cl id) noconst


	outreg2 using Results/2ndst_stringency.tex, tex(frag) ///
		keep($regressor) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Country FE, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) replace label nocons
		
* 2) Heterogeneity: Stringency
global regressor Recommended Mandatory Vhat
qui ppmlhdfe outcome $regressor $imports $controls if smp, ///
		a(id) vce(cl id) noconst


	outreg2 using Results/2ndst_stringency.tex, tex(frag) ///
		keep($regressor) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Country FE, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) append label nocons
		
		
