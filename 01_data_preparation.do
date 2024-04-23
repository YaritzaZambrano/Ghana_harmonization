// Project: The Effect of Zipline Drone in Ghana
// Author: Khusel Avirmed
// Last Update: 11/2/2023
// Tasks: Cleaning Wave 3
//// Purpose: 

// This Stata code is part of a project to analyze the effect of Zipline drones in Ghana. 
// The code is responsible for data cleaning and preparation in two main modules: 
// Module 6, Part A and Module 6, Part C.
//
// For both Module 6, Part A and C:
//
// 1. Sets directories for data.
// 2. Loads and cleans the raw data for Module 6, Part A.
// 3. Creates and renames dummy variables for various questionnaire responses.
// 4. Orders and saves the cleaned data for this module.
// 5. Finally, the code merges the cleaned data sets from both modules,
//    ensuring the variables are ordered consistently. The code also employs global 
//    macros for file paths and variables to make the process more efficient and maintainable.

* Setting directories

// cd ..
global zipline_data "..\`pwd'"
global data_folder "$zipline_data\data"
global do_folder "$zipline_data\do"
global fig_folder "$zipline_data\fig"


* Module 6, Part A
use "$data_folder\raw\Wave 3\06a_insurance.dta", clear

global tempvarlist FPrimary hhmid age gender relationship ///
	everinsured insurancetype insurancetype_0 ///
	insurancetype_1 insurancetype_2 insurancetype_3 ///
	insurancetype_4 insurancetype_666 insurancetype_888 ///
	insurancetype_999 insurancetypeother /// Q2
	whynotnhis whynotnhis_1 whynotnhis_2 whynotnhis_3 whynotnhis_4 ///
	whynotnhis_5 whynotnhis_6 whynotnhis_7 whynotnhis_666 whynotnhis_888 ///
	whynotnhis_999 whynotnhisother /// Q3a
	whopayshealth whopayshealth_1 whopayshealth_2 whopayshealth_3 ///
	whopayshealth_4 whopayshealth_5 whopayshealth_6 whopayshealth_7 ///
	whopayshealth_8 whopayshealth_9 whopayshealth_10 whopayshealth_666 ///
	whopayshealth_777 whopayshealth_888 whopayshealth_999 whopaysother whopayshhmid /// Q4
	nhiscard /// Q5
	nhiscardwhynot nhiscardwhynotother /// Q6
	insurancetotalpaid /// Q7
	nhisbenefitted /// Q10
	nhisrenewwhynot nhisrenewwhynotother /// Q14
	groupschemes groupschemes_0 groupschemes_1 groupschemes_2 ///
	groupschemes_3 groupschemes_4 groupschemes_666 groupschemes_888 ///
	groupschemes_999 groupschemesother // Q15

tostring FPrimary, replace
keep $tempvarlist

* % individuals who have ever been registered or covered by a health insurance scheme
replace insurancetype_0 = . if insurancetype == ""

* replace insurancetype_1 = 1 if regexm(insurancetype, "1")
* replace insurancetype_1 = 0 if insurancetype !="1"
replace insurancetype_1 = . if insurancetype == ""
replace insurancetype_2 = . if insurancetype == ""
replace insurancetype_3 = . if insurancetype == ""
replace insurancetype_4 = . if insurancetype == ""
replace insurancetype_666 = . if insurancetype == ""
replace insurancetype_888 = . if insurancetype == ""
replace insurancetype_999 = . if insurancetype == ""

sort everinsured
replace everinsured = . in 18977/19006
gen everinsured_allindv = 0 if everinsured != .
replace everinsured_allindv = 1 if everinsured == 1
label define binary_categ 0 "No" 1 "Yes"

label values everinsured_allindv binary_categ
label var everinsured_allindv "% individuals who ever been insured for all individuals"
 
* household heads insurance
gen everinsured_hhs = 0 if (everinsured != . & relationship ==1)
replace everinsured_hhs = 1 if (everinsured == 1 & relationship == 1)
label values everinsured_hhs binary_categ
label var everinsured_hhs "% individuals who ever been insured by household heads"

* Distribution of individuals by type of health insurance scheme
sort insurancetype
replace insurancetype = "" in 4112
gen insurancetype_allindv = 0 if insurancetype != "" // 0 is None
replace insurancetype_allindv = 1 if insurancetype == "1"
replace insurancetype_allindv = 2 if insurancetype == "2"
replace insurancetype_allindv = 3 if insurancetype == "3"
replace insurancetype_allindv = 4 if insurancetype == "4"
replace insurancetype_allindv = 5 if insurancetype == "-666"
replace insurancetype_allindv = 6 if insurancetype == "-888"
replace insurancetype_allindv = 7 if insurancetype == "-999"
replace insurancetype_allindv = 8 if insurancetype == "1 2"
replace insurancetype_allindv = 9 if insurancetype == "1 3"
replace insurancetype_allindv = 10 if insurancetype == "1 4"
replace insurancetype_allindv = 11 if insurancetype == "1 -666"

