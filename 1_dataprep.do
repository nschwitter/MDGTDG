clear

use "Data_Fourcountry_Main_20220408_anonymised.dta"
set seed 1199552211 

********
** Code variables
********

***ID
gen case_id = _n

*** Countries
gen germany = country == "germany"
gen usa = country == "usa"
gen sweden = country == "sweden"
gen poland = country == "poland"

***Socio Demographics
gen age =  2021 - QID7
clonevar gender = QID6
gen male = gender == 1

//employment situation
clonevar employ = QID66
replace employ = 8 if strpos(QID66_9_TEXT, "Housewife-chores") | strpos(QID66_9_TEXT, "Hausfrau") |  strpos(QID66_9_TEXT, "Stay at home") | QID66_9_TEXT=="mama" | QID66_9_TEXT=="Föräldraledig" | QID66_9_TEXT=="Förvaltare/God man" |  strpos(QID66_9_TEXT, "housework")
replace employ = 5 if QID66_9_TEXT=="Arbeitsunfähig" | QID66_9_TEXT=="Hemma sjuk" | QID66_9_TEXT=="Krankgeschrieben" | strpos(QID66_9_TEXT, "Långtidssjukskriven") | QID66_9_TEXT=="illness" | QID66_9_TEXT=="disabled"
replace employ = 2 if QID66_9_TEXT=="student" | QID66_9_TEXT=="studentka" | strpos(QID66_9_TEXT, "höststudier") | QID66_9_TEXT=="Lernen für das Abitur" | strpos(QID66_9_TEXT, "Nauka") | strpos(QID66_9_TEXT, "nauka")
replace employ = 3 if strpos(QID66_9_TEXT, "Arbeitslos, trete aber")
replace employ = 1 if QID66_9_TEXT=="angestellte vollzeit" | QID66_9_TEXT=="Vollzeit Berufstätig"
replace employ=6 if QID66_9_TEXT=="rentner" | QID66_9_TEXT=="renta" | QID66_9_TEXT=="Rentner" | QID66_9_TEXT=="Renta"


***Education
//isced97 
//usa
gen isced = .
replace isced = 0 if QID65==1
replace isced = 1 if QID65==2 | QID540==2
replace isced = 2 if QID65==3 | QID540==3
replace isced = 3 if QID65==4 | QID540==4
//replace isced = 4 if //only certificate we did not collect
replace isced = 5 if QID65==6 | QID540==6 | QID65==7 | QID540==7 | QID65==8 | QID540==8
replace isced = 6 if QID65==9 | QID540==9

//poland
replace isced = 0 if QID541==2
replace isced = 1 if QID541==3 | QID544==3
replace isced = 2 if QID541==4 | QID544==4 | QID541==5 | QID544==5 | QID541==6 | QID544==6 
replace isced = 3 if QID541==7 | QID544==7 | QID541==8 | QID544==8 | QID541==9 | QID544==9 | QID541==10 | QID544==10 | QID541==11 | QID544==11
replace isced = 4 if QID541==11 | QID544==11 | QID541==12 | QID544==12
replace isced = 5 if QID541==13 | QID544==13 | QID541==14 | QID544==14 | QID541==16 | QID544==16 
replace isced = 6 if QID541==17 | QID544==17

//set for sweden
replace isced = 0 if QID542==2 | QID543==2
replace isced = 1 if QID542==3 | QID543==3
replace isced = 2 if QID542==4 | QID543==4
replace isced = 3 if QID542==5 | QID543==5 | QID542==6 | QID543==6 | QID542==7 | QID543==7 
replace isced = 4 if QID542==8 | QID543==8 | QID542==9 | QID543==9 | QID542==10 | QID543==10 | QID542==11 | QID543==11 
replace isced = 5 if (QID542>=12 & QID542 < 21) | (QID543>=12 & QID543 < 21)
replace isced = 6 if QID542==21 | QID543==21

