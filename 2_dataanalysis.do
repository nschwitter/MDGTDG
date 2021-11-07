clear

use "Data_Fourcountry_Main_20211007_anonymised_prepared.dta"


*****************
*** Dropping missing values
*****************

drop if percentkepttg==. | percentgivendg==. 


********
** Data description
********
sum percentgivendg percentgiventg 

bysort country: sum percentgivendg percentgiventg

bysort receiverdg: sum percentgivendg
bysort receivertg: sum percentgiventg
bysort country receiverdg: sum percentgivendg, detail
bysort country receivertg: sum percentkepttg, detail

bysort receiverdg: sum percentgivendg, detail
bysort receivertg: sum percentkepttg, detail

pwcorr percentgiventg percentgivendg, sig
bysort country: pwcorr percentgiventg percentgivendg, sig

sum givendg giventg
bysort receiverdg: sum givendg 
bysort receivertg: sum giventg 

bysort country receiverdg: sum givendg 
bysort country receivertg: sum giventg 
bysort country: sum givendg giventg

bysort country: sum ladder

sum siops2 costat isced age male eqincome2decile
tab isced
bysort country: sum siops2 costat  isced age male eqincome2decile
bysort country: tab isced



********
** Analysis MDG/TDG per country
********
*Money dictator game
churdle linear percentgivendg costat recdgnone recdgmid recdghigh age male if country=="germany", select(costat recdgnone recdgmid recdghigh age male) ll(0)
est sto churdledg_ger
churdle linear percentgivendg ladder recdgnone recdgmid recdghigh age male if country=="germany", select(ladder recdgnone recdgmid recdghigh age male) ll(0)
est sto churdledg_gersubj

churdle linear percentgivendg costat recdgnone recdgmid recdghigh age male if country=="poland", select(costat recdgnone recdgmid recdghigh age male) ll(0)
est sto churdledg_pol
churdle linear percentgivendg ladder recdgnone recdgmid recdghigh age male if country=="poland", select(ladder recdgnone recdgmid recdghigh age male) ll(0)
est sto churdledg_polsubj

churdle linear percentgivendg costat recdgnone recdgmid recdghigh age male if country=="sweden", select(costat recdgnone recdgmid recdghigh age male) ll(0)
est sto churdledg_swe
churdle linear percentgivendg ladder recdgnone recdgmid recdghigh age male if country=="sweden", select(ladder recdgnone recdgmid recdghigh age male) ll(0)
est sto churdledg_swesubj

churdle linear percentgivendg costat recdgnone recdgmid recdghigh age male if country=="usa", select(costat recdgnone recdgmid recdghigh age male) ll(0)
est sto churdledg_usa
churdle linear percentgivendg ladder recdgnone recdgmid recdghigh age male if country=="usa", select(ladder recdgnone recdgmid recdghigh age male) ll(0)
est sto churdledg_usasubj

*Time dictator game
churdle linear percentkepttg costat rectgnone rectgmid rectghigh age male if country=="germany", select(costat rectgnone rectgmid rectghigh age male) ll(0)
est sto churdletg_ger
churdle linear percentkepttg ladder rectgnone rectgmid rectghigh age male if country=="germany", select(ladder rectgnone rectgmid rectghigh age male) ll(0)
est sto churdletg_gersubj

churdle linear percentkepttg costat rectgnone rectgmid rectghigh age male if country=="poland", select(costat rectgnone rectgmid rectghigh age male) ll(0)
est sto churdletg_pol
churdle linear percentkepttg ladder rectgnone rectgmid rectghigh age male if country=="poland", select(ladder rectgnone rectgmid rectghigh age male) ll(0)
est sto churdletg_polsubj

churdle linear percentkepttg costat rectgnone rectgmid rectghigh age male if country=="sweden", select(costat rectgnone rectgmid rectghigh age male) ll(0)
est sto churdletg_swe
churdle linear percentkepttg ladder rectgnone rectgmid rectghigh age male if country=="sweden", select(ladder rectgnone rectgmid rectghigh age male) ll(0)
est sto churdletg_swesubj

churdle linear percentkepttg costat rectgnone rectgmid rectghigh age male if country=="usa", select(costat rectgnone rectgmid rectghigh age male) ll(0)
est sto churdletg_usa
churdle linear percentkepttg ladder rectgnone rectgmid rectghigh age male if country=="usa", select(ladder rectgnone rectgmid rectghigh age male) ll(0)
est sto churdletg_usasubj

esttab churdledg_* churdletg_* using churdlecountries.rtf, scalars("ll Log likelihood") onecell label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace 

//cheking for seemingly unrelated regression
suest churdledg_ger churdletg_ger
suest churdledg_gersubj churdletg_gersubj

suest churdledg_pol churdletg_pol
suest churdledg_polsubj churdletg_polsubj

suest churdledg_swe churdletg_swe
suest churdledg_swesubj churdletg_swesubj

