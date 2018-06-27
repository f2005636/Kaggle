libname rg "/ccr/ccar_secured/rg83892";
options compress=yes;

/*RG.TEMP3 has 206271 observations and 44 variables*/
data rg.temp3; set rg.temp2; run;

/*Brewing Company*/
proc sql;
create table Company as select 'Brewing Company'n, avg(Score) as Company, count(Score) as cnt
from rg.temp3 group by 'Brewing Company'n;
create table rg.temp3 as select a.*, b.Company
from rg.temp3 as a left join Company as b on a.'Brewing Company'n = b.'Brewing Company'n;
drop table Company;
quit;
data rg.temp3 (drop='Brewing Company'n); set rg.temp3;
Company = round(Company,0.1);
run;

/*Beer Name*/
proc sql;
create table Beer as select 'Beer Name'n, avg(Score) as Beer, count(Score) as cnt
from rg.temp3 group by 'Beer Name'n;
create table rg.temp3 as select a.*, b.Beer
from rg.temp3 as a left join Beer as b on a.'Beer Name'n = b.'Beer Name'n;
drop table Beer;
quit;
data rg.temp3 (drop='Beer Name'n); set rg.temp3;
Beer = round(Beer,0.1);
run;

/*ABV and Ratings*/
data rg.temp3 (drop=ABV_round); set rg.temp3;
ABV_round_L = (-0.0099*ABV_round*ABV_round) + (0.2666*ABV_round) + 1.9391;
run;
proc reg data=rg.temp3; model Score = ABV_round_L Ratings_round / vif; run;

/*Cellar Temperature and Serving Temperature*/
data rg.temp3 (drop=Cellar_Temp Serving_Temp); set rg.temp3;
if Cellar_Temp = "35-40" then Cellar_Temp_B = 2.9748;
else if Cellar_Temp = "40-45" then Cellar_Temp_B = 3.2348;
else if Cellar_Temp = "45-50" then Cellar_Temp_B = 3.4450;
else Cellar_Temp_B = .;
if Serving_Temp = "00-35" then Serving_Temp_B = 2.1895;
else if Serving_Temp = "35-40" then Serving_Temp_B = 2.5254;
else if Serving_Temp = "40-45" then Serving_Temp_B = 2.9841;
else if Serving_Temp = "45-50" then Serving_Temp_B = 3.2255;
else if Serving_Temp = "50-55" then Serving_Temp_B = 3.5312;
else Serving_Temp_B = .;
run;
proc reg data=rg.temp3; model Score = Cellar_Temp_B Serving_Temp_B / vif; run;

/*Style Name*/
proc reg data=rg.temp3; model Score = Style / vif; run;

/*Glassware Used and Food Paring*/
proc reg data=rg.temp3;
model Score = G_Flute G_Goblet G_Mug G_None G_Nonic G_OversizedWineGlass G_PilsenerGlass G_PintGlass G_Snifter G_Stange G_Tulip G_WeizenGlass 
FP_Aperitif FP_Barbecue FP_Cheese FP_Chinese FP_Chocolate FP_Curried FP_Dessert FP_Digestive FP_General FP_German FP_Indian FP_Italian FP_Japanese FP_LatinAmerican FP_Meat FP_Mediterranean FP_MiddleEastern FP_None FP_PanAsian FP_Salad FP_Thai 
/ vif; run;

/*Final Dataset*/
/*RG.TEMP4 has 206271 observations and 42 variables*/
/*RG.TEMP4_TRAIN has 185643 observations and 42 variables*/
/*RG.TEMP4_TEST has 20628 observations and 42 variables*/
data rg.temp4 (drop=beer G_Nonic); set rg.temp3; if Company = . then Company = 3.1988952; run;
data rg.temp4_train; set rg.temp4 (where=(Score^=.)); run;
data rg.temp4_test; set rg.temp4 (where=(Score=.)); run;
proc means data=rg.temp4; var _numeric_; run;
proc means data=rg.temp4_train; var _numeric_; run;
proc means data=rg.temp4_test; var _numeric_; run;

/*Final model*/
/*WORK.REG_OUT has 185643 observations and 43 variables*/
proc corr data=rg.temp4_train noprob; var _numeric_; run;
proc reg data=rg.temp4_train; model Score = Company ABV_round_L Ratings_round Cellar_Temp_B /*Serving_Temp_B*/ Style
G_Flute /*G_Goblet*/ /*G_Mug*/ G_None /*G_OversizedWineGlass*/ G_PilsenerGlass G_PintGlass /*G_Snifter*/ /*G_Stange*/ /*G_Tulip*/ G_WeizenGlass 
/*FP_Aperitif*/ /*FP_Barbecue*/ /*FP_Cheese*/ FP_Chinese /*FP_Chocolate*/ /*FP_Curried*/ FP_Dessert FP_Digestive /*FP_General*/ FP_German /*FP_Indian*/ FP_Italian FP_Japanese /*FP_LatinAmerican*/ FP_Meat FP_Mediterranean FP_MiddleEastern FP_None /*FP_PanAsian*/ FP_Salad FP_Thai 
/ vif; output out=reg_out p=yhat; run;
data reg_out (keep=Score yhat); set reg_out; /*yhat=3.2;*/ 
if Ratings = 0 then yhat = 0; run;
proc sql; select sqrt(avg((Score-yhat)*(Score-yhat))) as RMSE from reg_out; quit;