//set for germany
replace isced = 0 if QID535==2 
replace isced = 1 if (QID535==3 & QID538_2==1) | (QID537==3 & QID538_2==1)
replace isced = 2 if (QID535==4 & QID538_2==1) | (QID537==4 & QID538_2==1) |  (QID535==5 & QID538_2==1) | (QID537==5 & QID538_2==1)
replace isced = 3 if isced==. & country=="germany" //rest-category, will be overwritten
replace isced = 4 if (QID535==7 &  (QID538_1 ==1 | QID538_16==1)) | /// 
					 (QID537==7 &  (QID538_1 ==1 | QID538_16==1)) |  /// Abi und Ausbildung
					 (QID535==6 &  (QID538_1 ==1 | QID538_16==1)) | /// 
					 (QID537==6 &  (QID538_1 ==1 | QID538_16==1))  // Fachabi und Ausbildung
replace isced=5 if QID538_4==1 | QID538_3==1 | /// Hochschulkategorien
					 QID545_15==1 | QID539==15 | /// Laufbahnpruefung
					 QID545_6==1 | QID539 == 6  // Erzieher					 
replace isced = 6 if QID546_9==1 | QID547 == 9


//country suseducationpecific variables for imputation
gen  = QID65
replace useducation = QID540 if QID65==10

gen poleducation = QID541
replace poleducation = QID544 if  QID541==18

gen sweducation = QID542
replace sweducation = QID543 if  QID542==1

gen deducation = QID535
replace deducation = QID537 if QID535==1

gen deducationindi = deducation != . & country=="germany"
replace deducation = 1 if deducationindi==0 & country=="germany"

gen ausbildung = .
replace ausbildung = 0 if country=="germany"
replace ausbildung = 1 if QID538_1==1 | QID538_16==1

gen studium = .
replace studium = 0 if country=="germany"
replace studium = 1 if QID538_3==1 | QID538_4==1

***Householdsize
gen household = QID29
replace household = .  if household==96747.00

gen u18household = real(QID30)
replace u18household = .  if  u18household==5436
replace u18household = 0  if u18household==. & household !=.

gen u14household = real(QID30)
replace u14household = 0 if QID226=="None"
replace u14household = 0 if QID226==")"
replace u14household = 0  if u14household==. & household !=.
replace u14household = .  if  u14household==5436

gen hh18factor = household - 1 - u14household
gen oecdfactor = 1 + hh18factor * 0.5 + u14household * 0.3 //modified oect equivalence scale

gen oecdfactor2 = oecdfactor
sum oecdfactor
replace oecdfactor2=r(mean) if oecdfactor==. //set to mean for missing values

***Income - Earnings per year
gen income = QID224_7 * 12

//replace missing with mid of category (categories are yearly incomes for usa, sweden, germany)
replace income = . if QID31==11
replace income = 10000 if QID31==1 & country == "usa"
replace income = 30000 if QID31==3 & country == "usa"
replace income = 57500  if QID31==5 & country == "usa"
replace income = 115000 if QID31==8 & country == "usa"
replace income = 18000 if QID31==3 & country == "sweden"
replace income = 58000 if QID31==10 & country == "sweden"
replace income = 1650*12 if QID31==2 & country == "poland"
replace income = 2150*12 if QID31==3 & country == "poland"
replace income = 4350*12 if QID31==7 & country == "poland"
replace income = 11000 if QID31==1 & country == "germany"
replace income = 15000 if QID31==2 & country == "germany"
replace income = 38500 if QID31==7 & country == "germany"
replace income = 45750 if QID31==8 & country == "germany"
replace income = 54000 if QID31==9 & country == "germany"
replace income = 67000 if QID31==10 & country == "germany"

gen rawincome = income

*** Outliers / implausible values
//Replacement of impaulsible values (inconsistent answering behaviour)
//Multiplication * 1000 if missed "k" in the answer
replace income = income * 1000 if income < 500  & country=="germany" 
replace income = . if income < 500  & QID531=="Weiß nicht" & country=="germany" 
replace income = . if income < 400  & income > 100 & country=="germany" 
replace income = . if income < 1000 & (employ==1)  & country=="germany" 
 