label define insurancetype_categ 0 "None" ///
								 1 "National/district health insurance scheme" ///
								 2 "Health insurance through employer" ///
								 3 "Mutual health organization/community based health insurance" ///
								 4 "Other private purchase commercial health insurance" ///
								 5 "Other (please specify)" ///
								 6 "Refuse to answer" ///
								 7 "Do not know" ///
								 8 "Combination of 1 2" ///
								 9 "Combination of 1 3" ///
								 10 "Combination of 1 4" ///
								 11 "Combination of 1 5"
								 
label values insurancetype_allindv insurancetype_categ
label var insurancetype_allindv "all individuals by type of health insurance scheme"								 
tab insurancetype_allindv

* households heads insurancetype
gen insurancetype_hhs = 0 if (insurancetype != "" & relationship ==1)
replace insurancetype_hhs = 1 if (insurancetype == "1" & relationship ==1)
replace insurancetype_hhs = 2 if (insurancetype == "2" & relationship ==1)
replace insurancetype_hhs = 3 if (insurancetype == "3" & relationship ==1)
replace insurancetype_hhs = 4 if (insurancetype == "4" & relationship ==1)
replace insurancetype_hhs = 5 if (insurancetype == "-666" & relationship ==1)
replace insurancetype_hhs = 6 if (insurancetype == "-888" & relationship ==1)
replace insurancetype_hhs = 7 if (insurancetype == "-999" & relationship ==1)
replace insurancetype_hhs = 8 if (insurancetype == "1 2" & relationship ==1)
replace insurancetype_hhs = 9 if (insurancetype == "1 3" & relationship ==1)
replace insurancetype_hhs = 10 if (insurancetype == "1 4" & relationship ==1)
replace insurancetype_hhs = 11 if (insurancetype == "1 -666" & relationship ==1)

label values insurancetype_hhs insurancetype_categ
label var insurancetype_hhs "household heads by type of health insurance scheme"
tab insurancetype_hhs

* All individuals not registered with NHIS
sort whynotnhis
replace whynotnhis = "" in 15476/15478 // delete empty rows with .n .r

local columns 1 2 3 4 5 6 7 666 888 999

foreach col of local columns {
    gen whynothis_allindv_`col' = 0 if whynotnhis != ""
    replace whynothis_allindv_`col' = 1 if strpos(whynotnhis, "`col'") > 0

    if (`col' == 1) {
        label variable whynothis_allindv_`col' "Have not heard of NHIS"
    }
    else if (`col' == 2) {
        label variable whynothis_allindv_`col' "Do not understand the NHIS"
    }
	else if (`col' == 3) {
        label variable whynothis_allindv_`col' "Cannot afford premium"
    }
	else if (`col' == 4) {
        label variable whynothis_allindv_`col' "Do not need health insurance"
    }
	else if (`col' == 5) {
        label variable whynothis_allindv_`col' "NHIS does not cover health insurance needs"
    }
	else if (`col' == 6) {
        label variable whynothis_allindv_`col' "Travel time to enrollment site is too much"
    }
	else if (`col' == 7) {
        label variable whynothis_allindv_`col' "Travel cost to enrollment site is too much"
    }
	else if (`col' == 666) {
        label variable whynothis_allindv_`col' "Other (please specify)"
    }
	else if (`col' == 888) {
        label variable whynothis_allindv_`col' "Refuse to answer"
    }
	else if (`col' == 999) {
        label variable whynothis_allindv_`col' "Do not know"
    }
}

