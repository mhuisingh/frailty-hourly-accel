// Adapted from "Wave 2 New Variables for Hourly Activity Paper 8.25.17.do"

* Wave 2 New Variables

generate wave = 2
generate weight2 = weight
generate physhlth2 = physhlth
generate mntlhlth2 = mntlhlth

*AGE
tabstat age, stat(mean)
gen age_decade = age/10

 
*CHARLSON COMORBIDITY INDEX
*HEART CONDITIONS
//gen htn=0
//replace htn=1 if conditns_6==1
//gen hrtprob3=0
//replace hrtprob3=1 if hrtprob2==1
gen hrtattack2=0
//replace hrtattack2=2 if hrtattack==1
replace hrtattack2=1 if hrtattack==1  
gen hrtchf2=0
replace hrtchf2=1 if hrtchf==1
gen hrtcard2=0
replace hrtcard2=1 if hrtcard==1
gen stroke2 = 0
replace stroke2 = 1 if stroke==1
*CANCER
//gen melanoma = (typeskican==2)
gen cancer = 0
replace cancer=1 if othcan==1 & spread_1!=1 & spread_2!=1
gen metastasis = 0
replace metastasis = 1 if spread_1==1 | spread_2==1
*ENDOCRINE
gen diabetes=0
replace diabetes=1 if conditns_7==1
*BONE HEALTH
//gen arthritis2 = 0
//replace arthritis2= 1 if arthritis==1
gen rheum = (osteo_rheu==2 | osteo_rheu==3)
//gen osteoarth = (osteo_rheu==1 | osteo_rheu==3)
//gen osteop2 = 0
//replace osteop2 = 1 if osteop==1
//gen hipfrac2 = 0
//replace hipfrac2 = 1 if hipfrac==1
//gen bonehlth = 0
//replace bonehlth = 1 if osteop2==1 | osteoarth==1 | hipfrac2==1
*RESPIRATORY
gen emphasth2= 0
replace emphasth2=1 if emphasth==1
*NEUROLOGY
gen dementia2=0
replace dementia2=1 if dementia==1
gen alzheimer2=0
replace alzheimer2=1 if alzheimer==1
gen alzdem = 0
replace alzdem=1 if alzheimer==1 | dementia==1
//gen parkinson2 = 0
//replace parkinson2 = 1 if parkinson==1
*INCONTINENCE
//gen incont = (urinepr==1 | stoolinc==1 | othurine==1)
//gen incont2 = 0 if urinepr==0 | stoolinc==0 | othurine==0
//replace incont2 = 1 if urinepr==1 | stoolinc==1 | othurine==1
*MODIFIED CHARLSON SCALE
gen modcharlson = hrtattack2 + hrtcard2 + hrtchf2 + stroke2 + 2*cancer + 6*metastasis + rheum + diabetes + emphasth2 + alzdem
*TRUNCATED MODIFIED CHARLSON SCALE
//recode modcharlson 4/12=4, gen(modcharlson2)

*BODY MASS INDEX
generate bmi = .
replace bmi = (weight/ (height*height))*703 if weight > 0 & height > 10

************************************************************************************
*MOCA-SA
//*CCFM CODE
recode ccfm_month2 0=0 1=1 .a=0 .b=0 .c=0, gen(month1)
recode ccfm_date2 0=0 1=1 .a=0 .b=0 .c=0, gen(date1)
recode ccfm_rhino 2=0 1=1 .a=0 .b=0 .c=0, gen(rhino1)
recode ccfm_contour 0=0 1=1 .c=0 .d=0 .f=., gen(contour1) //30 missing in error
recode ccfm_numbers 0=0 1=1 .c=0 .d=0 .f=., gen(numbers1)
recode ccfm_hands 0=0 1=1 .c=0 .d=0 .f=., gen(hands1)
recode ccfm_trail2 0=0 1=1 .c=0 .d=0 .f=., gen(trail1)
recode ccfm_5numbers 2/4=0 1=1 .a=0, gen(fnumb1)
recode ccfm_3numbers 2/4=0 1=1 .a=0, gen(bnumb1)
recode ccfm_subcat 0=0 1=1 2=2 3=3 .a=0 .b=0, gen(subtract1)
recode ccfm_sentcat  2/4=0 1=1 .a=0, gen(cat1)
recode ccfm_word2 0=0 1=1 .c=0 .d=0 .f=., gen(fluency1)
recode ccfm_alike2 1=1 2=1 3=0 4=0 .a=0 .b=0, gen(abstract1)
recode ccfm_face 1=1 2=0, gen(face1)
recode ccfm_velvet 1=1 2=0, gen(velvet1)
recode ccfm_church 1=1 2=0, gen(church1)
recode ccfm_daisy 1=1 2=0, gen(daisy1)
recode ccfm_red 1=1 2=0, gen(red1)

