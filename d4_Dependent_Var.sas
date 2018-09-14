options compress=yes;
libname outlib "/ccr/ccar_secured/rg83892/us_2017/data";
%Let outdata= outlib.Main_data_time_series_model;
%let indata=outlib.Main_data_time_series_bin;

data temp1;
set &indata.;
where obsdate > '31DEC2005'd and obsdate < '01JAN2016'd;
target = log(avg_target/(1-avg_target));

if month(obsdate) = 1 then jan_flag = 1; else jan_flag = 0;
if month(obsdate) = 2 then feb_flag = 1; else feb_flag = 0;
if month(obsdate) = 3 then mar_flag = 1; else mar_flag = 0;
if month(obsdate) = 4 then apr_flag = 1; else apr_flag = 0;
if month(obsdate) = 5 then may_flag = 1; else may_flag = 0;
if month(obsdate) = 6 then jun_flag = 1; else jun_flag = 0;
if month(obsdate) = 7 then jul_flag = 1; else jul_flag = 0;
if month(obsdate) = 8 then aug_flag = 1; else aug_flag = 0;
if month(obsdate) = 9 then sep_flag = 1; else sep_flag = 0;
if month(obsdate) = 10 then oct_flag = 1; else oct_flag = 0;
if month(obsdate) = 11 then nov_flag = 1; else nov_flag = 0;
if month(obsdate) = 12 then dec_flag = 1; else dec_flag = 0;
run;


proc arima data=temp1;
identify var=target stationarity=(adf=6);
run;

/*actual model*/
proc arima data=temp1;
identify var=target;
estimate p=1 q=0;
forecast lead=0 id=obsdate interval=month out=temp2;
run;
proc arima data=temp2;
identify var=residual stationarity=(adf=6);
run;

/*output*/
proc sort data=temp1; by obsdate;run;
data temp2;
set temp1;
LagN1_target = lag(target);
run;
data &outdata.;
set temp2;
LagN2_target = lag(LagN1_target);
run;
proc corr data=&outdata.;
var LagN2_target LagN1_target target;
run;