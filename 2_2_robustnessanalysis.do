clear

use "Data_Fourcountry_Main_20220408_anonymised_prepared.dta"

*****************
*** Dropping missing values
*****************

drop if percentkepttg==. | percentgivendg==. 


*******
*** Linear regressions
*******
reg percentgivendg costat recdgnone recdgmid recdghigh age male if country=="germany"
estat ic
reg percentgivendg ladder recdgnone recdgmid recdghigh age male if country=="germany"
estat ic

reg percentgivendg costat recdgnone recdgmid recdghigh age male if country=="poland"
estat ic
reg percentgivendg ladder recdgnone recdgmid recdghigh age male if country=="poland"
estat ic

reg percentgivendg costat recdgnone recdgmid recdghigh age male if country=="sweden"
estat ic
reg percentgivendg ladder recdgnone recdgmid recdghigh age male if country=="sweden"
estat ic

reg percentgivendg costat recdgnone recdgmid recdghigh age male if country=="usa"
estat ic
reg percentgivendg ladder recdgnone recdgmid recdghigh age male if country=="usa"
estat ic


reg  percentgivendg costat recdgnone recdgmid recdghigh age male, vce(cluster country)
estat ic
reg  percentgivendg ladder recdgnone recdgmid recdghigh age male, vce(cluster country)
estat ic

*Time dictator game
reg  percentkepttg costat rectgnone rectgmid rectghigh age male if country=="germany"
estat ic
reg  percentkepttg ladder rectgnone rectgmid rectghigh age male if country=="germany"
estat ic

reg  percentkepttg costat rectgnone rectgmid rectghigh age male if country=="poland"
estat ic
reg  percentkepttg ladder rectgnone rectgmid rectghigh age male if country=="poland"
estat ic

reg  percentkepttg costat rectgnone rectgmid rectghigh age male if country=="sweden"
estat ic
reg  percentkepttg ladder rectgnone rectgmid rectghigh age male if country=="sweden"
estat ic

reg  percentkepttg costat rectgnone rectgmid rectghigh age male if country=="usa"
estat ic
reg  percentkepttg ladder rectgnone rectgmid rectghigh age male if country=="usa"
estat ic

reg  percentkepttg costat rectgnone rectgmid rectghigh age male, vce(cluster country) 
estat ic
reg  percentkepttg ladder rectgnone rectgmid rectghigh age male, vce(cluster country) 
estat ic

	
*******
** Robustness checks, Per Country
*******

levelsof country, local(land)