* Household heads not registered with NHIS
foreach col of local columns {
    gen whynothis_hhs_`col' = 0 if (whynotnhis != "" & relationship == 1)
    replace whynothis_hhs_`col' = 1 if (strpos(whynotnhis, "`col'") > 0 & relationship == 1)

    if (`col' == 1) {
        label variable whynothis_hhs_`col' "Have not heard of NHIS"
    }
    else if (`col' == 2) {
        label variable whynothis_hhs_`col' "Do not understand the NHIS"
    }
	else if (`col' == 3) {
        label variable whynothis_hhs_`col' "Cannot afford premium"
    }
	else if (`col' == 4) {
        label variable whynothis_hhs_`col' "Do not need health insurance"
    }
	else if (`col' == 5) {
        label variable whynothis_hhs_`col' "NHIS does not cover health insurance needs"
    }
	else if (`col' == 6) {
        label variable whynothis_hhs_`col' "Travel time to enrollment site is too much"
    }
	else if (`col' == 7) {
        label variable whynothis_hhs_`col' "Travel cost to enrollment site is too much"
    }
	else if (`col' == 666) {
        label variable whynothis_hhs_`col' "Other (please specify)"
    }
	else if (`col' == 888) {
        label variable whynothis_hhs_`col' "Refuse to answer"
    }
	else if (`col' == 999) {
        label variable whynothis_hhs_`col' "Do not know"
    }
}

* % individuals by payer of health insurance cost

* NOTE: Start working from here again!!!

* Create and rename dummy variables for nhiscard
tabulate nhiscard, generate(nhiscard_dummy)
rename nhiscard_dummy1 nhiscard_seen
rename nhiscard_dummy2 nhiscard_not_seen
rename nhiscard_dummy3 nhiscard_no

* Create and rename dummy variables for nhiscardwhynot
tabulate nhiscardwhynot, generate(nhiscardwhynot_dummy)
rename nhiscardwhynot_dummy1 nhiscardwhynot_other
rename nhiscardwhynot_dummy2 nhiscardwhynot_notpaid
rename nhiscardwhynot_dummy3 nhiscardwhynot_norenew
rename nhiscardwhynot_dummy4 nhiscardwhynot_lost

* Create and rename dummy variables for nhisbenefitted
tabulate nhisbenefitted, generate(nhisbenefitted_dummy)
rename nhisbenefitted_dummy1 nhisbenefitted_yes
rename nhisbenefitted_dummy2 nhisbenefitted_no

* Create and rename dummy variables for nhisrenewwhynot
tabulate nhisrenewwhynot, generate(nhisrenewwhynot_dummy)
rename nhisrenewwhynot_dummy1 nhisrenewwhynot_1
rename nhisrenewwhynot_dummy2 nhisrenewwhynot_2
rename nhisrenewwhynot_dummy3 nhisrenewwhynot_3
rename nhisrenewwhynot_dummy4 nhisrenewwhynot_4
rename nhisrenewwhynot_dummy5 nhisrenewwhynot_5
rename nhisrenewwhynot_dummy6 nhisrenewwhynot_6
rename nhisrenewwhynot_dummy7 nhisrenewwhynot_7

global module6_partA_var_list ///
		FPrimary hhmid age gender relationship everinsured insurancetype* ///
		whynotnhis* whopayshealth* whopaysother whopayshhmid nhiscard nhiscard_* ///
		nhiscardwhynot nhiscardwhynot_* nhiscardwhynotother insurancetotalpaid ///
		nhisbenefitted nhisbenefitted_* nhisrenewwhynot nhisrenewwhynot_* ///
		nhisrenewwhynotother groupschemes*
		
* order columns so it is easier to read
order $module6_partA_var_list

save "$data_folder/cleaned/module6_partA.dta", replace

* Module 6, Part C
use "$data_folder\raw\Wave 3\06c_immunization.dta", clear

global tempvarlist FPrimary hhmid age gender relationship ///
	immunized /// Q1
	bcg /// Q2
	polio /// Q3
	dpt /// Q4
	fiveinone /// Q5
	measles /// Q6
	vitamina /// Q7
	yellowfever /// Q8
	immunwhynot /// Q12
	immunwhynotother /// Q12oth

tostring FPrimary, replace
keep $tempvarlist
//
// * there is .d entry across columns which is unknown whether it is valid input or no entry all
// recast string polio
// replace polio = . if polio == ".d"
// replace dpt = . if dpt == ".d"
// replace fiveinone = . if fiveinone == ".d"
// replace measles = . if measles == ".d"

* Create and rename dummy variables for immunized
tabulate immunized, generate(immunized_dummy)
rename immunized_dummy1 immunized_yes
rename immunized_dummy2 immunized_no

gen kids_immunized = 0 if immunized_yes != .
replace kids_immunized = 1 if (immunized_yes == 1) & (relationship == 3 | relationship == 4)
label var kids_immunized "% children immunized"

* Create and rename dummy variables for bcg
tabulate bcg, generate(bcg_dummy)
rename bcg_dummy1 bcg_yes
rename bcg_dummy2 bcg_no

