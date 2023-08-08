* Robustness: Assumed latency
global regressor Treatment Vhat

* 1) latency = 5 days

gen outcome_robust = f6.R
	lab var outcome_robust "5"
qui ppmlhdfe outcome_robust $regressor $imports $controls if smp, ///
		a(id) vce(cl id) noconst


	outreg2 using Results/2ndst_latency.tex, tex(frag) ///
		keep($regressor) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Country FE, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) replace label nocons
		
* 2)... latency = +2 days

forvalues latency = 8(2)16 {

replace outcome_robust = f`latency'.R
	lab var outcome_robust "`latency'"
qui ppmlhdfe outcome_robust $regressor $imports $controls if smp, ///
		a(id) vce(cl id) noconst


	outreg2 using Results/2ndst_latency.tex, tex(frag) ///
		keep($regressor) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Country FE, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) append label nocons
		}
