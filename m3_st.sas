options compress=yes;
libname outlib "/ccr/ccar_secured/rg83892/us_2017/data" access=readonly;
%let file_in = outlib.Main_data_time_series_model;

/*ST1-B*/
data st1;
set outlib.macro_b;
where obsdate >= '01JAN2016'D and obsdate <= '31MAR2018'D;
run;
data st1 (keep=obsdate target US_RHPI_M lagN12_Pctyoy_US_RHPI_M US_LBR_M lagN6_Pctyoy_US_LBR_M);
set &file_in. st1;
run;
proc arima data=st1;
identify var=target crosscorr=(lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M);
estimate p=1 q=0 input=(lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M);
forecast lead=27 id=obsdate interval=month out=temp1;
run;
proc arima data=temp1;
identify var=residual stationarity=(adf=6);
run;

/*ST1-A*/
data st2;
set outlib.macro_a;
where obsdate >= '01JAN2016'D and obsdate <= '31MAR2018'D;
run;
data st2 (keep=obsdate target US_RHPI_M lagN12_Pctyoy_US_RHPI_M US_LBR_M lagN6_Pctyoy_US_LBR_M);
set &file_in. st2;
run;
proc arima data=st2;
identify var=target crosscorr=(lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M);
estimate p=1 q=0 input=(lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M);
forecast lead=27 id=obsdate interval=month out=temp2;
run;
proc arima data=temp2;
identify var=residual stationarity=(adf=6);
run;

/*st_unemp*/
data st_b;
set outlib.macro_b;
where obsdate >= '01JAN2016'D and obsdate <= '31MAR2018'D;
run;
data st2_a;
set outlib.macro_a;
where obsdate >= '01JAN2016'D and obsdate <= '31MAR2018'D;
run;
proc sql;
create table st_unemp as 
select a.obsdate, a.US_RHPI_M, a.lagN12_Pctyoy_US_RHPI_M, b.US_LBR_M, b.lagN6_Pctyoy_US_LBR_M
from st_b as a left join st2_a as b
on a.obsdate = b.obsdate;
quit;

data st_unemp (keep=obsdate target US_RHPI_M lagN12_Pctyoy_US_RHPI_M US_LBR_M lagN6_Pctyoy_US_LBR_M);
set &file_in. st_unemp;
run;
proc arima data=st_unemp;
identify var=target crosscorr=(lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M);
estimate p=1 q=0 input=(lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M);
forecast lead=27 id=obsdate interval=month out=temp1;
run;
proc arima data=temp1;
identify var=residual stationarity=(adf=6);
run;

/*st_hpi*/
data st_b;
set outlib.macro_b;
where obsdate >= '01JAN2016'D and obsdate <= '31MAR2018'D;
run;
data st2_a;
set outlib.macro_a;
where obsdate >= '01JAN2016'D and obsdate <= '31MAR2018'D;
run;
proc sql;
create table st_hpi as 
select a.obsdate, a.US_LBR_M, a.lagN6_Pctyoy_US_LBR_M, b.US_RHPI_M, b.lagN12_Pctyoy_US_RHPI_M
from st_b as a left join st2_a as b
on a.obsdate = b.obsdate;
quit;

data st_hpi (keep=obsdate target US_RHPI_M lagN12_Pctyoy_US_RHPI_M US_LBR_M lagN6_Pctyoy_US_LBR_M);
set &file_in. st_hpi;
run;
proc arima data=st_hpi;
identify var=target crosscorr=(lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M);
estimate p=1 q=0 input=(lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M);
forecast lead=27 id=obsdate interval=month out=temp2;
run;
proc arima data=temp2;
identify var=residual stationarity=(adf=6);
run;
