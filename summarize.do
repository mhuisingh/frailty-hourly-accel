// Summarize accelerometry data among analytic sample

version 14
clear

use tmp/analysis_file if ageelig==1 & sub1==0 & !mi(mean_cpm_log)

// Distribution of number of days
preserve
    keep su_id day
    duplicates drop
    keep su_id
    contract su_id
    tab _freq
restore

// Distribution by hour of day
codebook su_id
preserve
    keep su_id hour
    duplicates drop
    table hour
restore

// Proportion off-wrist hours
gen double datetime = dhms(date,hour,0,0)
isid su_id datetime, so
by su_id: gen double _start = datetime[1]
by su_id: gen double _end = datetime[_N]
keep su_id _start _end
duplicates drop
merge 1:m su_id using data/nshap_activity, assert(match using) keep(match) nogen
keep if inrange(datetime,_start,_end)
tab off_wrist_status, m
