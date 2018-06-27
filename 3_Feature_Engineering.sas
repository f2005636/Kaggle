libname rg "/ccr/ccar_secured/rg83892";
options compress=yes;

/*RG.TEMP5 has 206271 observations and 41 variables*/
data rg.temp5; set rg.temp4; run;
proc rank data=rg.temp5 out=rg.temp5 groups=18; var Score; ranks Score_bin; run;
data rg.temp5; set rg.temp5; if Score_bin = . then Score_bin = -1; run;
proc contents data=rg.temp5; run;

proc sql; create table temp as 
select Score_bin, avg(Score) as Score, avg(ABV_round_L) as ABV_round_L, avg(Cellar_Temp_B) as Cellar_Temp_B, avg(Company) as Company, avg(Rating_flag) as Rating_flag, avg(Ratings_round) as Ratings_round, avg(Serving_Temp_B) as Serving_Temp_B, avg(Style) as Style, 
avg(FP_Aperitif) as FP_Aperitif, avg(FP_Barbecue) as FP_Barbecue, avg(FP_Cheese) as FP_Cheese, avg(FP_Chinese) as FP_Chinese, avg(FP_Chocolate) as FP_Chocolate, avg(FP_Curried) as FP_Curried, avg(FP_Dessert) as FP_Dessert, avg(FP_Digestive) as FP_Digestive, avg(FP_General) as FP_General, avg(FP_German) as FP_German, avg(FP_Indian) as FP_Indian, avg(FP_Italian) as FP_Italian, avg(FP_Japanese) as FP_Japanese, avg(FP_LatinAmerican) as FP_LatinAmerican, avg(FP_Meat) as FP_Meat, avg(FP_Mediterranean) as FP_Mediterranean, avg(FP_MiddleEastern) as FP_MiddleEastern, avg(FP_None) as FP_None, avg(FP_PanAsian) as FP_PanAsian, avg(FP_Salad) as FP_Salad, avg(FP_Thai) as FP_Thai, 
avg(G_Flute) as G_Flute, avg(G_Goblet) as G_Goblet, avg(G_Mug) as G_Mug, avg(G_None) as G_None, avg(G_OversizedWineGlass) as G_OversizedWineGlass, avg(G_PilsenerGlass) as G_PilsenerGlass, avg(G_PintGlass) as G_PintGlass, avg(G_Snifter) as G_Snifter, avg(G_Stange) as G_Stange, avg(G_Tulip) as G_Tulip, avg(G_WeizenGlass) as G_WeizenGlass
from rg.temp5 group by Score_bin; quit; 
proc sql; select Score_bin, avg(Score) as Score, min(Score) as min, max(Score) as max, count(Score) as cnt
from rg.temp5 group by Score_bin; quit;

/*RG.TEMP6 has 175338 observations and 28 variables*/
/*RG.TEMP6_TRAIN has 154710 observations and 28 variables*/
/*RG.TEMP6_TEST has 20628 observations and 28 variables*/
data rg.temp6 (keep=Score Score_bin row_num Ratings Rating_flag Ratings_round FP_Barbecue FP_German G_WeizenGlass 
ABV_round_L Cellar_Temp_B Company Serving_Temp_B Style FP_Cheese FP_Chinese FP_Chocolate FP_Indian FP_Italian FP_Japanese FP_LatinAmerican FP_Mediterranean FP_MiddleEastern FP_PanAsian G_Goblet G_OversizedWineGlass G_PilsenerGlass G_Snifter G_Tulip); 
set rg.temp5; where Score_bin in (-1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17); run;
data rg.temp6_ex (keep=Score row_num Ratings); set rg.temp5; 
where Score_bin in (1, 2) and Score^=.; run;
data rg.temp6_train; set rg.temp6 (where=(Score^=.)); run;
data rg.temp6_test; set rg.temp6 (where=(Score=.)); run;
proc means data=rg.temp6; var _numeric_; run;
proc means data=rg.temp6_train; var _numeric_; run;
proc means data=rg.temp6_test; var _numeric_; run;

/*Final model*/
/*WORK.REG_OUT has 185643 observations and 3 variables*/
proc corr data=rg.temp6_train noprob; var _numeric_; run;
proc reg data=rg.temp6_train; model Score = /*Rating_flag*/ Ratings_round FP_Barbecue /*FP_German*/ G_WeizenGlass 
ABV_round_L /*Cellar_Temp_B*/ Company /*Serving_Temp_B*/ Style FP_Cheese FP_Chinese FP_Chocolate FP_Indian FP_Italian /*FP_Japanese*/ FP_LatinAmerican FP_Mediterranean FP_MiddleEastern /*FP_PanAsian*/ G_Goblet G_OversizedWineGlass G_PilsenerGlass G_Snifter /*G_Tulip*/
/ vif; output out=reg_out p=yhat; run;
data reg_out (keep=Score Ratings yhat); set reg_out rg.temp6_ex; /*yhat=3.2;*/
if yhat < 2.6 then yhat = 2.3; if yhat > 5 then yhat = 5; if yhat = . then yhat = 0;
if Ratings = 0 then yhat = 0; run; 
proc sql; select sqrt(avg((Score-yhat)*(Score-yhat))) as RMSE from reg_out; quit;