* Descriptive Stats and Graphs

* 1. RD graphs for levels


preserve
sort tDP
keep if tDP!=.
keep if tDP<36 & tDP>-21

foreach var of varlist activity Dbar Treatment Intensity R R7{
tostring `var', replace force
replace `var'="nan" if `var'=="." | `var'==""
}

export delimited tDP activity Dbar Treatment Intensity R R7 using ///
"/Users/oliverracz/Dropbox/Apps/Overleaf/Distancing Policies on Covid Reproduction Numbers (Full)/tables/RD.txt", ///
		delimiter(tab) datafmt replace
restore

preserve
sort tDP
keep if tDP!=.
keep if tDP<71 & tDP>-21
collapse (mean) activity Dbar Treatment Intensity R R7 ///
		 (p5) p5activity=activity p5Dbar=Dbar ///
		 p5Treatment=Treatment p5Intensity=Intensity p5R=R p5R7=R7 ///
		 (p95) p95activity=activity p95Dbar=Dbar ///
		 p95Treatment=Treatment p95Intensity=Intensity p95R=R p95R7=R7 ///	
		 if tDP!=., by(tDP) fast

foreach var of varlist activity Dbar Treatment Intensity R R7 ///
			p5activity p5Dbar p5Treatment p5Intensity p5R p5R7 ///
			p95activity p95Dbar p95Treatment p95Intensity p95R p95R7 ///
{
tostring `var', replace force
replace `var'="nan" if `var'=="." | `var'==""
}

export delimited tDP activity Dbar Treatment Intensity R R7 ///
			p5activity p5Dbar p5Treatment p5Intensity p5R p5R7 ///
			p95activity p95Dbar p95Treatment p95Intensity p95R p95R7 ///
			using ///
"/Users/oliverracz/Dropbox/Apps/Overleaf/Distancing Policies on Covid Reproduction Numbers (Full)/tables/RD_means.txt", ///
		delimiter(tab) datafmt replace		
restore


* 2. RD graphs for 1st differences


preserve

*1st differencing
xtset id date
foreach var of varlist activity Dbar Treatment Intensity R R7{
rename `var' l`var'
gen `var'=d.l`var'
}


sort tDP
keep if tDP!=.
keep if tDP<36 & tDP>-21

foreach var of varlist activity Dbar Treatment Intensity R R7{
tostring `var', replace force
replace `var'="nan" if `var'=="." | `var'==""
}

export delimited tDP activity Dbar Treatment Intensity R R7 using ///
"/Users/oliverracz/Dropbox/Apps/Overleaf/Distancing Policies on Covid Reproduction Numbers (Full)/tables/RD_diff.txt", ///
		delimiter(tab) datafmt replace
restore

preserve

*1st differencing
xtset id date
foreach var of varlist activity Dbar Treatment Intensity R R7{
rename `var' l`var'
gen `var'=d.l`var'
}

sort tDP
keep if tDP!=.
keep if tDP<71 & tDP>-21
collapse (mean) activity Dbar Treatment Intensity R R7 ///
		 (p5) p5activity=activity p5Dbar=Dbar ///
		 p5Treatment=Treatment p5Intensity=Intensity p5R=R p5R7=R7 ///
		 (p95) p95activity=activity p95Dbar=Dbar ///
		 p95Treatment=Treatment p95Intensity=Intensity p95R=R p95R7=R7 ///	
		 if tDP!=., by(tDP) fast

foreach var of varlist activity Dbar Treatment Intensity R R7 ///
			p5activity p5Dbar p5Treatment p5Intensity p5R p5R7 ///
			p95activity p95Dbar p95Treatment p95Intensity p95R p95R7 ///
{
tostring `var', replace force
replace `var'="nan" if `var'=="." | `var'==""
}

export delimited tDP activity Dbar Treatment Intensity R R7 ///
			p5activity p5Dbar p5Treatment p5Intensity p5R p5R7 ///
			p95activity p95Dbar p95Treatment p95Intensity p95R p95R7 ///
			using ///
"/Users/oliverracz/Dropbox/Apps/Overleaf/Distancing Policies on Covid Reproduction Numbers (Full)/tables/RD_diff_means.txt", ///
		delimiter(tab) datafmt replace		
restore
