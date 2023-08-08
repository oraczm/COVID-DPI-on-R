* Calculation of Social Activity Index by PCA

* Principal components of activity trends
global sGMR 
foreach var of varlist $GMR{
qui su `var'
gen s`var' = (`var'-r(mean))/r(sd)
global sGMR $sGMR s`var'
}

qui pca $sGMR

* first principal component
predict pc1


* normalizing by pre-Treatment means
* unit: percentage change relative to pre-Treatment mean
	cap drop activity 
	cap drop countrymean
bysort id: egen countrymean1 = mean(pc1)  if tDP<0
bysort id: egen countrymean = min(countrymean1)

gen activity = pc1/countrymean*100-100
drop countrymean* pc1

lab var activity "Social Activity Index"
