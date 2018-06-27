libname rg "/ccr/ccar_secured/rg83892";
options compress=yes;

/*RG.TEMP7 has 206271 observations and 109 variables*/
data rg.temp7 (drop=G_G G_O G_P G_S G_T G_W FP_LatAm FP_Med FP_ME); set rg.temp5; 
G_G = G_Goblet;	G_O = G_OversizedWineGlass;	G_P = G_PilsenerGlass;	G_S = G_Snifter;	G_T = G_Tulip;	G_W = G_WeizenGlass;
FP_LatAm = FP_LatinAmerican;	FP_Med = FP_Mediterranean;	FP_ME = FP_MiddleEastern;
FP_Barbecue_G_G = FP_Barbecue * G_G;	FP_Barbecue_G_O = FP_Barbecue * G_O;	FP_Barbecue_G_P = FP_Barbecue * G_P;	FP_Barbecue_G_S = FP_Barbecue * G_S;	FP_Barbecue_G_T = FP_Barbecue * G_T;	FP_Barbecue_G_W = FP_Barbecue * G_W;
FP_Cheese_G_G = FP_Cheese * G_G;	FP_Cheese_G_O = FP_Cheese * G_O;	FP_Cheese_G_P = FP_Cheese * G_P;	FP_Cheese_G_S = FP_Cheese * G_S;	FP_Cheese_G_T = FP_Cheese * G_T;	FP_Cheese_G_W = FP_Cheese * G_W;
FP_Chinese_G_G = FP_Chinese * G_G;	FP_Chinese_G_O = FP_Chinese * G_O;	FP_Chinese_G_P = FP_Chinese * G_P;	FP_Chinese_G_S = FP_Chinese * G_S;	FP_Chinese_G_T = FP_Chinese * G_T;	FP_Chinese_G_W = FP_Chinese * G_W;
FP_Chocolate_G_G = FP_Chocolate * G_G;	FP_Chocolate_G_O = FP_Chocolate * G_O;	FP_Chocolate_G_P = FP_Chocolate * G_P;	FP_Chocolate_G_S = FP_Chocolate * G_S;	FP_Chocolate_G_T = FP_Chocolate * G_T;	FP_Chocolate_G_W = FP_Chocolate * G_W;
FP_German_G_G = FP_German * G_G;	FP_German_G_O = FP_German * G_O;	FP_German_G_P = FP_German * G_P;	FP_German_G_S = FP_German * G_S;	FP_German_G_T = FP_German * G_T;	FP_German_G_W = FP_German * G_W;
FP_Indian_G_G = FP_Indian * G_G;	FP_Indian_G_O = FP_Indian * G_O;	FP_Indian_G_P = FP_Indian * G_P;	FP_Indian_G_S = FP_Indian * G_S;	FP_Indian_G_T = FP_Indian * G_T;	FP_Indian_G_W = FP_Indian * G_W;
FP_Italian_G_G = FP_Italian * G_G;	FP_Italian_G_O = FP_Italian * G_O;	FP_Italian_G_P = FP_Italian * G_P;	FP_Italian_G_S = FP_Italian * G_S;	FP_Italian_G_T = FP_Italian * G_T;	FP_Italian_G_W = FP_Italian * G_W;
FP_Japanese_G_G = FP_Japanese * G_G;	FP_Japanese_G_O = FP_Japanese * G_O;	FP_Japanese_G_P = FP_Japanese * G_P;	FP_Japanese_G_S = FP_Japanese * G_S;	FP_Japanese_G_T = FP_Japanese * G_T;	FP_Japanese_G_W = FP_Japanese * G_W;
FP_LatAm_G_G = FP_LatAm * G_G;	FP_LatAm_G_O = FP_LatAm * G_O;	FP_LatAm_G_P = FP_LatAm * G_P;	FP_LatAm_G_S = FP_LatAm * G_S;	FP_LatAm_G_T = FP_LatAm * G_T;	FP_LatAm_G_W = FP_LatAm * G_W;
FP_Med_G_G = FP_Med * G_G;	FP_Med_G_O = FP_Med * G_O;	FP_Med_G_P = FP_Med * G_P;	FP_Med_G_S = FP_Med * G_S;	FP_Med_G_T = FP_Med * G_T;	FP_Med_G_W = FP_Med * G_W;
FP_Med_G_G = FP_Med * G_G;	FP_Med_G_O = FP_Med * G_O;	FP_Med_G_P = FP_Med * G_P;	FP_Med_G_S = FP_Med * G_S;	FP_Med_G_T = FP_Med * G_T;	FP_Med_G_W = FP_Med * G_W;
FP_PanAsian_G_G = FP_PanAsian * G_G;	FP_PanAsian_G_O = FP_PanAsian * G_O;	FP_PanAsian_G_P = FP_PanAsian * G_P;	FP_PanAsian_G_S = FP_PanAsian * G_S;	FP_PanAsian_G_T = FP_PanAsian * G_T;	FP_PanAsian_G_W = FP_PanAsian * G_W;
run;
proc means data=rg.temp7; var _numeric_; run;
data temp; set rg.temp7; where Score_bin in (3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17);run;
proc corr data=temp noprob out=correl; var _numeric_; run;

