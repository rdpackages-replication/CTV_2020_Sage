################################################################################
## The Regression Discontinuity Design -- Re-analysis of Klasnja-Titiunik (2017)
## Authors: Matias Cattaneo, Rocio Titiunik, Gonzalo Vazquez-Bare
## Python code created by Ricardo Masini
## Last update: 26-JUL-2021
################################################################################
## SOFTWARE WEBSITE: https://rdpackages.github.io/
################################################################################
## TO INSTALL/DOWNLOAD PYTHON PACKAGE:
## RDROBUST: pip install rdrobust
################################################################################
## NOTE: if you are using RDROBUST version 2020 or newer, the option 
## masspoints="off" and stdvars=True may be needed to replicate the results
## in the chapter.
## For example, line 74:
##    rdr = rdrobust(Y,X) 
## should be replaced by:
##    rdr = rdrobust(Y,X,masspoints="off",stdvars=True)
################################################################################
## NOTE: if you are using RDDENSITY version 2020 or newer, the option 
## masspoints=False may be needed to replicate the results in the chapter.
## For example, line 52:
##    rddens = rddensity(X)
## should be replaced by:
##    rddens = rddensity(X, masspoints=False)
################################################################################

from rdrobust import rdrobust,rdplot
import pandas  as pd


# Load Data (.csv) from GitHub
data = pd.read_csv('CTV_2020_Sage.csv')


# Variable selection
Y = data['mv_incpartyfor1']
X = data['mv_incparty']

covs = data[["pibpc", "population", "numpar_candidates_eff", "party_DEM_wonlag1_b1",  "party_PSDB_wonlag1_b1", "party_PT_wonlag1_b1", "party_PMDB_wonlag1_b1"]]

covsnm = ["GDP per capita", "Population", "No. Effective Parties", "DEM Victory t-1",  "PSDB Victory t-1", "PT Victory t-1", "PMDB Victory t-1"]


#################################
# Falsification analysis 
#################################

#rddens <- rddensity(X)
#summary(rddens)
#rdplotdensity(rddens, X = data$mv_incparty[!is.na(data$mv_incparty)], 
#              xlab = "Incumbent Party's Margin of Victory at t", ylab = "Estimated density")

for c in range(covs.shape[1]):
    print(rdrobust(covs.iloc[:,c],X))
    rdplot(covs.iloc[:,c],
           X,
           y_label=covsnm[c],
           x_label="Incumbent Party's Margin of Victory",
           x_lim= (-30,30),
           binselect = "qsmv")


#################################
# Outcome analysis 
#################################

# rdplot

rdplot(Y,X)

# Continuity-based approach

rdr = rdrobust(Y,X)
print(rdr)

# with covariates

rdrcovs = rdrobust(Y,X,covs=covs)
print(rdrcovs)

# Local randomization approach

#rdwin <- rdwinselect(X,covs,wmin=0.05,wstep=0.01,nwindows=200,seed=765,plot=TRUE,quietly=TRUE)
#w <- 0.15

#rdrand <- rdrandinf(Y,X,wl=-w,wr=w,reps=1000,seed=765)
