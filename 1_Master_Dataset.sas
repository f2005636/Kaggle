libname rg "/ccr/ccar_secured/rg83892";
options compress=yes;

/*RG.TEMP1: train and test dataset */
/*RG.TEMP1 has 206271 observations and 11 variables*/
/*26090 observations where Score = 0*/
/*where Ratings = 0 there Score = 0*/
data rg.train; set WORK.'Beer Train Data Set'n; row_num=_n_; run;
data temp (keep=Ratings Score); set rg.train; where Score = 0 and Ratings = 0; run;
data rg.test (drop=Score); set WORK.'Beer Test Data Set'n; row_num=_n_; run;
data rg.temp1; set rg.train rg.test; run;

/*RG.TEMP2 has 206271 observations and 11 variables*/
data rg.temp2; set rg.temp1; run;

/*ABV and Ratings*/
data rg.temp2 (drop=ABV); set rg.temp2;
ABV_round = round(ABV,1);
if ABV_round = . then ABV_round = 4;
else if ABV_round = 0 then ABV_round = 1;
else if ABV_round > 15 then ABV_round = 8;

Ratings_round = round(Ratings/1000,1);
if Ratings_round = 0 then Rating_flag = 0; else Rating_flag = 1;
if Ratings_round >= 11 then Ratings_round = 11;
run;
proc sql; select Ratings_round, avg(Score) as Score, count(Score) as cnt
from rg.temp2 group by Ratings_round; quit;
proc sql; select Rating_flag, avg(Score) as Score, count(Score) as cnt
from rg.temp2 group by Rating_flag; quit;

/*Cellar Temperature and Serving Temperature*/
data rg.temp2 (drop='Cellar Temperature'n 'Serving Temperature'n); set rg.temp2;
Cellar_Temp = 'Cellar Temperature'n; if Cellar_Temp = "" then Cellar_Temp = "35-40";
Serving_Temp = 'Serving Temperature'n; if Serving_Temp = "" then Serving_Temp = "00-35";
run;

/*Style Name*/
proc sql;
create table style as select 'Style Name'n, avg(Score) as Style, count(Score) as cnt
from rg.temp2 group by 'Style Name'n;
create table rg.temp2 as select a.*, b.Style
from rg.temp2 as a left join style as b on a.'Style Name'n = b.'Style Name'n;
drop table style;
quit;
data rg.temp2 (drop='Style Name'n); set rg.temp2;
Style = round(Style,0.1);
run;

/*Glassware Used*/
data rg.temp2 (drop='Glassware Used'n); set rg.temp2;
if findw('Glassware Used'n, "Flute") > 0  then G_Flute = 1; else G_Flute = 0;
if findw('Glassware Used'n, "Goblet") > 0  then G_Goblet = 1; else G_Goblet = 0;
if findw('Glassware Used'n, "Mug") > 0  then G_Mug = 1; else G_Mug = 0;
if findw('Glassware Used'n, "None") > 0  then G_None = 1; else G_None = 0;
if findw('Glassware Used'n, "Nonic") > 0  then G_Nonic = 1; else G_Nonic = 0;
if findw('Glassware Used'n, "OversizedWineGlass") > 0  then G_OversizedWineGlass = 1; else G_OversizedWineGlass = 0;
if findw('Glassware Used'n, "PilsenerGlass") > 0  then G_PilsenerGlass = 1; else G_PilsenerGlass = 0;
if findw('Glassware Used'n, "PintGlass") > 0  then G_PintGlass = 1; else G_PintGlass = 0;
if findw('Glassware Used'n, "Snifter") > 0  then G_Snifter = 1; else G_Snifter = 0;
if findw('Glassware Used'n, "Stange") > 0  then G_Stange = 1; else G_Stange = 0;
if findw('Glassware Used'n, "Tulip") > 0  then G_Tulip = 1; else G_Tulip = 0;
if findw('Glassware Used'n, "WeizenGlass") > 0  then G_WeizenGlass = 1; else G_WeizenGlass = 0;
run;

/*Food Paring*/
proc sql; select 'Food Paring'n, avg(Score) as Score, count(Score) as cnt
from rg.temp2 group by 'Food Paring'n; quit;
data rg.temp2 (drop='Food Paring'n); set rg.temp2;
if findw('Food Paring'n, "Aperitif") > 0  then FP_Aperitif = 1; else FP_Aperitif = 0;
if findw('Food Paring'n, "Apritif") > 0  then FP_Aperitif = 1; else FP_Aperitif = 0;
if findw('Food Paring'n, "Barbecue") > 0  then FP_Barbecue = 1; else FP_Barbecue = 0;
if findw('Food Paring'n, "Cheese") > 0  then FP_Cheese = 1; else FP_Cheese = 0;
if findw('Food Paring'n, "Chinese") > 0  then FP_Chinese = 1; else FP_Chinese = 0;
if findw('Food Paring'n, "Chocolate") > 0  then FP_Chocolate = 1; else FP_Chocolate = 0;
if findw('Food Paring'n, "Curried") > 0  then FP_Curried = 1; else FP_Curried = 0;
if findw('Food Paring'n, "Dessert") > 0  then FP_Dessert = 1; else FP_Dessert = 0;
if findw('Food Paring'n, "Digestive") > 0  then FP_Digestive = 1; else FP_Digestive = 0;
if findw('Food Paring'n, "General") > 0  then FP_General = 1; else FP_General = 0;
if findw('Food Paring'n, "German") > 0  then FP_German = 1; else FP_German = 0;
if findw('Food Paring'n, "Indian") > 0  then FP_Indian = 1; else FP_Indian = 0;
if findw('Food Paring'n, "Italian") > 0  then FP_Italian = 1; else FP_Italian = 0;
if findw('Food Paring'n, "Japanese") > 0  then FP_Japanese = 1; else FP_Japanese = 0;
if findw('Food Paring'n, "LatinAmerican") > 0  then FP_LatinAmerican = 1; else FP_LatinAmerican = 0;
if findw('Food Paring'n, "Meat") > 0  then FP_Meat = 1; else FP_Meat = 0;
if findw('Food Paring'n, "Mediterranean") > 0  then FP_Mediterranean = 1; else FP_Mediterranean = 0;
if findw('Food Paring'n, "MiddleEastern") > 0  then FP_MiddleEastern = 1; else FP_MiddleEastern = 0;
if findw('Food Paring'n, "None") > 0  then FP_None = 1; else FP_None = 0;
if findw('Food Paring'n, "PanAsian") > 0  then FP_PanAsian = 1; else FP_PanAsian = 0;
if findw('Food Paring'n, "Salad") > 0  then FP_Salad = 1; else FP_Salad = 0;
if findw('Food Paring'n, "Thai") > 0  then FP_Thai = 1; else FP_Thai = 0;
run;

/*Final model*/
/*WORK.REG_OUT has 185643 observations and 2 variables*/
proc sql; select avg(Score) as Score from rg.temp2 where Score^=. and Ratings^=0; quit;
data reg_out (keep=Score yhat); set rg.temp2 (where=(Score^=.)); 
if Ratings = 0 then yhat = 0; else yhat = 3.72144;run;
proc sql; select sqrt(avg((Score-yhat)*(Score-yhat))) as RMSE from reg_out; quit;
