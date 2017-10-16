This package contains the Stata code necessary to replicate the results in the
paper "Physical Activity and Frailty Among Older Adults In the U.S. Based on
Hourly Accelerometry Data," by Huisingh-Scheetz et al. The paper has been
accepted for publication in the *Journal of Gerontology: Medical Sciences*.

The analysis is based on Wave 2 data from the National Social Life, Health and
Aging Project (NSHAP), available from the [National Archive of Computerized
Data on Aging](http://www.icpsr.umich.edu/icpsrweb/NACDA/). Specifically, it
requires the following:

- `nshap-2.2` (NSHAP data release version 2.2)
- `activity_hrs.dta` (NSHAP Wave 2 hourly activity data)
- `nshap_activity.dta` (NSHAP Wave 2 raw activity counts)

Place these items into the `data` subdirectory. Then excecute the following
do-files (in order) *from the root of the project*:

1. `build_dataset.do`
2. `table1.do`
3. `summarize.do`
4. `models.do`
5. `tests.do`
6. `splines.do`
7. `plots.do`
8. `participation.do`

Note that Item (8) currently requires a data file that is not publicly
accessible.
