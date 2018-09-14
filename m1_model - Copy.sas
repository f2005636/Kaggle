options compress=yes;
libname outlib "/ccr/ccar_secured/rg83892/us_2017/data" access=readonly;
%let file_in = outlib.Main_data_time_series_model;

/*actual model*/
proc arima data=&file_in.;
identify var=target ;
estimate p=1 q=0 ;
forecast lead=0 id=obsdate interval=month out=pred;
run;
proc arima data=pred;
identify var=residual stationarity=(adf=6);
run;

data temp1 (keep=obsdate target prob);
set pred (rename=(FORECAST=prob));
target = exp(target) / (1+exp(target));
prob = exp(prob) / (1+exp(prob));
run;
proc sql;
create table temp2 as 
select obsdate, mean(target) as actual, mean(prob) as predicted
from temp1
group by obsdate
order by obsdate;
quit;
data temp3;
set temp2;
diff = actual - predicted;
Error_rate	= diff / actual;
abs_error = ABS(Error_rate);
run;
proc sql;
select avg(abs_error) as MAPE, avg(Error_rate) as bias
from temp3;
quit;