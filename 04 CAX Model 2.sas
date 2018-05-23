options compress=yes;
libname rg '/ccr/ccar_secured/rg83892/in2016ye';

/*PCA*/
data temp; set rg.CAX_Startup_Data; run;

proc varclus data=temp minclusters=2;
var Company_investor_count_seed -- Company_Founder_Patent_bin;
run;

proc factor data=temp nfact=16 out=temp_factor;
var Company_investor_count_seed -- Company_Founder_Patent_bin;
run;

data temp_factor (rename=(Dependent = Y));
set temp_factor (drop=Company_investor_count_seed -- Company_Founder_Patent_bin);
run;

/*Model*/
proc logistic data=temp_factor (where=(flag = "TRAIN")) desc outmodel=estimates;
model Y = Factor1 Factor2 Factor3 Factor4 Factor5 Factor6 Factor7 Factor8 
Factor9 Factor10 Factor11 Factor12 Factor13 Factor14 Factor15 Factor16;
run;

proc logistic inmodel = estimates;
score data = temp_factor (where=(flag = "TEST")) out= scored_data (rename=(p_1 = prob));
run;

data temp; set scored_data (keep=I_Y CAX_ID); run;

proc sql;
create table temp as 
select a.CAX_ID, b.I_Y as Dependent, a.row_num
from rg.CAX_Startup_Sub as a left join temp as b 
on a.CAX_ID = b.CAX_ID
order by row_num;
quit;