gen kids_bcg = 0 if bcg_yes != .
replace kids_bcg = 1 if (bcg_yes == 1) & (relationship == 3 | relationship == 4)
label var kids_bcg "% children bcg dose"

* Create and rename dummy variables for polio
tabulate polio, generate(polio_dummy)
rename polio_dummy1 polio_none
rename polio_dummy2 polio_one
rename polio_dummy3 polio_two
rename polio_dummy4 polio_three
rename polio_dummy5 polio_four
rename polio_dummy6 polio_booster

* Definition of relationship
/*
1-Household head
2-Spouse
3-Child
4-Grandchild
5-Parent or parent-in-law
6-Son or daughter in-law
7-Other relative (please specify relationship)
8-Adopted, foster, or stepchild
9-Househelp
10-Non-relative (please specify relationship)
*/

* Definition of Polio Complete: 
// DPT/Polio
// The first dose of DPT and POLIO vaccination are given at 6 weeks, the second dose at 10 weeks and the
// third dose at 14 weeks. This means that those aged between 6 and 9 weeks should have received one
// DPT/Polio vaccination while those between the ages of 10 to 13 weeks should have received two such
// vaccinations. A child who is 14 weeks and above should have had 3 doses of DPT/Polio to complete a set.
// (Note that in some cases the first dose of this vaccination is given at birth).
// If a child is 12 weeks old and has received only one dose of DPT/Polio, code 2 will be entered for him in the
// appropriate columns. On the other hand, N/A will be recorded for a 4 week


* % kids who have received at least one polio vaccine
gen kids_polio_atleast1 = 0 if polio_none != .
replace kids_polio_atleast1 = 1 if polio_none == 0 & (relationship == 3 | relationship == 4)
label var kids_polio_atleast1 "polio % children at least one dose"

* % kids who have received a complete polio vaccine schedule
gen kids_polio_complete = 0 if polio_none != .
replace kids_polio_complete = 1 if (polio_three == 1 | polio_four == 1 | polio_booster == 1) & (relationship == 3 | relationship == 4)
label var kids_polio_complete "polio % children complete schedule"


* Create and rename dummy variables for dpt
tabulate dpt, generate(dpt_dummy)
rename dpt_dummy1 dpt_none
rename dpt_dummy2 dpt_one
rename dpt_dummy3 dpt_two
rename dpt_dummy4 dpt_three
rename dpt_dummy5 dpt_four
rename dpt_dummy6 dpt_booster

* % kids who have received at least one dpt vaccine
gen kids_dpt_atleast1 = 0 if dpt_none != .
replace kids_dpt_atleast1 = 1 if dpt_none == 0 & (relationship == 3 | relationship == 4)
label var kids_dpt_atleast1 "dpt % children at least one dose"
tab kids_dpt_atleast1

* % kids who have received a complete dpt vaccine schedule
gen kids_dpt_complete = 0 if dpt_none != .
replace kids_dpt_complete = 1 if (dpt_three == 1 | dpt_four == 1 | dpt_booster == 1) & (relationship == 3 | relationship == 4)
label var kids_dpt_complete "dpt % children complete schedule"
tab kids_dpt_complete

* Create and rename dummy variables for five in one
tabulate fiveinone, generate(fiveinone_dummy)
rename fiveinone_dummy1 fiveinone_yes
rename fiveinone_dummy2 fiveinone_no

gen kids_fiveinone = 0 if fiveinone_yes != .
replace kids_fiveinone = 1 if (fiveinone_yes == 1) & (relationship == 3 | relationship == 4)
label var kids_fiveinone "% children five in one dose"

* Create and rename dummy variables for measles
tabulate measles, generate(measles_dummy)
rename measles_dummy1 measles_yes
rename measles_dummy2 measles_no

gen kids_measles = 0 if measles_yes != .
replace kids_measles = 1 if (measles_yes == 1) & (relationship == 3 | relationship == 4)
label var kids_measles "% children measles dose"

* Create and rename dummy variables for vitamin A
tabulate vitamina, generate(vitamina_dummy)
rename vitamina_dummy1 vitamina_yes
rename vitamina_dummy2 vitamina_no

gen kids_vitamina = 0 if vitamina_yes != .
replace kids_vitamina = 1 if (vitamina_yes == 1) & (relationship == 3 | relationship == 4)
label var kids_vitamina "% children vitamina dose"

* Create and rename dummy variables for yellow fever
tabulate yellowfever, generate(yellowfever_dummy)
rename yellowfever_dummy1 yellowfever_yes
rename yellowfever_dummy2 yellowfever_no

