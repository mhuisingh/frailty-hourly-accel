// Build dataset for analysis

version 15
clear

// NSHAP 2.2 data release
use data/nshap-2.2/w2/nshap_w2_core
run derived_vars
keep su_id frailty2 age gender bmi ethgrp jobstat_1 moca modcharlson ageelig ///
    weight_adj cluster frailty_cat_4pt height weight stratum
tempfile core
save `"`core'"'

// W2 hourly activity dataset
use data/activity_hrs if n_cpm==60
drop if mean_cpm==0  // ignore these since only 2/25,746
drop if !dow(date)   // drop Sundays
gen mean_cpm_log = log10(mean_cpm)
gen day = dow(date)
lab def dow 0 "Sunday" 1 "Monday" 2 "Tuesday" 3 "Wednesday" 4 "Thursday" ///
    5 "Friday" 6 "Saturday"
lab val day dow
gen month_int = month(date)
keep su_id date hour mean_cpm_log n_cpm day month_int

merge m:1 su_id using `"`core'"', assert(match using) nogen

loc xvars age gender ethgrp frailty2 hour mean_cpm n_cpm weight height ///
    jobstat_1 moca modcharlson month_int day
egen sub1 = rowmiss(`xvars')

compress
isid su_id date hour, so missok
datasig confirm using data/analysis_file, strict

cap mkdir tmp
save tmp/analysis_file, replace


// Verify against Megan's original file
// ds
// loc varlist `r(varlist)'
// preserve
//      use `r(varlist)' using "data/activity_hrs_core_W1wt_Megan mini 7.25.16.dta", clear
//      drop if mi(mean_cpm_log)
//      isid su_id date hour, so missok
//      tempfile megan
//      save `"`megan'"'
// restore
//
// drop if mi(mean_cpm_log)
// cf _all using `"`megan'"', all
