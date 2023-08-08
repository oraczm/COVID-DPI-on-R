* 2. Robustness: Fixed effects 
cd "/Users/oliverracz/!RESEARCH/Covid 19 A/Git"

global spillovers f1 f7 f14 f1death f7death f14death cov1 cov7 cov14


* No FE
qui reghdfe activity $policies $spillovers $controls  if smp, noabsorb ///
	vce(cl id) 
outreg2 using Results/1stst_FEs.tex, tex(frag) ///
		keep($policies) ///
		addtext(Country FE, \$ \circ \$ , Calendar FE, \$ \circ \$ , ///
		Event-time FE, \$ \circ \$) ///
		dec(3) replace label 
		
* Country FE
qui reghdfe activity $policies $spillovers $controls  if smp, absorb(id) ///
	vce(cl id) nocons
outreg2 using Results/1stst_FEs.tex, tex(frag) ///
		keep($policies) ///
		addtext(Country FE, \$ \bullet \$ , Calendar FE, \$ \circ \$ , ///
		Event-time FE, \$ \circ \$) ///
		dec(3) append label nocons

		
* Calendar FE
qui reghdfe activity $policies $spillovers $controls  if smp, absorb(id date) ///
	vce(cl id) nocons
outreg2 using Results/1stst_FEs.tex, tex(frag) ///
		keep($policies) ///
		addtext(Country FE, \$ \bullet \$ , Calendar FE, \$ \bullet \$ , ///
		Event-time FE, \$ \circ \$) ///
		dec(3) append label nocons
		
* Event FE
qui reghdfe activity $policies $spillovers $controls  if smp, absorb(id date tDP) ///
	vce(cl id) nocons
outreg2 using Results/1stst_FEs.tex, tex(frag) ///
		keep($policies) ///
		addtext(Country FE, \$ \bullet \$ , Calendar FE, \$ \bullet \$ , ///
		Event-time FE, \$ \bullet \$) ///
		dec(3) append label nocons 
		
cd "/Users/oliverracz/!RESEARCH/Covid 19 A/Git/Do"
