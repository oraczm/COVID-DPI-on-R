********************************************************************************
* Calculation of DPI indicators: Treatment and Later Changes *******************
********************************************************************************

* sum of all policies
egen Dbar = rowtotal(distance*)

**** EVENT-TIME: months relative to first ever DPI

xtset id date

	bysort id: gen t=_n
	cap drop tDP
	bysort id: gen tp  = t if Dbar >0 & l.Dbar ==0
	bysort id: egen tpp = min(tp)
gen tDP = t-tpp
	drop t tp tpp
	
**** TREATMENT: First ever restriction


gen Treatment=Dbar if tDP>-1 & tDP<7 
	gen treat7 = Dbar if tDP==7 
	bysort id: egen treat_post = min(treat7) 
replace Treatment = treat_post if tDP>=7
replace Treatment = 0 if Treatment==.
	drop treat7 treat_post
	
lab var Treatment "First DPI"

**** INTENSITY: Further changes in DPIs 

gen Intensity = Dbar - Treatment

lab var Intensity "Further DPI changes"

**** TYPES: Targeted, General

* 1) Targeted: schools, workplaces, events, gathering
egen Dtargeted = rowtotal(distance1 distance2 distance3 distance4)
lab var Dtargeted "Dbar of Targeted"

gen Targeted=Dtargeted if tDP>-1 & tDP<7 
	gen treat7 = Dtargeted if tDP==7 
	bysort id: egen treat_post = min(treat7) 
replace Targeted = treat_post if tDP>=7
replace Targeted = 0 if Targeted==.
	drop treat7 treat_post

lab var Targeted "Targeted DPI"

* 2) General: cerfew, public transport, inland mobility
egen Dgeneral = rowtotal(distance5 distance6 distance7)
lab var Dgeneral "Dbar of General"

gen General=Dgeneral if tDP>-1 & tDP<7 
	gen treat7 = Dgeneral if tDP==7 
	bysort id: egen treat_post = min(treat7) 
replace General = treat_post if tDP>=7
replace General = 0 if General==.
	drop treat7 treat_post

lab var General "General DPI"