//account for flags
gen subtract2=subtract1
replace subtract2=0 if ccfm_flag==1
gen contour2=contour1
replace contour2=0 if ccfm_flag==9
gen numbers2=numbers1
replace numbers2=0 if ccfm_flag==9
gen hands2=hands1
replace hands2=0 if ccfm_flag==9
gen fluency2=fluency1
replace fluency2=0 if ccfm_flag==10

****************************************************************************************************
//predict missing values using logistic regression for each item
logit contour2 month1 date rhino1 fnumb1 bnumb1 subtract2 cat1 abstract1 face1 velvet1 church1 daisy1 red1
replace contour2 = exp(.525949 + .5753277*month1 + .4161914*date1 + .5608853*rhino1 + .4360694*fnumb1 + .2578639*bnumb1 + ///
					   .324936*subtract2 + .1436518*cat1 + .1857653*abstract1 + .1201465*face1 +  .1240894*velvet1 + ///
					   .0207402*church1   + -.0523653*daisy1 + .0307759*red1) / [1 + exp(.525949 + .5753277*month1 + ///
					   .4161914*date1 + .5608853*rhino1 + .4360694*fnumb1 + .2578639*bnumb1 + .324936*subtract2 + ///
					   .1436518*cat1 + .1857653*abstract1 + .1201465*face1 +  .1240894*velvet1 + .0207402*church1 + ///
					   -.0523653*daisy1 + .0307759*red1)] if contour2==.
replace contour2 = round(contour2,1)

logit hands2 month1 date rhino1 fnumb1 bnumb1 subtract2 cat1 abstract1 face1 velvet1 church1 daisy1 red1
replace hands2 = exp(-3.22834 + 1.134055*month1 + .0315425*date1 + .4278491*rhino1 + .1312161*fnumb1 + .2169145*bnumb1 + ///
				       .340582*subtract2 + .2841901*cat1 + .2429024*abstract1 + .0965909*face1 + .0247494*velvet1 + ///
					   .0817137*church1 + .0869766*daisy1 + .3539536*red1) / [1 + exp(-3.22834 + 1.134055*month1 + ///
					   .0315425*date1 + .4278491*rhino1 + .1312161*fnumb1 + .2169145*bnumb1 + .340582*subtract2 + ///
					   .2841901*cat1 + .2429024*abstract1 + .0965909*face1 + .0247494*velvet1 + .0817137*church1 + ///
					   .0869766*daisy1 + .3539536*red1)] if hands2==.
replace hands2 = round(hands2,1)

logit numbers2 month1 date rhino1 fnumb1 bnumb1 subtract2 cat1 abstract1 face1 velvet1 church1 daisy1 red1
replace numbers2 = exp(-2.018175 + .8241467*month1 + .3835206*date1 + .3835206*rhino1 + .236043*fnumb1 + .1126143*bnumb1 + ///
                     .3617102*subtract2 + .1223766*cat1 + .0040991*abstract1 + .1562382*face1 + .2478547*velvet1 + ///
					 .0220878*church1 + .387135*daisy1 + .2596361*red1) / [1 + exp(-2.018175 + .8241467*month1 + ///
					 .3835206*date1 + .3835206*rhino1 + .236043*fnumb1 + .1126143*bnumb1 + .3617102*subtract2 + ///
					 .1223766*cat1 + .0040991*abstract1 + .1562382*face1 + .2478547*velvet1 + .0220878*church1 + ///
					 .387135*daisy1 + .2596361*red1)] if numbers2==.
replace numbers2 = round(numbers2,1)

logit trail1 month1 date rhino1 fnumb1 bnumb1 subtract2 cat1 abstract1 face1 velvet1 church1 daisy1 red1
replace trail1 = exp(-3.819034 + .7414838*month1 + .2164741*date1  + .7222849*rhino1 + .2175239*fnumb1 + .508872*bnumb1 + ///
				     .4375549*subtract2 + .3230039*cat1 + .3341651*abstract1 + .0983594*face1 + .2747371*velvet1 + ///
					 .1459094*church1 + .3508726*daisy1 + .3004706*red1) / [1 + exp(-3.819034 + .7414838*month1 + ///
					 .2164741*date1  + .7222849*rhino1 + .2175239*fnumb1 + .508872*bnumb1 + .4375549*subtract2 + ///
					 .3230039*cat1 + .3341651*abstract1 + .0983594*face1 + .2747371*velvet1 + .1459094*church1 + ///
					 .3508726*daisy1 + .3004706*red1)] if trail1==.
replace trail1 = round(trail1,1)
					 
logit fluency2 month1 date rhino1 fnumb1 bnumb1 subtract2 cat1 abstract1 face1 velvet1 church1 daisy1 red1
replace fluency2 = exp(-3.802969 + .1392243*month1 + .2576802*date1 + .6749219*rhino1 + .4727441*fnumb1 + .4714653*bnumb1 + ///
					   .37806*subtract2 + .362919*cat1 + .3937686*abstract1 + .1435481*face1 + .3323985*velvet1 + ///
					   .1082492*church1 + .2589324*daisy1 + .2644324*red1) / [1 + exp(-3.802969 + .1392243*month1 + ///
					   .2576802*date1 + .6749219*rhino1 + .4727441*fnumb1 + .4714653*bnumb1 + .37806*subtract2 + ///
					   .362919*cat1 + .3937686*abstract1 + .1435481*face1 + .3323985*velvet1 + .1082492*church1 + ///
					   .2589324*daisy1 + .2644324*red1)] if fluency2==.