foreach i of local land {	
	
	*** Robustness different status
	//drop costat outlier
	preserve
	keep if country == `"`i'"'
	sum costat, detail
	keep if inrange(costat, r(p5), r(p95))

	*Money dictator game
	churdle linear percentgivendg costat recdgnone recdgmid recdghigh age male if country == `"`i'"', select(costat recdgnone recdgmid recdghigh age male) ll(0)
	est sto rob_`i'_dg_nooutlier

	*Time dictator game
	churdle linear percentkepttg costat rectgnone rectgmid rectghigh age male if country == `"`i'"', select(costat rectgnone rectgmid rectghigh age male) ll(0)
	est sto rob_`i'_tg_nooutlier

	restore

	//split objective measures
	churdle linear percentgivendg isced recdgnone recdgmid recdghigh age male if country == `"`i'"', select(isced recdgnone recdgmid recdghigh age male) ll(0) 
	est sto rob_`i'_dg_isced
	churdle linear percentgivendg eqincome2decile recdgnone recdgmid recdghigh age male if country == `"`i'"', select(eqincome2decile recdgnone recdgmid recdghigh age male) ll(0) 
	est sto rob_`i'_dg_income
	if `"`i'"'!="sweden" {
		churdle linear percentgivendg siops2 recdgnone recdgmid recdghigh age male if country == `"`i'"', select(siops2 recdgnone recdgmid recdghigh age male) ll(0) 
		est sto rob_`i'_dg_siops
	}

	churdle linear percentkepttg isced rectgnone rectgmid rectghigh age male if country == `"`i'"', select(isced rectgnone rectgmid rectghigh age male) ll(0)
	est sto rob_`i'_tg_isced
	churdle linear percentkepttg eqincome2decile rectgnone rectgmid rectghigh age male if country == `"`i'"', select(eqincome2decile rectgnone rectgmid rectghigh age male) ll(0)
	est sto rob_`i'_tg_income
	if `"`i'"'!="sweden" { 
		churdle linear percentkepttg siops2 rectgnone rectgmid rectghigh age male if country == `"`i'"', select(siops2 rectgnone rectgmid rectghigh age male) ll(0)
		est sto rob_`i'_tg_siops
	}

	//other ostat definitions
	if `"`i'"'!="sweden" { 
		churdle linear percentgivendg costatall recdgnone recdgmid recdghigh age male if country == `"`i'"', select(costatall recdgnone recdgmid recdghigh age male) ll(0) 
		est sto rob_`i'_dg_ostatall
		churdle linear percentgivendg costatincomesiops recdgnone recdgmid recdghigh age male if country == `"`i'"', select(costatincomesiops recdgnone recdgmid recdghigh age male) ll(0) 
		est sto rob_`i'_dg_ostatincsio
		churdle linear percentgivendg costatedusiops recdgnone recdgmid recdghigh age male if country == `"`i'"', select(costatedusiops recdgnone recdgmid recdghigh age male) ll(0) 
		est sto rob_`i'_dg_ostatedusio
	}
	churdle linear percentgivendg costateduincome recdgnone recdgmid recdghigh age male if country == `"`i'"', select(costateduincome recdgnone recdgmid recdghigh age male) ll(0) 
	est sto rob_`i'_dg_ostateduinc

	if `"`i'"'!="sweden" { 
		churdle linear percentkepttg costatall rectgnone rectgmid rectghigh age male if country == `"`i'"', select(costatall rectgnone rectgmid rectghigh age male) ll(0) 
		est sto rob_`i'_tg_ostatall
		churdle linear percentkepttg costatincomesiops rectgnone rectgmid rectghigh age male if country == `"`i'"', select(costatincomesiops rectgnone rectgmid rectghigh age male) ll(0) 
		est sto rob_`i'_tg_ostatincsio
		churdle linear percentkepttg costatedusiops rectgnone rectgmid rectghigh age male if country == `"`i'"', select(costatedusiops rectgnone rectgmid rectghigh age male) ll(0) 
		est sto rob_`i'_tg_ostatedusio
	}
	churdle linear percentkepttg costateduincome rectgnone rectgmid rectghigh age male if country == `"`i'"', select(costateduincome rectgnone rectgmid rectghigh age male) ll(0)
	est sto rob_`i'_tg_ostateduinc


	//imputed and not imputed
	if `"`i'"'!="sweden" {  
		churdle linear percentgivendg siops recdgnone recdgmid recdghigh age male if country == `"`i'"', select(siops recdgnone recdgmid recdghigh age male) ll(0) 
		est sto rob_`i'_dg_siops2
	}
	churdle linear percentgivendg eqincomedecile recdgnone recdgmid recdghigh age male if country == `"`i'"', select(eqincomedecile recdgnone recdgmid recdghigh age male) ll(0) 
	est sto rob_`i'_dg_income2
	
	if `"`i'"'!="sweden" {
		churdle linear percentkepttg siops rectgnone rectgmid rectghigh age male if country == `"`i'"', select(siops rectgnone rectgmid rectghigh age male) ll(0) 
		est sto rob_`i'_tg_siops2
	}
	churdle linear percentkepttg eqincomedecile rectgnone rectgmid rectghigh age male if country == `"`i'"', select(eqincomedecile rectgnone rectgmid rectghigh age male) ll(0)
	est sto rob_`i'_tg_income2


esttab rob_`i'_dg_*  using robustdg_`i'_20211019.rtf, scalars("ll Log likelihood") onecell label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace 
esttab rob_`i'_tg_* using robusttg_`i'_20211019.rtf, scalars("ll Log likelihood") onecell label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace 	
}


	
*******
** Robustness checks, Pooled
*******

*** Robustness different status
//drop ostat outlier
preserve
sum costat, detail
keep if inrange(costat, r(p5), r(p94))

*Money dictator game
churdle linear percentgivendg costat recdgnone recdgmid recdghigh age male, select(costat recdgnone recdgmid recdghigh age male) ll(0) vce(cluster country)
est sto rob_dg_nooutlier

*Time dictator game
churdle linear percentkepttg costat rectgnone rectgmid rectghigh age male, select(costat rectgnone rectgmid rectghigh age male) ll(0) vce(cluster country) 
est sto rob_tg_nooutlier

