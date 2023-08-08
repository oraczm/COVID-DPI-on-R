* Heterogeneity: Reduced form and comparable effects

* 1) activity

global regressor activity
qui ppmlhdfe outcome $regressor $imports $controls if smp, ///
		a(id) vce(cl id) noconst


	outreg2 using Results/2ndst_reduced.tex, tex(frag) ///
		keep($regressor) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Country FE, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) replace label nocons
		
* 2) components: That Vhat Phat
global regressor That Vhat Phat
qui ppmlhdfe outcome $regressor $imports $controls if smp, ///
		a(id) vce(cl id) noconst


	outreg2 using Results/2ndst_reduced.tex, tex(frag) ///
		keep($regressor) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Country FE, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) append label nocons