gen kids_yellowfever = 0 if yellowfever_yes != .
replace kids_yellowfever = 1 if (yellowfever_yes == 1) & (relationship == 3 | relationship == 4)
label var kids_yellowfever "% children vitamina dose"

* Create and rename dummy variables for immunwhynot
tabulate immunwhynot, generate(immunwhynot_dummy)
rename immunwhynot_dummy1 immunwhynot_1
rename immunwhynot_dummy2 immunwhynot_2
rename immunwhynot_dummy3 immunwhynot_3
rename immunwhynot_dummy4 immunwhynot_4
rename immunwhynot_dummy5 immunwhynot_5

order FPrimary hhmid age gender relationship kids_*

* define global variable only needed for further analysis
* Here, i keep immunwhynot and drop immunwhynotother
rename immunwhynot kids_immunwhynot
/*
global module6_partC_var_list ///
	FPrimary hhmid age gender relationship immunized immunized_* ///
	bcg bcg_* polio polio_* dpt dpt_* fiveinone fiveinone_* ///
    measles measles_* vitamina vitamina_* yellowfever yellowfever_* ///
    immunwhynot immunwhynot_* immunwhynotother
*/

global module6_partC_var_list ///
	FPrimary hhmid age gender relationship kids_*

* to make it easier to work with it later
order $module6_partC_var_list 
keep $module6_partC_var_list 	  
save "$data_folder/cleaned/module6_partC.dta", replace

// * Module 6, Part A
// * merge cleaned data sets 
// merge 1:1 FPrimary hhmid using "$data_folder/cleaned/module6_partA.dta"
//
// order $module6_partA_var_list $module6_partC_var_list 


* Module 6, Part F
use "$data_folder\raw\Wave 3\06f_past2weeks.dta", clear

* Q1: % individuals sick or injured in the last two weeks

* Generate a new variable anyillness_byage
gen anyillness_byage = 0 if anyillness != . // no illness or sickness
replace anyillness_byage = 1 if (anyillness != 0 & age <= 0) // 0-1 years old
replace anyillness_byage = 2 if (anyillness != 0 & age > 0 & age <= 4) // 1-4 years old
replace anyillness_byage = 3 if (anyillness != 0 & age > 4 & age <= 9) // 5-9 years old
replace anyillness_byage = 4 if (anyillness != 0 & age > 9 & age <= 14) // 10-14 years old
replace anyillness_byage = 5 if (anyillness != 0 & age > 14 & age <= 19) // 15-19 years old
replace anyillness_byage = 6 if (anyillness != 0 & age > 19 & age <= 24) // 20-24 years old
replace anyillness_byage = 7 if (anyillness != 0 & age > 24 & age <= 59) // 25-59 years old
replace anyillness_byage = 8 if (anyillness != 0 & age > 59) // 60+ years old

* Label the categories
label define age_categories 0 "No illness or sickness" ///
                           1 "0-1 years old" ///
                           2 "1-4 years old" ///
                           3 "5-9 years old" ///
                           4 "10-14 years old" ///
                           5 "15-19 years old" ///
                           6 "20-24 years old" ///
                           7 "25-59 years old" ///
                           8 "60+ years old"

label values anyillness_byage age_categories
label var anyillness_byage "% indiv sick or injured"

tab anyillness_byage

* Q2: Distribution of sick individuals by illness

gen whatill_wdiarrhea_byage = 0 if whatillness == 1
replace whatill_wdiarrhea_byage = 1 if (whatillness == 1 & age <= 0) // 0-1 years old
replace whatill_wdiarrhea_byage = 2 if (whatillness == 1 & age > 0 & age <= 4) // 1-4 years old
replace whatill_wdiarrhea_byage = 3 if (whatillness == 1 & age > 4 & age <= 9) // 5-9 years old
replace whatill_wdiarrhea_byage = 4 if (whatillness == 1 & age > 9 & age <= 14) // 10-14 years old
replace whatill_wdiarrhea_byage = 5 if (whatillness == 1 & age > 14 & age <= 19) // 15-19 years old
replace whatill_wdiarrhea_byage = 6 if (whatillness == 1 & age > 19 & age <= 24) // 20-24 years old
replace whatill_wdiarrhea_byage = 7 if (whatillness == 1 & age > 24 & age <= 59) // 25-59 years old
replace whatill_wdiarrhea_byage = 8 if (whatillness == 1 & age > 59) // 60+ years old

label values whatill_wdiarrhea_byage age_categories
label var whatill_wdiarrhea_byage "% indiv watery diarrhea by age"

tab whatill_wdiarrhea_byage

