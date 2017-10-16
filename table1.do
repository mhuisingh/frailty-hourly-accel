// Generate results for Table 1

version 14
clear

use tmp/analysis_file

egen avg_lcpm = mean(mean_cpm_log) if inrange(hour,7,22), by(su_id)
egen avg_cpm = mean(10^mean_cpm_log) if inrange(hour,7,22), by(su_id)
egen n_lcpm = count(mean_cpm_log) if inrange(hour,7,22), by(su_id)
bys su_id (avg_lcpm): replace avg_lcpm = avg_lcpm[1]
bys su_id (avg_cpm): replace avg_cpm = avg_cpm[1]
bys su_id (n_lcpm): replace n_lcpm = n_lcpm[1]

recode age 62/70=1 71/80=2 81/max=3 else=., gen(agecat)
gen bmi_int = round(bmi)
recode bmi_int 18/24=1 25/30=2 31/max=3 else=., gen(bmicat)

keep su_id avg_lcpm avg_cpm n_lcpm frailty2 age gender bmi ethgrp jobstat_1 ///
    moca modcharlson ageelig sub1 weight_adj cluster stratum frailty_cat_4pt ///
    agecat bmicat
duplicates drop
drop if mi(ageelig)
isid su_id

gen subpop = (ageelig==1 & !sub1)

table gender if subpop
total n_lcpm if subpop, over(gender)

svy, subpop(subpop): mean age, over(gender)
svy, subpop(subpop): proportion agecat, over(gender)

svy, subpop(subpop): proportion ethgrp, over(gender)

svy, subpop(subpop): proportion jobstat_1, over(gender)

svy, subpop(subpop): mean bmi, over(gender)
svy, subpop(subpop): proportion bmicat, over(gender)

svy, subpop(subpop): mean modcharlson, over(gender)
svy, subpop(subpop): mean moca, over(gender)

svy, subpop(subpop): mean avg_cpm, over(gender)
svy, subpop(subpop): mean avg_lcpm, over(gender)

svy, subpop(subpop): proportion frailty_cat_4pt, over(gender)
svy, subpop(subpop): mean frailty2, over(gender)