suest churdledg_usa churdletg_usa
suest churdledg_usasubj churdletg_usasubj

**Pooled
*Money dictator game
churdle linear percentgivendg costat recdgnone recdgmid recdghigh age male, select(costat recdgnone recdgmid recdghigh age male) ll(0) vce(cluster country)
est sto churdledg 
churdle linear percentgivendg ladder recdgnone recdgmid recdghigh age male, select(ladder recdgnone recdgmid recdghigh age male) ll(0) vce(cluster country)
est sto churdledgsubj

*Time dictator game
churdle linear percentkepttg costat rectgnone rectgmid rectghigh age male, select(costat rectgnone rectgmid rectghigh age male) ll(0) vce(cluster country) 
est sto churdletg 
churdle linear percentkepttg ladder rectgnone rectgmid rectghigh age male, select(ladder rectgnone rectgmid rectghigh age male) ll(0) vce(cluster country) 
est sto churdletgsubj

esttab churdledg* churdletg* using churdlemain_pooled.rtf, scalars("ll Log likelihood") onecell label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace 	


//seemingly unrelated regression
churdle linear percentkepttg costat rectgnone rectgmid rectghigh age male, select(costat rectgnone rectgmid rectghigh age male) ll(0)
est sto churdletg2
churdle linear percentkepttg ladder rectgnone rectgmid rectghigh age male, select(ladder rectgnone rectgmid rectghigh age male) ll(0) 
est sto churdletgsubj2
churdle linear percentgivendg costat recdgnone recdgmid recdghigh age male, select(costat recdgnone recdgmid recdghigh age male) ll(0)
est sto churdledg2 
churdle linear percentgivendg ladder recdgnone recdgmid recdghigh age male, select(ladder recdgnone recdgmid recdghigh age male) ll(0) 
est sto churdledgsubj2
	
suest churdledg2 churdletg2, cluster(country)
suest churdledgsubj2 churdletgsubj2, cluster(country)


*******
** Plotting second stage of churdle models, pooled
*******
set scheme plotplain 

truncreg percentgivendg costat recdgnone recdgmid recdghigh age male, ll(0) vce(cluster country) 
margins, at(costat=(-3(1)3)) post
estimates store regdg

truncreg percentkepttg costat recdgnone recdgmid recdghigh age male, ll(0) vce(cluster country) 
margins, at(costat=(-3(1)3)) post
estimates store regtg

coefplot regdg regtg, ytitle(Percentage shared) xtitle(Objective social status) ///
	at recast(line) lwidth(*1.25) ciopts(color(%20) recast(rarea) lwidth(none)) ///
	ylabel(0(20)100, angle(oh)) ///
	xlabel(-3(1)3) ///
	legend(off) xtitle("") 

truncreg percentgivendg ladder recdgnone recdgmid recdghigh age male, ll(0) vce(cluster country) 
margins, at(ladder=(0(1)10)) post
estimates store regdgsubj

truncreg percentkepttg ladder recdgnone recdgmid recdghigh age male, ll(0) vce(cluster country) 
margins, at(ladder=(0(1)10)) post
estimates store regtgsubj

coefplot regdgsubj regtgsubj, ytitle(Percentage shared) xtitle(Subjective social status) ///
	at recast(line) lwidth(*1.25) ciopts(color(%20) recast(rarea) lwidth(none)) ///
	ylabel(0(20)100, angle(oh)) ///
	legend(off) xtitle("") ytitle("")
	
	
	
********
** Analysis: Receiver effects
********

//Per country
preserve
drop if receiverdg==2
drop if receiverdg==0
bysort country: ttest percentgivendg, by(receiverdg)
bysort country: ranksum percentgivendg, by(receiverdg)
restore

preserve
drop if receivertg==2
drop if receivertg==0
bysort country: ttest percentkepttg, by(receivertg)
bysort country: ranksum percentkepttg, by(receivertg)
restore

//Pooled
preserve
drop if receiverdg==2
drop if receiverdg==0
robvar percentgivendg, by(receiverdg)
restore

preserve
drop if receivertg==2
drop if receivertg==0
robvar percentkepttg, by(receivertg)
restore
	
//reshape dataset	
gen decision1 = percentgivendg
gen decision2 = percentkepttg
gen receiver1 = receiverdg
gen receiver2 = receivertg

reshape long decision receiver, i(case_id) j(typeofgame)  

gen recnone = receiver==0
gen reclow = receiver==1
gen recmid = receiver==2
gen rechigh = receiver==3

replace recnone = . if receiver == .  
replace reclow = . if receiver == .  
replace recmid = . if receiver == .  
replace rechigh = . if receiver == .  

label var recnone "Receiver: No status info"
label var reclow "Receiver: Low status"
label var recmid "Receiver: Medium status"
label var rechigh "Receiver: High status"

replace typeofgame = typeofgame-1

preserve
drop if recnone==1 | recmid==1
bysort typeofgame: reg decision rechigh, cluster(country)
restore

est sto reg_typeofgame
