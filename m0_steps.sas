options compress=yes;
libname outlib "/ccr/ccar_secured/rg83892/us_2017/data" access=readonly;

proc contents data=outlib.Main_data_time_series_model;run;

%macro _arimax (d,p,q,l,v);
proc arima data=&d.;
identify var=target 
crosscorr=(&v.);
estimate p=&p. q=&q. input=(&v.);
forecast lead=&l. id=obsdate 
interval=month out=pred;
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
%mend;

%_arimax(outlib.Main_data_time_series_model,1,0,0,Pctyoy_US_LBR_M);
%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN3_Pctyoy_US_LBR_M);
%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN6_Pctyoy_US_LBR_M);
%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN9_Pctyoy_US_LBR_M);
%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN12_Pctyoy_US_LBR_M);

%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN6_Pctyoy_US_LBR_M Pctyoy_US_RHPI_M);
%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN6_Pctyoy_US_LBR_M lagN3_Pctyoy_US_RHPI_M);
%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN6_Pctyoy_US_LBR_M lagN6_Pctyoy_US_RHPI_M);
%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN6_Pctyoy_US_LBR_M lagN9_Pctyoy_US_RHPI_M);
%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M);

%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M Pctyoy_US_RGDP_Q)
%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M lagN3_Pctyoy_US_RGDP_Q)
%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M lagN6_Pctyoy_US_RGDP_Q)
%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M lagN9_Pctyoy_US_RGDP_Q)
%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M lagN12_Pctyoy_US_RGDP_Q)

%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M Pctyoy_US_CPI_M)
%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M lagN3_Pctyoy_US_CPI_M)
%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M lagN6_Pctyoy_US_CPI_M)
%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M lagN9_Pctyoy_US_CPI_M)
%_arimax(outlib.Main_data_time_series_model,1,0,0,lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M lagN12_Pctyoy_US_CPI_M)
