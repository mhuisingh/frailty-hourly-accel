// Examine correlates of participation in accelerometry
// (run models.do first)

version 14
clear

use tmp/analysis_file

preserve
    keep su_id frailty2 age gender bmi ethgrp jobstat_1 moca modcharlson ///
        weight_adj cluster stratum ageelig
    duplicates drop
    tempfile respondents
    save `"`respondents'"'
restore


// Predict number of days for analytic sample
drop if mi(hour)
keep if ageelig==1 & sub1==0

keep su_id day
duplicates drop
keep su_id
contract su_id, freq(days)
recode days 3/max = 3

merge 1:1 su_id using `"`respondents'"', keep(match) nogen
merge 1:1 su_id using tmp/act_level, assert(match) nogen

ologit days act_level frailty2 age i.gender bmi i.ethgrp jobstat_1 moca ///
    modcharlson


// Predict participation in accelerometry
use su_id using data/nshap_activity, clear
duplicates drop
tempfile activity
save `"`activity'"'

// Original W2 CAPI file
use SU_ID ACT_INTRO using data/nshapw2_main_results
ren *, lower
gen byte subgrp = (act_intro!=-5)

keep su_id subgrp
merge 1:1 su_id using `"`respondents'"', keep(master match) nogen
merge 1:1 su_id using `"`activity'"', assert(master match)
gen act = (_merge==3)
drop _merge

svyset cluster [pw=weight_adj], strata(stratum)
svy, subpop(if subgrp==1 & ageelig==1): logit act frailty2 age i.gender bmi ///
    i.ethgrp i.jobstat_1 moca modcharlson