/*RG.TEMP8 has 175338 observations and 31 variables*/
/*RG.TEMP8_TRAIN has 154710 observations and 31 variables*/
/*RG.TEMP8_TEST has 20628 observations and 31 variables*/
data rg.temp8 (keep=Score row_num Score_bin Ratings
Style	ABV_round_L	Serving_Temp_B	Company	Cellar_Temp_B	FP_Cheese_G_O	G_OversizedWineGlass	G_PilsenerGlass	FP_Cheese_G_S
G_Snifter	FP_Cheese_G_T	G_Tulip	FP_Barbecue_G_O	FP_Chocolate_G_O	FP_Chocolate_G_S	FP_Cheese_G_P	FP_Cheese	FP_Indian
FP_LatAm_G_P	FP_MiddleEastern	FP_Indian_G_P	FP_LatinAmerican	FP_Barbecue_G_P	FP_Italian	FP_Digestive	G_Mug	FP_Chocolate); 
set rg.temp7; where Score_bin in (-1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17); run;
data rg.temp8_ex (keep=Score row_num Ratings); set rg.temp7; 
where Score_bin in (1, 2) and Score^=.; run;
data rg.temp8_train; set rg.temp8 (where=(Score^=.)); run;
data rg.temp8_test; set rg.temp8 (where=(Score=.)); run;
proc means data=rg.temp8; var _numeric_; run;
proc means data=rg.temp8_train; var _numeric_; run;
proc means data=rg.temp8_test; var _numeric_; run;

/*Final model*/
/*WORK.REG_OUT has 185643 observations and 3 variables*/
proc corr data=rg.temp8_train noprob; var _numeric_; run;
proc reg data=rg.temp8_train; model Score = 
Style	ABV_round_L	Serving_Temp_B	Company	Cellar_Temp_B	FP_Cheese_G_O	G_OversizedWineGlass	G_PilsenerGlass	FP_Cheese_G_S
G_Snifter	FP_Cheese_G_T	/*G_Tulip*/	FP_Barbecue_G_O	FP_Chocolate_G_O	FP_Chocolate_G_S	FP_Cheese_G_P	FP_Cheese	FP_Indian
FP_LatAm_G_P	FP_MiddleEastern	FP_Indian_G_P	FP_LatinAmerican	FP_Barbecue_G_P	FP_Italian	FP_Digestive	G_Mug	FP_Chocolate
/vif; output out=reg_out p=yhat; run;
data reg_out (keep=Score Ratings yhat); set reg_out rg.temp8_ex; /*yhat=3.2;*/
if yhat < 2.6 then yhat = 2.3; if yhat > 5 then yhat = 5; if yhat = . then yhat = 0;
if Ratings = 0 then yhat = 0; run; 
proc sql; select sqrt(avg((Score-yhat)*(Score-yhat))) as RMSE from reg_out; quit;