// Tests of interaction terms

version 15
clear
set more off

use tmp/analysis_file if ageelig==1 & inrange(hour,7,22) & !mi(mean_cpm_log)

recode age 62/70=1 71/80=2 81/max=3, gen(agecat)
replace age = age / 10

recode hour 7/11=1 12/16=2 17/22=3, gen(tod)
gen _hour = hour - 6

loc i 1
forvalues k = 1(1)15 {
    gen hr_`i++' = cond(_hour - `k' > 0, _hour - `k', 0)
}


// Interactions by frailty group
mixed mean_cpm_log c.age##i.frailty_cat_4pt ///
    i.gender##i.frailty_cat_4pt ///
    c.bmi##i.frailty_cat_4pt ///
    i.ethgrp##i.frailty_cat_4pt ///
    i.jobstat_1##i.frailty_cat_4pt ///
    c.moca##i.frailty_cat_4pt ///
    c.modcharlson##i.frailty_cat_4pt ///
    i.month_int##i.frailty_cat_4pt ///
    i.day##i.frailty_cat_4pt ///
    i.hour##i.frailty_cat_4pt ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)
testparm frailty_cat_4pt#c.age
testparm frailty_cat_4pt#gender
testparm frailty_cat_4pt#c.bmi
testparm frailty_cat_4pt#c.moca
testparm frailty_cat_4pt#c.modcharlson


// Interactions by age category
mixed mean_cpm_log c.age##i.agecat ///
    i.gender##i.agecat ///
    c.frailty2##i.agecat ///
    c.bmi##i.agecat ///
    i.ethgrp##i.agecat ///
    i.jobstat_1##i.agecat ///
    c.moca##i.agecat ///
    c.modcharlson##i.agecat ///
    i.month_int##i.agecat ///
    i.day##i.agecat ///
    i.hour##i.agecat ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)
testparm agecat#c.age
testparm agecat#gender
testparm agecat#c.frailty2
testparm agecat#c.bmi
testparm agecat#c.moca
testparm agecat#c.modcharlson


// Interactions by gender
mixed mean_cpm_log c.age##i.gender ///
    c.frailty2##i.gender ///
    c.bmi##i.gender ///
    i.ethgrp##i.gender ///
    i.jobstat_1##i.gender ///
    c.moca##i.gender ///
    c.modcharlson##i.gender ///
    i.month_int##I.gender ///
    i.day##i.gender ///
    i.hour##i.gender ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)
testparm gender#c.age
testparm gender#c.frailty2
testparm gender#c.bmi
testparm gender#c.moca
testparm gender#c.modcharlson


// Interactions by time of day
mixed mean_cpm_log c.age##i.tod ///
    i.gender##i.tod ///
    c.frailty2##i.tod ///
    c.bmi##i.tod ///
    i.ethgrp##i.tod ///
    i.jobstat_1##i.tod ///
    c.moca##i.tod ///
    c.modcharlson##i.tod ///
    i.month_int##i.tod ///
    i.day##i.tod ///
    i.hour##i.tod ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)
testparm tod#c.age
testparm tod#gender
testparm tod#c.frailty2
testparm tod#c.bmi
testparm tod#c.moca
testparm tod#c.modcharlson
