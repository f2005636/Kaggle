options compress=yes;
libname outlib "/ccr/ccar_secured/rg83892/us_2017/data";
%Let outdata= outlib.Main_data_time_series_bin;
%let indata=outlib.Main_data_time_series;

proc sql;
create table temp1 as 
select obsdate,
avg(target) as avg_target,avg(curr_ltv) as avg_curr_ltv,avg(nrml_LN_AMT) as avg_nrml_LN_AMT,avg(seasoning_mths) as avg_seasoning_mths
from &indata.
group by obsdate
order by obsdate;
quit;

proc sql;
create table temp2 as
select a.*, b.*
from temp1 as a left join outlib.macro_us as b
on a.obsdate = b.obsdate;
quit;

proc contents data=&indata.;run;

/*Master Dataset*/
data &outdata.;
set temp2;
run;

/* Bins - Numeric */
%macro bin1_(inputdata,groupNumber,varName);
proc rank data=&inputdata. out=&inputdata. groups=&groupNumber;
 var &varName;
 ranks &varName._;
run;
data &inputdata.;
set &inputdata.;
if &varName._ = . then &varName._ = -1;
run;
%mend;
%bin1_(&outdata,7,avg_CURR_LTV);
%bin1_(&outdata,7,avg_nrml_LN_AMT);
%bin1_(&outdata,7,avg_seasoning_mths);

/* Bins - Econ */
%macro bin2_(inputdata,groupNumber,varName);
proc rank data=&inputdata. out=&inputdata. groups=&groupNumber;
 var &varName;
 ranks &varName._;
run;
data &inputdata.;
set &inputdata.;
if &varName._ = . then &varName._ = -1;
run;
%mend;
/*%bin2_(&outdata,7,Pctqoq_gdp_us);*/

proc contents data=&outdata.;run;
proc print data=&outdata.;run;