replace fluency2 = round(fluency2,1)

//Domains with multiple items
gen orient1 = month1+date1
gen clock1 = contour2+numbers2+hands2
gen memory1 = face1 + velvet1 + church1 + daisy1 + red1
gen attent1 = fnumb1 + bnumb1 + subtract2
gen lang1 = cat1 + fluency2

//ccfm - logistic regression used for missing values
gen ccfm = month1 + date1 + rhino1 + contour2 + numbers2 + hands2 + trail1 + fnumb1 + bnumb1 + subtract2 + ///
	cat1 + fluency2 + abstract1 + face1 + velvet1 + church1 + daisy1 + red1
	
gen moca = 6.834071 + (1.144952*ccfm)  

************************************************************************************


*FRAILTY

**CHAIR STANDS / WEAKNESS
generate chair_2_numsec2 = chair_2_numsec
replace chair_2_numsec2 = . if chair_2_numsec == 1

generate chair_2_numsecsqrt = .
replace chair_2_numsecsqrt = sqrt(chair_2_numsec2)

generate logchair_2_numsec2 = .
replace logchair_2_numsec2 = log10(chair_2_numsec2)

recode chair_2_numsec2 min/11=4 12/13=3 14/16=2 17/max=1, gen(SPPBchairscore)
replace SPPBchairscore = 0 if inlist(chair_1, 2,4,5,6,7)
replace SPPBchairscore = 0 if inlist(chair_2, 3,4,5,6)
replace SPPBchairscore = 0 if chair_intro == 2

generate posweak2 = .
replace posweak2 = 1 if SPPBchairscore <=1
replace posweak2 = 0 if SPPBchairscore > 1 & SPPBchairscore != .
replace posweak2 = .c if SPPBchairscore == .c


*SLOW GAIT SPEED
generate gaitdiff = .
replace gaitdiff = walk_1_numsec - walk_2_numsec

generate fastestgait = .
replace fastestgait = walk_1_numsec if gaitdiff > 0
replace fastestgait = walk_2_numsec if gaitdiff < 0
replace fastestgait = walk_1_numsec if gaitdiff == 0
replace fastestgait = . if walk_1_numsec == 0

count if (walk_2_numsec==.c & walk_1_numsec!=.c)
egen fastestgait2=rowmax(walk_1_numsec walk_2_numsec)
list su_id walk_*_numsec if (walk_2_numsec==.c & walk_1_numsec!=.c)

recode fastestgait min/3.1=4 3.2/4.0=3 4.1/5.6=2 5.7/max=1, gen(SPPBgaitscore)
replace SPPBgaitscore = 0 if walk_1 >= 3 & walk_1 <= 6
replace SPPBgaitscore = 0 if walk_intro == 2
tab fastestgait SPPBgaitscore, miss nolab

gen SPPBgaitscoreNOZERO = .
replace SPPBgaitscoreNOZERO = 1 if SPPBgaitscore ==1
replace SPPBgaitscoreNOZERO = 2 if SPPBgaitscore ==2
replace SPPBgaitscoreNOZERO = 3 if SPPBgaitscore ==3
replace SPPBgaitscoreNOZERO = 4 if SPPBgaitscore ==4

generate slowgait2 = .
replace slowgait2 = 1 if SPPBgaitscore <= 1
replace slowgait2 = 0 if SPPBgaitscore > 1 & SPPBgaitscore != .
replace slowgait2 = .c if SPPBgaitscore == .c

**EXHAUSTION
generate posexhaust2 = .
replace posexhaust2 = 1 if flteff >=3 & flteff < .
replace posexhaust2 = 1 if notgetgo >=3 & notgetgo < .
replace posexhaust2 = 0 if flteff < 3 & notgetgo < 3 
replace posexhaust2 = .a if flteff == .a
replace posexhaust2 = .b if flteff == .b
replace posexhaust2 = .h if flteff == .h
replace posexhaust2 = .a if notgetgo == .a
replace posexhaust2 = .b if notgetgo == .b
replace posexhaust2 = .h if notgetgo == .h

**LOW PHYSICAL ACTIVITY
generate posphysact2 = .
replace posphysact2 = 1 if physact < 3
replace posphysact2 = 0 if physact >= 3 & physact < .

**4-POINT FRAILTY INDEX
generate frailty2 = .
replace frailty2 = posexhaust2 + slowgait2 + posphysact2 + posweak2

egen frailty_cat_4pt = cut(frailty2), at(0,1,3,6) icodes
