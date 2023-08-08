* 2. Robustness: Fixed effects 

	
global policies dTreatment
* No FE
qui reghdfe dactivity $policies $dspillovers $dcontrols  if smp, noabsorb ///
	vce(cl id) 
outreg2 using Results/1stst_FEs_diff.tex, tex(frag) ///
		keep($policies) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Country FE, \$ \circ \$ , Calendar FE, \$ \circ \$ , ///
		Event-time FE, \$ \circ \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) replace label 
		
* Country FE
qui reghdfe dactivity $policies $dspillovers $dcontrols  if smp, absorb(id) ///
	vce(cl id) nocons
outreg2 using Results/1stst_FEs_diff.tex, tex(frag) ///
		keep($policies) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Country FE, \$ \bullet \$ , Calendar FE, \$ \circ \$ , ///
		Event-time FE, \$ \circ \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) append label nocons

		
* Calendar FE
qui reghdfe dactivity $policies $dspillovers $dcontrols  if smp, absorb(id date) ///
	vce(cl id) nocons
outreg2 using Results/1stst_FEs_diff.tex, tex(frag) ///
		keep($policies) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Country FE, \$ \bullet \$ , Calendar FE, \$ \bullet \$ , ///
		Event-time FE, \$ \circ \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) append label nocons
		
* Event FE
qui reghdfe dactivity $policies $dspillovers $dcontrols  if smp, absorb(id date tDP) ///
	vce(cl id) nocons
outreg2 using Results/1stst_FEs_diff.tex, tex(frag) ///
		keep($policies) ///
		addstat(Countries, e(N_clust)) ///
		addtext(Country FE, \$ \bullet \$ , Calendar FE, \$ \bullet \$ , ///
		Event-time FE, \$ \bullet \$ , Controls\$^\ddag\$, \$ \bullet \$) ///
		dec(3) append label nocons
		
