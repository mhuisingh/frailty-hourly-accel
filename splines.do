// Use penalized splines to model hourly changes within day

version 15
clear
set more off

use tmp/analysis_file if ageelig==1 & inrange(hour,7,22) & !mi(mean_cpm_log)

recode age 62/70=1 71/80=2 81/max=3, gen(agecat)
replace age = age / 10

gen _hour = hour - 6

loc i 1
forvalues k = 1(1)15 {
    gen hr_`i++' = cond(_hour - `k' > 0, _hour - `k', 0)
}


// Overall sample
mixed mean_cpm_log age i.gender frailty2 bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day _hour ///
    || _all: hr_*, noconstant cov(identity) || su_id: || day:, stddev

margins, at(_hour=(0))
mat t = r(table)
gen double p_overall = t[1,1] + _hour*_b[_hour]
predict p* if e(sample), reffects relevel(_all)
forv i = 1/15 {
    replace p_overall = p_overall + hr_`i'*p`i'
}
drop p1-p15


// frailty_cat_4pt == 0
mixed mean_cpm_log age i.gender bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day _hour if !frailty_cat_4pt ///
    || _all: hr_*, noconstant cov(identity) || su_id: || day:, stddev

margins, at(_hour=(0))
mat t = r(table)
gen double p_f0 = t[1,1] + _hour*_b[_hour]
predict p* if e(sample), reffects relevel(_all)
forv i = 1/15 {
    replace p_f0 = p_f0 + hr_`i'*p`i'
}
drop p1-p15

// frailty_cat_4pt == 1
mixed mean_cpm_log age i.gender bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day _hour if frailty_cat_4pt==1 ///
    || _all: hr_*, noconstant cov(identity) || su_id: || day:, stddev

margins, at(_hour=(0))
mat t = r(table)
gen double p_f1 = t[1,1] + _hour*_b[_hour]
predict p* if e(sample), reffects relevel(_all)
forv i = 1/15 {
    replace p_f1 = p_f1 + hr_`i'*p`i'
}
drop p1-p15

// frailty_cat_4pt == 2
mixed mean_cpm_log age i.gender bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day _hour if frailty_cat_4pt==2 ///
    || _all: hr_*, noconstant cov(identity) || su_id: || day:, stddev

margins, at(_hour=(0))
mat t = r(table)
gen double p_f2 = t[1,1] + _hour*_b[_hour]
predict p* if e(sample), reffects relevel(_all)
forv i = 1/15 {
    replace p_f2 = p_f2 + hr_`i'*p`i'
}
drop p1-p15


// agecat == 1
mixed mean_cpm_log age i.gender frailty2 bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day _hour if agecat==1 ///
    || _all: hr_*, noconstant cov(identity) || su_id: || day:, stddev

margins, at(_hour=(0))
mat t = r(table)
gen double p_a1 = t[1,1] + _hour*_b[_hour]
predict p* if e(sample), reffects relevel(_all)
forv i = 1/15 {
    replace p_a1 = p_a1 + hr_`i'*p`i'
}
drop p1-p15

// agecat == 2
mixed mean_cpm_log age i.gender frailty2 bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day _hour if agecat==2 ///
    || _all: hr_*, noconstant cov(identity) || su_id: || day:, stddev

margins, at(_hour=(0))
mat t = r(table)
gen double p_a2 = t[1,1] + _hour*_b[_hour]
predict p* if e(sample), reffects relevel(_all)
forv i = 1/15 {
    replace p_a2 = p_a2 + hr_`i'*p`i'
}
drop p1-p15

// agecat == 3
mixed mean_cpm_log age i.gender frailty2 bmi i.ethgrp i.jobstat_1 moca ///
    modcharlson i.month_int i.day _hour if agecat==3 ///
    || _all: hr_*, noconstant cov(identity) || su_id: || day:, stddev

margins, at(_hour=(0))
mat t = r(table)
gen double p_a3 = t[1,1] + _hour*_b[_hour]
predict p* if e(sample), reffects relevel(_all)
forv i = 1/15 {
    replace p_a3 = p_a3 + hr_`i'*p`i'
}
drop p1-p15


// gender==1 (male)
mixed mean_cpm_log age frailty2 bmi i.ethgrp i.jobstat_1 moca modcharlson ///
    i.month_int i.day _hour if gender==1 ///
    || _all: hr_*, noconstant cov(identity) || su_id: || day:, stddev

margins, at(_hour=(0))
mat t = r(table)
gen double p_male = t[1,1] + _hour*_b[_hour]
predict p* if e(sample), reffects relevel(_all)
forv i = 1/15 {
    replace p_male = p_male + hr_`i'*p`i'
}
drop p1-p15

// gender==2 (female)
mixed mean_cpm_log age frailty2 bmi i.ethgrp i.jobstat_1 moca modcharlson ///
    i.month_int i.day _hour if gender==2 ///
    || _all: hr_*, noconstant cov(identity) || su_id: || day:, stddev

margins, at(_hour=(0))
mat t = r(table)
gen double p_female = t[1,1] + _hour*_b[_hour]
predict p* if e(sample), reffects relevel(_all)
forv i = 1/15 {
    replace p_female = p_female + hr_`i'*p`i'
}
drop p1-p15


keep hour p_*
duplicates drop
drop if mi(p_overall)

isid hour p_*, so missok
cap mkdir tmp
save tmp/spline_fits, replace
