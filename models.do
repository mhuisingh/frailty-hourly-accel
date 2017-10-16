// Fit final models for paper

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


// Overall sample
mixed mean_cpm_log age i.gender frailty2 bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day i.hour ///
    || su_id: || day:, stddev

mixed mean_cpm_log age i.gender frailty2 bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day i.hour ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)

// Save for use in predicting number of days of data available
predict act_level if e(sample), reffects relevel(su_id)
preserve
    keep su_id act_level
    drop if mi(act_level)
    duplicates drop
    isid su_id, so
    cap mkdir tmp
    save tmp/act_level, replace
restore

// Test quadratic terms for continuous covariates
mixed mean_cpm_log c.age##c.age i.gender frailty2 bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day i.hour ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)

mixed mean_cpm_log age i.gender frailty2 c.bmi##c.bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day i.hour ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)

mixed mean_cpm_log age i.gender frailty2 bmi i.ethgrp i.jobstat_1 c.moca##c.moca ///
    modcharlson i.month_int i.day i.hour ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)

mixed mean_cpm_log age i.gender frailty2 bmi i.ethgrp i.jobstat_1 moca ///
    c.modcharlson##c.modcharlson i.month_int i.day i.hour ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)


// Re-estimate with one day only, to standardize amount of data per respondent
preserve
    egen nobs = count(mean_cpm_log), by(su_id day)
    gsort + su_id - nobs + day + hour
    by su_id: gen byte keepme = (day==day[1])
    keep if keepme
    mixed mean_cpm_log age i.gender frailty2 bmi i.ethgrp i.jobstat_1 moca ///
        modcharlson i.month_int i.day i.hour ///
        || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)
restore


// Refit model separately by frailty group
mixed mean_cpm_log age i.gender bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day i.hour if !frailty_cat_4pt ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)

mixed mean_cpm_log age i.gender bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day i.hour if frailty_cat_4pt==1 ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)

mixed mean_cpm_log age i.gender bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day i.hour if frailty_cat_4pt==2 ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)


// Refit model separately by age category
mixed mean_cpm_log age i.gender frailty2 bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day i.hour if agecat==1 ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)

mixed mean_cpm_log age i.gender frailty2 bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day i.hour if agecat==2 ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)

mixed mean_cpm_log age i.gender frailty2 bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day i.hour if agecat==3 ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)


// Refit model separately by gender
mixed mean_cpm_log age frailty2 bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day i.hour if gender==1 ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)

mixed mean_cpm_log age frailty2 bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day i.hour if gender==2 ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)


// Refit model separately by time of day
mixed mean_cpm_log age i.gender frailty2 bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day i.hour if tod==1 ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)

mixed mean_cpm_log age i.gender frailty2 bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day i.hour if tod==2 ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)

mixed mean_cpm_log age i.gender frailty2 bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day i.hour if tod==3 ///
    || su_id: || day:, stddev pweight(weight_adj) vce(cluster cluster)