replace income = . if income==1233996 & country=="germany"
replace income = . if income==1596000 & country=="germany"
replace income = . if income==1056000 & country=="germany"
replace income = . if income > 1000000 & QID7 >= 2000  & country=="germany"

replace income = . if income == 42 & strpos(QID532, "Inżynier konstrukcj") == 1 
replace income = . if (income ==72 | income > 150 & income < 1000)  & country=="poland"
replace income = income * 1000 if income < 150 &  country=="poland" 
replace income = . if income < 1000 & (employ==1)  & country=="poland" 

replace income = . if income==1008000 & country=="poland"
replace income = . if income > 1000000 & QID7 >= 2000  & country=="poland"

replace income = income * 1000 if (income==12 | income==24 | income==36 | income==48 | income==96 | income==120 | income==144 | income==240 | income==360 | income==480 | income==540 | income==1200) & (employ==1 | employ==10)  & country=="sweden" 
replace income = . if income < 10000 & (employ==1)  & country=="sweden" 
replace income = . if income > 10000000 & QID9_1 <=5  & country=="sweden" 
replace income = . if case_id==1880  |  case_id==2064 | case_id==4712
replace income = . if income > 10000000 & QID7 >= 2000  & country=="sweden" 

replace income = income * 1000 if income <85 & country=="usa"
replace income = income * 1000 if income ==144 & strpos(QID466, "Clinical re")==1 & country=="usa"
replace income = income * 1000 if income ==480 & country=="usa"
replace income = income * 1000 if income ==600 & strpos(QID466, "IT department")==1 & country=="usa"

replace income = . if income < 1000 & (employ==1)  & country=="usa" 
replace income = . if income==120.816 | income== 199.2 
replace income = . if income==960000000 & country=="usa"
replace income = . if income==12000000 & country=="usa"
replace income = . if income==10800000 & country=="usa"
replace income = . if income==7200000 & country=="usa"

replace income = . if income==1764000 & country=="usa" 
replace income = . if income==1800000 & QID466=="Student undegraduate" & country=="usa" 
replace income = . if income==2280000 & QID466=="Student" & country=="usa" 

replace income = . if income > 1500000 & QID7 >= 2000  & country=="usa"
replace income = . if income > 1500000 & QID9_1 <=5  & country=="usa"
replace income = . if income==0 & (employ==1 | employ== 10)


** Imputation income
gen income2 = income

//missing indicators for predictors
gen employ2 = employ
replace employ2=99 if employ==. 

gen household2 = household
replace household2 = 0 if household==. 
gen householdindi = household==.

reg income age i.gender useducation i.employ2 household2 householdindi if country=="usa"
predict income_pre_usa
replace income2 = income_pre_usa +  rnormal(0,e(rmse)) if income==. & country=="usa"

reg income age i.gender deducation i.ausbildung i.studium i.employ2 household2 householdindi if country=="germany"
predict income_pre_ger
replace income2 = income_pre_ger +  rnormal(0,e(rmse)) if income==. & country=="germany"

reg income age i.gender poleducation i.employ2 household2 householdindi if country=="poland"
predict income_pre_pol
replace income2 = income_pre_pol +  rnormal(0,e(rmse)) if income==. & country=="poland"

reg income age i.gender sweducation i.employ2 household2 householdindi if country=="sweden"
predict income_pre_swe
replace income2 = income_pre_swe +  rnormal(0,e(rmse)) if income==. & country=="sweden"

replace income2 = 0 if income2<0

** Equivalenceincome
gen equivalenceincome = income / oecdfactor2
gen equivalenceincome2 = income2 / oecdfactor2
	
** Deciles
egen eqincomedecile = xtile(equivalenceincome), by(country) nq(10)
egen eqincome2decile = xtile(equivalenceincome2), by(country) nq(10)


***ISCO / Job prestige
quietly do 1_3_codeisco.do 


*** Social status composite measurement
center eqincome2decile, gen(cincomedeciles) stand
center isced, gen(ceducation) stand
center siops2, gen(csiops2) stand
center siops, gen(csiops) stand