gen whatill_bdiarrhea_byage = 0 if whatillness == 2
replace whatill_bdiarrhea_byage = 1 if (whatillness == 2 & age <= 0) // 0-1 years old
replace whatill_bdiarrhea_byage = 2 if (whatillness == 2 & age > 0 & age <= 4) // 1-4 years old
replace whatill_bdiarrhea_byage = 3 if (whatillness == 2 & age > 4 & age <= 9) // 5-9 years old
replace whatill_bdiarrhea_byage = 4 if (whatillness == 2 & age > 9 & age <= 14) // 10-14 years old
replace whatill_bdiarrhea_byage = 5 if (whatillness == 2 & age > 14 & age <= 19) // 15-19 years old
replace whatill_bdiarrhea_byage = 6 if (whatillness == 2 & age > 19 & age <= 24) // 20-24 years old
replace whatill_bdiarrhea_byage = 7 if (whatillness == 2 & age > 24 & age <= 59) // 25-59 years old
replace whatill_bdiarrhea_byage = 8 if (whatillness == 2 & age > 59) // 60+ years old

label values whatill_bdiarrhea_byage age_categories
label var whatill_bdiarrhea_byage "% indiv diarrhea with blood by age"

tab whatill_bdiarrhea_byage

gen whatill_fever_byage = 0 if whatillness == 3
replace whatill_fever_byage = 1 if (whatillness == 3 & age <= 0) // 0-1 years old
replace whatill_fever_byage = 2 if (whatillness == 3 & age > 0 & age <= 4) // 1-4 years old
replace whatill_fever_byage = 3 if (whatillness == 3 & age > 4 & age <= 9) // 5-9 years old
replace whatill_fever_byage = 4 if (whatillness == 3 & age > 9 & age <= 14) // 10-14 years old
replace whatill_fever_byage = 5 if (whatillness == 3 & age > 14 & age <= 19) // 15-19 years old
replace whatill_fever_byage = 6 if (whatillness == 3 & age > 19 & age <= 24) // 20-24 years old
replace whatill_fever_byage = 7 if (whatillness == 3 & age > 24 & age <= 59) // 25-59 years old
replace whatill_fever_byage = 8 if (whatillness == 3 & age > 59) // 60+ years old

label values whatill_fever_byage age_categories
label var whatill_fever_byage "% indiv fever by age"

tab whatill_fever_byage

gen whatill_coldcough_byage = 0 if whatillness == 4
replace whatill_coldcough_byage = 1 if (whatillness == 4 & age <= 0) // 0-1 years old
replace whatill_coldcough_byage = 2 if (whatillness == 4 & age > 0 & age <= 4) // 1-4 years old
replace whatill_coldcough_byage = 3 if (whatillness == 4 & age > 4 & age <= 9) // 5-9 years old
replace whatill_coldcough_byage = 4 if (whatillness == 4 & age > 9 & age <= 14) // 10-14 years old
replace whatill_coldcough_byage = 5 if (whatillness == 4 & age > 14 & age <= 19) // 15-19 years old
replace whatill_coldcough_byage = 6 if (whatillness == 4 & age > 19 & age <= 24) // 20-24 years old
replace whatill_coldcough_byage = 7 if (whatillness == 4 & age > 24 & age <= 59) // 25-59 years old
replace whatill_coldcough_byage = 8 if (whatillness == 4 & age > 59) // 60+ years old

label values whatill_coldcough_byage age_categories
label var whatill_coldcough_byage "% indiv cold/cough by age"

tab whatill_coldcough_byage

gen whatill_gworm_byage = 0 if whatillness == 5
replace whatill_gworm_byage = 1 if (whatillness == 5 & age <= 0) // 0-1 years old
replace whatill_gworm_byage = 2 if (whatillness == 5 & age > 0 & age <= 4) // 1-4 years old
replace whatill_gworm_byage = 3 if (whatillness == 5 & age > 4 & age <= 9) // 5-9 years old
replace whatill_gworm_byage = 4 if (whatillness == 5 & age > 9 & age <= 14) // 10-14 years old
replace whatill_gworm_byage = 5 if (whatillness == 5 & age > 14 & age <= 19) // 15-19 years old
replace whatill_gworm_byage = 6 if (whatillness == 5 & age > 19 & age <= 24) // 20-24 years old
replace whatill_gworm_byage = 7 if (whatillness == 5 & age > 24 & age <= 59) // 25-59 years old
replace whatill_gworm_byage = 8 if (whatillness == 5 & age > 59) // 60+ years old

label values whatill_gworm_byage age_categories
label var whatill_gworm_byage "% indiv guinea worm by age"

