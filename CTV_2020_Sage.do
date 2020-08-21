********************************************************************************
** The Regression Discontinuity Design -- Re-analysis of Klasnja Titiunik (2017)
** Authors: Matias D. Cattaneo, Rocio Titiunik and Gonzalo Vazquez-Bare
** Last update: 21-AGO-2020
********************************************************************************
** SOFTWARE WEBSITE: https://rdpackages.github.io/
********************************************************************************
** TO INSTALL STATA PACKAGES:
** RDROBUST: net install rdrobust, from(https://raw.githubusercontent.com/rdpackages/rdrobust/master/stata) replace
** RDDENSITY: net install rdlocrand, from(https://raw.githubusercontent.com/rdpackages/rdlocrand/master/stata) replace
** RDLOCRAND: net install rddensity, from(https://raw.githubusercontent.com/rdpackages/rddensity/master/stata) replace
********************************************************************************
* Score:   mv_incparty (margin of victory of incumbent party at t)
* Outcome: indicator for victory of incumbent party at t+1 
* Cutoff:  0
********************************************************************************
** NOTE: If you are using RDROBUST version 2020 or newer, the option 
** "masspoints(off) stdvars(on)" may be needed to replicate the results in the 
** paper. For example, line 79:
**
**     rdrobust $y $x
**
** should be replaced by:
**
**     rdrobust $y $x, masspoints(off) stdvars(on)
********************************************************************************
** NOTE: If you are using RDDENSITY version 2020 or newer, the option 
** "nomasspoints" may be needed to replicate the results in the 
** paper. For example, line 55:
**
**     rddensity $x, plot
**
** should be replaced by:
**
**     rddensity $x, nomasspoints plot
********************************************************************************

********************************************************************************
** Load Data
********************************************************************************

use "CTV_2020_Sage.dta", clear

global y mv_incpartyfor1 
global x mv_incparty
global covs "pibpc population numpar_candidates_eff party_DEM_wonlag1_b1 party_PSDB_wonlag1_b1 party_PT_wonlag1_b1 party_PMDB_wonlag1_b1"


********************************************************************************
** Falsification analysis
********************************************************************************

* Density discontinuity test

rddensity $x, plot

* Placebo tests on pre-determined covariates

foreach var of global covs {
	rdrobust `var' $x
	qui rdplot `var' $x if abs($x)<=30, graph_options(graphregion(color(white)) ///
													  xlabel(-30(10)30) ///
													  ytitle(`var'))
}


********************************************************************************
* Outcome analysis 
********************************************************************************

* RD plot 

rdplot $y $x, graph_options(graphregion(color(white)) ///
							xtitle(Margin of Victory at t) ///
							ytitle(Margin of Victory at t+1)) 

* Continuity based approach  

rdrobust $y $x 

* with covariates

rdrobust $y $x, covs($covs) 


* Local randomization approach 

* Window selector: uncomment to run. Can take a long time.

*rdwinselect $x $covs, wmin(0.05) wstep(0.01) nwindows(200) seed(765) plot graph_options(xtitle(Half window length) ytitle(Minimum p-value across all covariates) graphregion(color(white)))

* Randomization inference

local  w =  0.15
rdrandinf $y $x, wl(-`w') wr(`w') reps(1000) seed(765)



