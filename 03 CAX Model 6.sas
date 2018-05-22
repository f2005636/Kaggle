options compress=yes;
libname rg '/ccr/ccar_secured/rg83892/in2016ye';

data temp; set rg.CAX_Startup_Data; run;

proc varclus data=temp minclusters=2;
var Age_company_bin -- Renown_score_bin;
run;

proc factor data=temp nfact=13 out=temp_factor;
var Age_company_bin -- Renown_score_bin;
run;

proc sort data=temp_factor; by Company_Name; run;

data temp_factor (rename=(Status = Y));
set temp_factor (drop=Age_company_bin -- Renown_score_bin);
run;

data rg.CAX_Startup_Data;
set temp_factor (drop=X);
run;

proc logistic data=rg.CAX_Startup_Data desc;
model Y = Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8 Factor9 Factor10 Factor11 Factor12 Factor13;
run;
