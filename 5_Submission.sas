libname rg "/ccr/ccar_secured/rg83892";
options compress=yes;

/*Model 1*/
/*RG.TEMP9_MODEL1 has 20628 observations and 1 variables*/
data reg_out (keep=yhat row_num Ratings); set rg.temp2 (where=(Score=.)); 
if Ratings = 0 then yhat = 0; else yhat = 3.72144;run;
proc sort data=reg_out; by row_num; run;
data rg.temp9_model1 (rename=(yhat=Score)); set reg_out (keep=yhat); run;
proc export data=rg.temp9_model1 dbms=csv
outfile="/ccr/ccar_secured/rg83892/temp9_model1.csv"; run;

/*Model 2*/
/*RG.TEMP9_MODEL2 has 20628 observations and 1 variables*/
data reg_out (keep=yhat row_num Ratings); set rg.temp4 (where=(Score=.)); 
yhat = (-1.37007) + (0.97689*Company) + (0.24133*ABV_round_L) + (0.07359*Ratings_round) + (-0.17946*Cellar_Temp_B) + (0.38516*Style) + (-0.03583*G_Flute) + (0.56222*G_None) + (0.05007*G_PilsenerGlass) + 
(0.02929*G_PintGlass) + (0.06366*G_WeizenGlass) + (0.1236*FP_Chinese) + (0.03358*FP_Dessert) + (-0.08072*FP_Digestive) + (0.02064*FP_German) + (-0.17698*FP_Italian) + (-0.06866*FP_Japanese) + (0.02219*FP_Meat) + 
(-0.04677*FP_Mediterranean) + (0.10304*FP_MiddleEastern) + (-0.04539*FP_None) + (-0.06691*FP_Salad) + (-0.02509*FP_Thai);
if yhat < 2.6 then yhat = 2.3; if yhat > 5 then yhat = 5; if yhat = . then yhat = 0;
if Ratings = 0 then yhat = 0; 
run;
proc sort data=reg_out; by row_num; run;
data rg.temp9_model2 (rename=(yhat=Score)); set reg_out (keep=yhat); run;
proc export data=rg.temp9_model2 dbms=csv
outfile="/ccr/ccar_secured/rg83892/temp9_model2.csv"; run;

/*Model 3*/
/*RG.TEMP9_MODEL3 has 20628 observations and 1 variables*/
data reg_out (keep=yhat row_num Ratings); set rg.temp5 (where=(Score=.)); 
yhat = (1.11456) + (0.04007*Ratings_round) + (0.00989*FP_Barbecue) + (0.03255*G_WeizenGlass) + (0.23202*ABV_round_L) + (0.15164*Company) + (0.43462*Style) + (-0.0073*FP_Cheese) + (0.0598*FP_Chinese) + (0.02685*FP_Chocolate) + 
(-0.09492*FP_Indian) + (-0.01574*FP_Italian) + (-0.01822*FP_LatinAmerican) + (-0.01842*FP_Mediterranean) + (0.04939*FP_MiddleEastern) + (0.02192*G_Goblet) + (0.01621*G_OversizedWineGlass) + (-0.04269*G_PilsenerGlass) + (-0.05398*G_Snifter);
if yhat < 2.6 then yhat = 2.3; if yhat > 5 then yhat = 5; if yhat = . then yhat = 0;
if Ratings = 0 then yhat = 0; 
run;
proc sort data=reg_out; by row_num; run;
data rg.temp9_model3 (rename=(yhat=Score)); set reg_out (keep=yhat); run;
proc export data=rg.temp9_model3 dbms=csv
outfile="/ccr/ccar_secured/rg83892/temp9_model3.csv"; run;

/*correlation*/
data temp9_model1 (rename=(Score=model1)); set rg.temp9_model1; row_num = _n_; run;
data temp9_model2 (rename=(Score=model2)); set rg.temp9_model2; row_num = _n_; run;
data temp9_model3 (rename=(Score=model3)); set rg.temp9_model3; row_num = _n_; run;
data temp (drop=row_num); merge temp9_model1 temp9_model2 temp9_model3; by row_num; run;
proc corr data=temp noprob; var _numeric_; run;