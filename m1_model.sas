options compress=yes;
libname outlib "/ccr/ccar_secured/rg83892/us_2017/data" access=readonly;
%let file_in = outlib.Main_data_time_series_model;

data temp1;
set &file_in.;
where obsdate >= '01JAN2006'd and obsdate <= '31DEC2015'd;
run;

/*actual model*/
proc arima data=temp1;
identify var=target crosscorr=(lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M);
estimate p=1 q=0 input=(lagN6_Pctyoy_US_LBR_M lagN12_Pctyoy_US_RHPI_M);
forecast lead=0 id=obsdate interval=month out=temp2;
run;
proc arima data=temp2;
identify var=residual stationarity=(adf=6);
run;