gen ostatall = (cincomedeciles + ceducation + csiops2)/3 if !missing(cincomedeciles, ceducation , csiops2)
bysort country:  center ostatall, standardize gen(costatall)

gen ostateduincome = (cincomedeciles + ceducation)/3 if !missing(cincomedeciles, ceducation) 
bysort country: center ostateduincome, standardize gen(costateduincome)	

gen ostatedusiops = (ceducation + csiops2)/3 if !missing(ceducation , csiops2)
bysort country:  center ostatedusiops, standardize gen(costatedusiops)

gen ostatincomesiops = (cincomedeciles + csiops2)/3 if !missing(cincomedeciles, csiops2)
bysort country: center ostatincomesiops, standardize gen(costatincomesiops)

gen ostat = ostatall
replace ostat = ostateduincome if ostat==. 
tab ostat, miss

gen costat=costatall
replace costat = costateduincome if costat==. 
tab costat, miss

***Subjective Status
gen ladder = QID9_1 - 1


***Dictator Game
gen recdgnone = 0
gen recdglow = 0
gen recdgmid = 0
gen recdghigh = 0

replace recdgnone = 1 if QID469_1 !=.
replace recdglow = 1 if QID472_1 !=.
replace recdgmid = 1 if QID479_1 !=.
replace recdghigh = 1 if QID480_1 !=.

gen receiverdg = .
replace receiverdg = 0 if recdgnone == 1
replace receiverdg = 1 if recdglow == 1
replace receiverdg = 2 if recdgmid == 1
replace receiverdg = 3 if recdghigh == 1

gen percentgivendg = QID469_1
replace percentgivendg = QID472_1 if QID472_1 !=.
replace percentgivendg = QID479_1 if QID479_1 !=.
replace percentgivendg = QID480_1 if QID480_1 !=.

gen givendg = percentgivendg>0

***Time Game
gen rectgnone = 0
gen rectglow = 0
gen rectgmid = 0
gen rectghigh = 0

replace rectgnone = 1 if QID470_3 !=.
replace rectglow = 1 if QID475_3 !=.
replace rectgmid = 1 if QID476_3 !=.
replace rectghigh = 1 if QID477_3 !=.

gen receivertg = .
replace receivertg = 0 if rectgnone == 1
replace receivertg = 1 if rectglow == 1
replace receivertg = 2 if rectgmid == 1
replace receivertg = 3 if rectghigh == 1

gen percentgiventg = QID470_3
replace percentgiventg = QID475_3 if QID475_3 !=.
replace percentgiventg = QID476_3 if QID476_3 !=.
replace percentgiventg = QID477_3 if QID477_3 !=.

gen giventg = percentgiventg>0
gen percentkepttg = 100-percentgiventg


***************
*** Labelling
***************


label var percentgivendg "Percentage given MDG"
label var percentkepttg "Percentage kept TDG"

label var ostat "Objective social status (composite)"
label var costat "Objective social status (composite, cent.)"

label var recdgnone "Receiver: No status info"
label var recdglow "Receiver: Low status"
label var recdgmid "Receiver: Medium status"
label var recdghigh "Receiver: High status"

label var rectgnone "Receiver: No status info"
label var rectglow "Receiver: Low status"
label var rectgmid "Receiver: Medium status"
label var rectghigh "Receiver: High status"

label var age "Age"
label var male "Male"

label var ladder "Subjective social status"

label var isced "Education"
label var eqincome2decile "Income deciles"
label var eqincomedecile "Income deciles (no imputations)"

label var siops2 "Job prestige"
label var siops "Job prestige (no imputations)"

label var costatall "Social status (composite: education, income and job prestige)"
label var costatincomesiops "Social status (composite: income and job prestige)"
label var costatedusiops "Social status (composite: education and job prestige)"
label var costateduincome "Social status (composite: education and income)"


save "Data_Fourcountry_Main_20211007_anonymised_prepared.dta", replace