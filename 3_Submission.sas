libname rg "/ccr/ccar_secured/rg83892";
options compress=yes;

/*Model 1*/
/*RG.TEMP9_MODEL1 has 1480 observations and 1 variables*/
data reg_out (keep=yhat row_num); set rg.temp2 (where=(price=.)); 
yhat = (-58.03484) + (-7.88948*area_type_bua) + (46.79158*area_type_pa) + (-27.20454*size_1) + (-12.8409*size_2) + (0.30701*bath_bin) + (0.99937*total_sqft_bin);
run;
proc sort data=reg_out; by row_num; run;
data rg.temp9_model1 (rename=(yhat=price)); set reg_out (keep=yhat); run;
proc export data=rg.temp9_model1 dbms=csv
outfile="/ccr/ccar_secured/rg83892/temp9_model1.csv"; run;

/*Model 2*/
/*RG.TEMP9_MODEL2 has 1480 observations and 1 variables*/
data reg_out (keep=yhat row_num); set rg.temp4 (where=(price=.)); 
yhat = (-52.48529) + (-8.32493*area_type_bua) + (44.76993*area_type_pa) + (-26.62781*size_1) + (-13.10918*size_2) + (0.2994*bath_bin) + (1.00006*total_sqft_bin) + 
(-11.52194*location_Whitefield) + (-18.68864*location_Sarjapur) + (-8.32977*location_JPNagar) + (-20.73862*location_Electronic) + (-17.18588*location_Kanakapura) + (-8.48824*location_Thanisandra) + (-22.99743*location_Yelahanka) + (-22.51476*location_Uttarahalli) + (9.63888*location_Hebbal) + (-22.48519*location_RajaRaj) + (-13.14152*location_Marathahalli) + (-7.46878*location_Hennur) + (-8.85264*location_Bannerghatta) + (-5.77079*location_HaralurRoad);
run;
proc sort data=reg_out; by row_num; run;
data rg.temp9_model2 (rename=(yhat=price)); set reg_out (keep=yhat); run;
proc export data=rg.temp9_model2 dbms=csv
outfile="/ccr/ccar_secured/rg83892/temp9_model2.csv"; run;

/*Model 3*/
/*RG.TEMP9_MODEL3 has 1480 observations and 1 variables*/
data reg_out (keep=yhat row_num Ratings); set rg.temp4 (where=(price=.)); 
yhat = (-91.56666) + (-5.50142*area_type_bua) + (43.00096*area_type_pa) + (-21.18829*size_1) + (-10.28076*size_2) + (0.217*bath_bin) + (0.79363*total_sqft_bin) + (0.62771*location_bin); 
run;
proc sort data=reg_out; by row_num; run;
data rg.temp9_model3 (rename=(yhat=price)); set reg_out (keep=yhat); run;
proc export data=rg.temp9_model3 dbms=csv
outfile="/ccr/ccar_secured/rg83892/temp9_model3.csv"; run;

/*correlation*/
data temp9_model1 (rename=(price=model1)); set rg.temp9_model1; row_num = _n_; run;
data temp9_model2 (rename=(price=model2)); set rg.temp9_model2; row_num = _n_; run;
data temp9_model3 (rename=(price=model3)); set rg.temp9_model3; row_num = _n_; run;
data temp (drop=row_num); merge temp9_model1 temp9_model2 temp9_model3; by row_num; run;
proc corr data=temp noprob; var _numeric_; run;