restore
 
//split objective measures
churdle linear percentgivendg isced recdgnone recdgmid recdghigh age male, select(isced recdgnone recdgmid recdghigh age male) ll(0) vce(cluster country)
est sto rob_dg_isced
churdle linear percentgivendg eqincome2decile recdgnone recdgmid recdghigh age male, select(eqincome2decile recdgnone recdgmid recdghigh age male) ll(0) vce(cluster country)
est sto rob_dg_income
churdle linear percentgivendg siops2 recdgnone recdgmid recdghigh age male, select(siops2 recdgnone recdgmid recdghigh age male) ll(0) vce(cluster country)
est sto rob_dg_siops

churdle linear percentkepttg isced rectgnone rectgmid rectghigh age male, select(isced rectgnone rectgmid rectghigh age male) ll(0) vce(cluster country)
est sto rob_tg_isced
churdle linear percentkepttg eqincome2decile rectgnone rectgmid rectghigh age male, select(eqincome2decile rectgnone rectgmid rectghigh age male) ll(0) vce(cluster country)
est sto rob_tg_income
churdle linear percentkepttg siops2 rectgnone rectgmid rectghigh age male, select(siops2 rectgnone rectgmid rectghigh age male) ll(0) vce(cluster country)
est sto rob_tg_siops

//other ostat definitions
churdle linear percentgivendg costatall recdgnone recdgmid recdghigh age male, select(costatall recdgnone recdgmid recdghigh age male) ll(0) vce(cluster country)
est sto rob_dg_ostatall
churdle linear percentgivendg costatincomesiops recdgnone recdgmid recdghigh age male, select(costatincomesiops recdgnone recdgmid recdghigh age male) ll(0) vce(cluster country)
est sto rob_dg_ostatincsio
churdle linear percentgivendg costatedusiops recdgnone recdgmid recdghigh age male, select(costatedusiops recdgnone recdgmid recdghigh age male) ll(0) vce(cluster country)
est sto rob_dg_ostatedusio
churdle linear percentgivendg costateduincome recdgnone recdgmid recdghigh age male, select(costateduincome recdgnone recdgmid recdghigh age male) ll(0) vce(cluster country)
est sto rob_dg_ostateduinc

churdle linear percentkepttg costatall rectgnone rectgmid rectghigh age male, select(costatall rectgnone rectgmid rectghigh age male) ll(0) vce(cluster country)
est sto rob_tg_ostatall
churdle linear percentkepttg costatincomesiops rectgnone rectgmid rectghigh age male, select(costatincomesiops rectgnone rectgmid rectghigh age male) ll(0) vce(cluster country) 
est sto rob_tg_ostatincsio
churdle linear percentkepttg costatedusiops rectgnone rectgmid rectghigh age male, select(costatedusiops rectgnone rectgmid rectghigh age male) ll(0) vce(cluster country)
est sto rob_tg_ostatedusio
churdle linear percentkepttg costateduincome rectgnone rectgmid rectghigh age male, select(costateduincome rectgnone rectgmid rectghigh age male) ll(0) vce(cluster country)
est sto rob_tg_ostateduinc

//imputed and not imputed
churdle linear percentgivendg siops recdgnone recdgmid recdghigh age male, select(siops recdgnone recdgmid recdghigh age male) ll(0) vce(cluster country)
est sto rob_dg_siops2
churdle linear percentgivendg eqincomedecile recdgnone recdgmid recdghigh age male, select(eqincomedecile recdgnone recdgmid recdghigh age male) ll(0) vce(cluster country)
est sto rob_dg_income2

churdle linear percentkepttg siops rectgnone rectgmid rectghigh age male, select(siops rectgnone rectgmid rectghigh age male) ll(0) vce(cluster country)
est sto rob_tg_siops2
churdle linear percentkepttg eqincomedecile rectgnone rectgmid rectghigh age male, select(eqincomedecile rectgnone rectgmid rectghigh age male) ll(0) vce(cluster country)
est sto rob_tg_income2


esttab rob_dg_*  using robustdg.rtf, scalars("ll Log likelihood") onecell label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace 
esttab rob_tg_* using robusttg.rtf, scalars("ll Log likelihood") onecell label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace 
	
	
******
** Checking for interactions
******	
//make low receiver to reference category
gen receiverdg2 = receiverdg
replace receiverdg2 = 0 if receiverdg==1
replace receiverdg2 = 1 if receiverdg==0