tab whatill_gworm_byage

gen whatill_bilzharzia_byage = 0 if whatillness == 5
replace whatill_bilzharzia_byage = 1 if (whatillness == 5 & age <= 0) // 0-1 years old
replace whatill_bilzharzia_byage = 2 if (whatillness == 5 & age > 0 & age <= 4) // 1-4 years old
replace whatill_bilzharzia_byage = 3 if (whatillness == 5 & age > 4 & age <= 9) // 5-9 years old
replace whatill_bilzharzia_byage = 4 if (whatillness == 5 & age > 9 & age <= 14) // 10-14 years old
replace whatill_bilzharzia_byage = 5 if (whatillness == 5 & age > 14 & age <= 19) // 15-19 years old
replace whatill_bilzharzia_byage = 6 if (whatillness == 5 & age > 19 & age <= 24) // 20-24 years old
replace whatill_bilzharzia_byage = 7 if (whatillness == 5 & age > 24 & age <= 59) // 25-59 years old
replace whatill_bilzharzia_byage = 8 if (whatillness == 5 & age > 59) // 60+ years old

label values whatill_bilzharzia_byage age_categories
label var whatill_bilzharzia_byage "% indiv bilharzia by age"

tab whatill_bilzharzia_byage

* Q8: % individuals who visited health care facility in last two weeks

tab consultfacility
label var consultfacility "% indiv who visited health car facility"

* Q10: Distribution individuals who visited health care facility by reason

tab consultreason
label var consultreason "% indiv who visited health care facility by reason"

* Q11: Distribution individuals who visited health care facility by consultation place

tab consultwhere
label var consultwhere "% indiv who visited health care facility by consultation place"

* Q14: Distribution individuals who visited health care facility by type of facility

tab consultprivate
label var consultprivate "% indiv who visited health care facility by type of facility: public vs private "

* Q17: Descriptive statistics ‘time to travel to and from facility’ (mean, median, sd, min, max, p25,p75)

tab consulttravelhrs consulttravelmins
label var consulttravelhrs "time to travel to health car facility in hours"
label var consulttravelmins "time to travel to health car facility in mins"

* Q23: % individuals who bought medicines or medical supplies

tab purchasemeds
label var purchasemeds "% indiv who bought medicines or medical supplies"

* Q25: % individuals obtained all supplies from the health facility

tab medavailable
label var medavailable "% indiv obtained all supplies from the health facility"

global module6_partF_var_list ///
	FPrimary hhmid age gender relationship ///
	anyillness_byage whatill_wdiarrhea_byage ///
	whatill_bdiarrhea_byage whatill_fever_byage ///
	whatill_coldcough_byage whatill_gworm_byage ///
	whatill_bilzharzia_byage consultfacility ///
	consultreason consultwhere consultprivate ///
	consulttravelhrs consulttravelmins purchasemeds ///
	medavailable

* to make it easier to work with it later
order $module6_partF_var_list 
keep $module6_partF_var_list 	 
save "$data_folder/cleaned/module6_partF.dta", replace

* Module 6, Part G
use "$data_folder\raw\Wave 3\06g_past12months.dta", clear

* Generate a new variable hospitalized?
gen hospitalized_byage = 0 if hospitalized != . // no illness or sickness
replace hospitalized_byage = 1 if (hospitalized == 1 & age <= 0) // 0-1 years old
replace hospitalized_byage = 2 if (hospitalized == 1 & age > 0 & age <= 4) // 1-4 years old
replace hospitalized_byage = 3 if (hospitalized == 1 & age > 4 & age <= 9) // 5-9 years old
replace hospitalized_byage = 4 if (hospitalized == 1 & age > 9 & age <= 14) // 10-14 years old
replace hospitalized_byage = 5 if (hospitalized == 1 & age > 14 & age <= 19) // 15-19 years old
replace hospitalized_byage = 6 if (hospitalized == 1 & age > 19 & age <= 24) // 20-24 years old
replace hospitalized_byage = 7 if (hospitalized == 1 & age > 24 & age <= 59) // 25-59 years old
replace hospitalized_byage = 8 if (hospitalized == 1 & age > 59) // 60+ years old

* Label the categories
label define age_categories 0 "No illness or sickness" ///
                           1 "0-1 years old" ///
                           2 "1-4 years old" ///
                           3 "5-9 years old" ///
                           4 "10-14 years old" ///
                           5 "15-19 years old" ///
                           6 "20-24 years old" ///
                           7 "25-59 years old" ///
                           8 "60+ years old"
						   
