// Plot spline fits (run splines.do first)

version 15
clear all
set scheme s1mono

use tmp/spline_fits
format %3.1f p_*
lab var hour "Hour of day"
lab var p_overall "Overall sample"
lab var p_f0 "Non-frail"
lab var p_f1 "Pre-frail"
lab var p_f2 "Frail"
lab var p_a1 "Age 62-70"
lab var p_a2 "Age 71-80"
lab var p_a3 "Age >80"
lab var p_male "Men"
lab var p_female "Women"

line p_overall hour, sort name(g1) ///
    lpattern(solid dash dash_dot) ylab(, angle(horizontal)) ///
    xlab(7(2)21) xtick(8(2)22) ytitle("Log10 mean CPM") plotregion(style(none)) ///
    title("A", position(11)) ///
    ytick(1.9(0.2)2.3) xscale(range(7 22)) ylab(1.8(0.2)2.4) legend(on pos(7) ring(0) region(lstyle(none)))

line p_f0 p_f1 p_f2 hour, sort name(g2) legend(cols(1) ring(0) pos(7) region(lstyle(none))) ///
    lpattern(solid dash dash_dot) ylab(, angle(horizontal)) ///
    xlab(7(2)21) xtick(8(2)22) ytitle("Log10 mean CPM") plotregion(style(none)) ///
    title("B", position(11)) ///
    ytick(1.9(0.2)2.3) xscale(range(7 22)) ylab(1.8(0.2)2.4)

line p_a* hour, sort name(g3) legend(cols(1) ring(0) pos(7) region(lstyle(none))) ///
    lpattern(solid dash dash_dot) ylab(, angle(horizontal)) ///
    xlab(7(2)21) xtick(8(2)22) ytitle("Log10 mean CPM") plotregion(style(none)) ///
    title("C", position(11)) ///
    ytick(1.9(0.2)2.3) xscale(range(7 22)) ylab(1.8(0.2)2.4)

line p_male p_female hour, sort name(g4) legend(cols(1) ring(0) pos(7) region(lstyle(none))) ///
    lpattern(solid dash dash_dot) ylab(, angle(horizontal)) ///
    xlab(7(2)21) xtick(8(2)22) ytitle("Log10 mean CPM") plotregion(style(none)) ///
    title("D", position(11)) ///
    ytick(1.9(0.2)2.3) xscale(range(7 22)) ylab(1.8(0.2)2.4)

gr combine g1 g2 g3 g4, iscale(*0.75)
gr export tmp/splines.eps, replace
gr export tmp/splines.pdf, replace
gr export tmp/splines.tif, width(1800) replace