gen receivertg2 = receivertg
replace receivertg2 = 0 if receivertg==1
replace receivertg2 = 1 if receivertg==0


//mdg
churdle linear percentgivendg c.costat##i.receiverdg2 age male, select(c.costat##i.receiverdg2 age male) ll(0) vce(cluster country)
est sto interaction_mdg_1
churdle linear percentgivendg c.ladder##i.receiverdg2 age male, select(c.ladder##i.receiverdg2 age male) ll(0) vce(cluster country)
est sto interaction_mdg_2

churdle linear percentgivendg c.costat##i.receiverdg2 age male if country=="germany", select(c.costat##i.receiverdg2 age male) ll(0) 
est sto interaction_mdg_ger1
churdle linear percentgivendg c.ladder##i.receiverdg2 age male if country=="germany", select(c.ladder##i.receiverdg2 age male) ll(0) 
est sto interaction_mdg_ger2

churdle linear percentgivendg c.costat##i.receiverdg2 age male if country=="poland", select(c.costat##i.receiverdg2 age male) ll(0) 
est sto interaction_mdg_pol1
churdle linear percentgivendg c.ladder##i.receiverdg2 age male if country=="poland", select(c.ladder##i.receiverdg2 age male) ll(0) 
est sto interaction_mdg_pol2

churdle linear percentgivendg c.costat##i.receiverdg2 age male if country=="usa", select(c.costat##i.receiverdg2 age male) ll(0) 
est sto interaction_mdg_usa1
churdle linear percentgivendg c.ladder##i.receiverdg2 age male if country=="usa", select(c.ladder##i.receiverdg2 age male) ll(0) 
est sto interaction_mdg_usa2

churdle linear percentgivendg c.costat##i.receiverdg2 age male if country=="sweden", select(c.costat##i.receiverdg2 age male) ll(0) 
est sto interaction_mdg_swe1
churdle linear percentgivendg c.ladder##i.receiverdg2 age male if country=="sweden", select(c.ladder##i.receiverdg2 age male) ll(0)
est sto interaction_mdg_swe2

//tdg
churdle linear percentkepttg c.costat##i.receivertg2 age male, select(c.costat##i.receivertg2 age male) ll(0) vce(cluster country)
est sto interaction_tdg_1
churdle linear percentkepttg c.ladder##i.receivertg2 age male, select(c.ladder##i.receivertg2 age male) ll(0) vce(cluster country)
est sto interaction_tdg_2

churdle linear percentkepttg c.costat##i.receivertg2 age male if country=="germany", select(c.costat##i.receivertg2 age male) ll(0) 
est sto interaction_tdg_ger1
churdle linear percentkepttg c.ladder##i.receivertg2 age male if country=="germany", select(c.ladder##i.receivertg2 age male) ll(0) 
est sto interaction_tdg_ger2

churdle linear percentkepttg c.costat##i.receivertg2 age male if country=="poland", select(c.costat##i.receivertg2 age male) ll(0) 
est sto interaction_tdg_pol1
churdle linear percentkepttg c.ladder##i.receivertg2 age male if country=="poland", select(c.ladder##i.receivertg2 age male) ll(0) 
est sto interaction_tdg_pol2

churdle linear percentkepttg c.costat##i.receivertg2 age male if country=="usa", select(c.costat##i.receivertg2 age male) ll(0) 
est sto interaction_tdg_usa1
churdle linear percentkepttg c.ladder##i.receivertg2 age male if country=="usa", select(c.ladder##i.receivertg2 age male) ll(0) 
est sto interaction_tdg_usa2

churdle linear percentkepttg c.costat##i.receivertg2 age male if country=="sweden", select(c.costat##i.receivertg2 age male) ll(0) 
est sto interaction_tdg_swe1
churdle linear percentkepttg c.ladder##i.receivertg2 age male if country=="sweden", select(c.ladder##i.receivertg2 age male) ll(0)
est sto interaction_tdg_swe2


//export
esttab interaction_mdg_* using interaction_mdg.rtf, scalars("ll Log likelihood" "aic AIC" "bic BIC") onecell label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace 
esttab interaction_tdg_* using interaction_tdg.rtf, scalars("ll Log likelihood" "aic AIC" "bic BIC") onecell label starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) replace 	