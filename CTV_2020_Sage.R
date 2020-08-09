################################################################################
## The Regression Discontinuity Design -- Re-analysis of Klasnja-Titiunik (2017)
## Authors: Matias Cattaneo, Rocio Titiunik, Gonzalo Vazquez-Bare
## Last update: 04-AGO-2020
################################################################################
## SOFTWARE WEBSITE: https://sites.google.com/site/rdpackages/
################################################################################
## TO INSTALL/DOWNLOAD R PACKAGES/FUNCTIONS:
## RDROBUST: install.packages('rdrobust')
## RDDENSITY: install.packages("rddensity",dependencies=TRUE)
## RDLOCRAND: install.packages('rdlocrand')
################################################################################
## NOTE: if you are using RDROBUST version 2020 or newer, the option 
## masspoints="off" and stdvars="on" may be needed to replicate the results
## in the chapter.
## For example, line 75:
##    rdr = rdrobust(Y,X)
## should be replaced by:
##    rdr = rdrobust(Y,X,masspoints="off",stdvars="on")
################################################################################
## NOTE: if you are using RDDENSITY version 2020 or newer, the option 
## masspoints=FALSE may be needed to replicate the results in the chapter.
## For example, line 53:
##    rddens = rddensity(X)
## should be replaced by:
##    rddens = rddensity(X, masspoints=FALSE)
################################################################################

rm(list = ls())

library(rdrobust)
library(rddensity)
library(rdlocrand)


#################################
# Read data and define variables 
#################################

data <- read.csv("CTV_2020_Sage.csv")

Y <- data$mv_incpartyfor1
X <- data$mv_incparty

covs <- data[, c("pibpc", "population", "numpar_candidates_eff", "party_DEM_wonlag1_b1",  "party_PSDB_wonlag1_b1", "party_PT_wonlag1_b1", "party_PMDB_wonlag1_b1")]
covsnm <- c("GDP per capita", "Population", "No. Effective Parties", "DEM Victory t-1",  "PSDB Victory t-1", "PT Victory t-1", "PMDB Victory t-1")


#################################
# Falsification analysis 
#################################

rddens <- rddensity(X)
summary(rddens)
rdplotdensity(rddens, X = data$mv_incparty[!is.na(data$mv_incparty)], 
              xlab = "Incumbent Party's Margin of Victory at t", ylab = "Estimated density")

for(c in 1:ncol(covs)){
  summary(rdrobust(covs[,c],X))
  rdplot(covs[,c],X,y.label=covsnm[c],x.label="Incumbent Party's Margin of Victory",
         x.lim= c(-30,30),binselect = "qsmv")
}


#################################
# Outcome analysis 
#################################

# rdplot

rdplot(Y,X)

# Continuity-based approach

rdr <- rdrobust(Y,X)
summary(rdr)

# with covariates

rdrcovs <- rdrobust(Y,X,covs=covs)
summary(rdrcovs)

# Local randomization approach

rdwin <- rdwinselect(X,covs,wmin=0.05,wstep=0.01,nwindows=200,seed=765,plot=TRUE,quietly=TRUE)
w <- 0.15

rdrand <- rdrandinf(Y,X,wl=-w,wr=w,reps=1000,seed=765)

