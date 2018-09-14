options compress=yes;
libname outlib "/ccr/ccar_secured/rg83892/us_2017/data" access=readonly;
%let file_in = outlib.Main_data_time_series_model;

/*BT1*/
data bt1_t (keep=obsdate target lagN12_Pctyoy_US_RHPI_M lagN6_Pctyoy_US_LBR_M);
set &file_in.;
where obsdate >= '01OCT2013'D and obsdate <= '31DEC2015'D;
run;
data bt1 (drop=target);
set bt1_t;
obsdate = intnx('month',obsdate,27);
run;
data bt1;
set &file_in. bt1;
run;
proc arima data=bt1;
identify var=target crosscorr=(lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M);
estimate p=1 q=0 input=(lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M);
forecast lead=27 id=obsdate interval=month out=temp1;
run;
proc arima data=temp1;
identify var=residual stationarity=(adf=6);
run;

/*BT2*/
data bt2_t (keep=obsdate target lagN12_Pctyoy_US_RHPI_M lagN6_Pctyoy_US_LBR_M);
set &file_in.;
where obsdate >= '01JUL2008'D and obsdate <= '30SEP2010'D;
run;
data bt2 (drop=target);
set bt2_t;
obsdate = intnx('month',obsdate,90);
run;
data bt2;
set &file_in. bt2;
run;
proc arima data=bt2;
identify var=target crosscorr=(lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M);
estimate p=1 q=0 input=(lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M);
forecast lead=27 id=obsdate interval=month out=temp2;
run;
proc arima data=temp2;
identify var=residual stationarity=(adf=6);
run;