label values hospitalized_byage age_categories
label var hospitalized_byage "% indiv who were hospitalized for any sick or injury"
tab hospitalized_byage

global module6_partG_var_list ///
	FPrimary hhmid age gender relationship ///
	hospitalized_byage

* to make it easier to work with it later
order $module6_partG_var_list 
keep $module6_partG_var_list 	 
save "$data_folder/cleaned/module6_partG.dta", replace

* Module 6, Part G
use "$data_folder\raw\Wave 3\07a_fertility.dta", clear

* % women with pregnancy that did not end in a live birth

// Please specify the gender for [Name].
//
// 1. Male    
// 5. Female 
label define stillalive_categories 0 "No" ///
								1 "Yes"
								
gen nonliveany_women = 0 if nonliveany != . // assign 0 to all inputs 0 when nonliveany is non empty
replace nonliveany_women = 1 if (nonliveany == 1 & gender == 5)
label values nonliveany_women stillalive_categories 
label var nonliveany_women "% women with pregnancy that did not end in a live birth"

* descriptive stats of 'number of pregnancies that did not end in a live birth' 
sum nonlivehowmany
gen nonlivehowmany_women = 0 if nonlivehowmany != .
replace nonlivehowmany_women = nonlivehowmany if gender == 5
label var nonlivehowmany_women "number of pregnancies that did not end in a live birth"
sum nonlivehowmany_women

* Distribution of pregnancy outcomes in the last 12 months
sum preglastyearend
gen preglastyearend_women = 0 if preglastyearend != .
replace preglastyearend_women = preglastyearend if gender == 5
label define preglastyearend_category -666 "Other (Please Specify)" ///
										1 "Live birth" ///
										2 "Still birth (7+ months)" ///
										3 "Miscarriage" ///
										4 "Abortion"
label values preglastyearend_women preglastyearend_category
label var preglastyearend_women "pregnancy outcomes in the last 12 months"
sum preglastyearend_women

* % kids born in last 12 months who are still alive
gen stillalive_women = 0 if stillalive != .
replace stillalive_women = 1 if stillalive == 1 & gender == 5
label values stillalive_women stillalive_categories 
label var stillalive_women " % kids born in last 12 months who are still alive"

global module7_partA_var_list ///
	FPrimary hhmid age gender ///
	nonliveany_women nonlivehowmany_women preglastyearend_women stillalive_women

* to make it easier to work with it later
order $module7_partA_var_list 
keep $module7_partA_var_list 	 
save "$data_folder/cleaned/module7_partA.dta", replace

* Module 9, Part A 
use "$data_folder\raw\Wave 3\09a_youngchildhealth.dta", clear

* Note: here youngchild is defined as kids with ages between 0-5 (5 is included)
* All kids = kids age < 18?

* % kids that were taken to post-natal care

gen healthcenterlast12_youngchild = 0 if (healthcenterlast12 != . & ageyears <= 18)
replace healthcenterlast12_youngchild = 1 if (healthcenterlast12 == 1 & ageyears <= 18) // all kids
 
label define youngchild_categories 1 "Yes" ///
									0 "No"
label values healthcenterlast12_youngchild youngchild_categories
label var healthcenterlast12_youngchild "% all kids that were taken to post-natal care"

* Number of times kid go for consultation in last 12 months
gen healthcentervisits_youngchild = .
replace healthcentervisits_youngchild = healthcentervisits if ageyears <= 18 // all kids
label var healthcentervisits_youngchild "number of times all kids go for consultation in last 12 months"

* % cases had to pay for kid's consultation
gen  payconsults_youngchild = 0 if (payconsults != . & ageyears <= 18) // filter empty cells 
replace payconsults_youngchild = 1 if (payconsults == 1 & ageyears <= 18) // all kids
label values payconsults_youngchild youngchild_categories
label var payconsults_youngchild "% cases had to pay for kid's consultation"

* pay for consultations 
sum payconsultsamount
gen payconsultsamount_youngchild = .
replace payconsultsamount_youngchild = payconsultsamount if ageyears <= 18 // all kids
label var payconsultsamount_youngchild "amount paid for all kids consultations"

rename ageyears age

global module9_partA_var_list ///
	FPrimary hhmid age agemonths agetotal gender ///
	healthcenterlast12_youngchild  healthcentervisits_youngchild ///
	payconsults_youngchild payconsultsamount_youngchild

* to make it easier to work with it later
order $module9_partA_var_list 
keep $module9_partA_var_list 	 
save "$data_folder/cleaned/module9_partA.dta", replace

* Module 1, PartB2, Q4 and Q5

