libname rg "/ccr/ccar_secured/rg83892";
options compress=yes;

/*RG.TEMP3 has 14800 observations and 31 variables*/
data rg.temp3; set rg.temp2; run;

/*society*/
/*30 var = dropped 1*/
proc sql; select society, avg(price) as price, count(*) as cnt from rg.temp3 group by society; quit;
data rg.temp3 (drop=society); set rg.temp3; run;

/*location*/
/*44 var = dropped 1 added 15*/
data rg.temp3; set rg.temp3; l1 = compress(location); l1 = compress(l1,",./;<>?:1234567890!@#$%^&*()_+-="); run;
proc sql; create table temp as select l1, avg(price) as p1 from rg.temp3 group by l1;
create table rg.temp3 as select a.*, b.p1 from rg.temp3 as a left join temp as b on a.l1 = b.l1; 
create table rg.temp3 as select *, avg(price) as p2 from rg.temp3;
create table rg.temp3 as select a.*, b.key as l2 from rg.temp3 as a left join rg.location as b on a.l1 = b.location; 
drop table temp; quit;
data rg.temp3 (drop=location l1 l2 p1 p2); set rg.temp3;
if p1 = . then location_bin = p2; else location_bin = p1;
if compress(l2) = "Whitefield" then location_Whitefield = 1; else  location_Whitefield = 0;
if compress(l2) = "Sarjapur" then location_Sarjapur = 1; else  location_Sarjapur = 0;
if compress(l2) = "JPNagar" then location_JPNagar = 1; else  location_JPNagar = 0;
if compress(l2) = "ElectronicCity" then location_Electronic = 1; else  location_Electronic = 0;
if compress(l2) = "Kanakapura" then location_Kanakapura = 1; else  location_Kanakapura = 0;
if compress(l2) = "Thanisandra" then location_Thanisandra = 1; else  location_Thanisandra = 0;
if compress(l2) = "Yelahanka" then location_Yelahanka = 1; else  location_Yelahanka = 0;
if compress(l2) = "Uttarahalli" then location_Uttarahalli = 1; else  location_Uttarahalli = 0;
if compress(l2) = "Hebbal" then location_Hebbal = 1; else  location_Hebbal = 0;
if compress(l2) = "RajaRajeshwariNagar" then location_RajaRaj = 1; else  location_RajaRaj = 0;
if compress(l2) = "Marathahalli" then location_Marathahalli = 1; else  location_Marathahalli = 0;
if compress(l2) = "Hennur" then location_Hennur = 1; else  location_Hennur = 0;
if compress(l2) = "Bannerghatta" then location_Bannerghatta = 1; else  location_Bannerghatta = 0;
if compress(l2) = "HaralurRoad" then location_HaralurRoad = 1; else  location_HaralurRoad = 0;
run;
proc sql; select location_bin, avg(price) as price, count(*) as cnt from rg.temp3 group by location_bin; quit;

/*Final Dataset*/
/*RG.TEMP4_TRAIN has 13320 observations and 44 variables*/
/*RG.TEMP4_TEST has 1480 observations and 44 variables*/
data rg.temp4; set rg.temp3; run;
data rg.temp4_train; set rg.temp4 (where=(price^=.)); run;
data rg.temp4_test; set rg.temp4 (where=(price=.)); run;
proc means data=rg.temp4; var _numeric_; run;
proc means data=rg.temp4_train; var _numeric_; run;
proc means data=rg.temp4_test; var _numeric_; run;

/*Final model*/
proc corr data=rg.temp4_train noprob; var _numeric_; run;
proc reg data=rg.temp4_train; model price = /*availability_now*/ area_type_bua area_type_pa /*balcony_bin*/
size_1 size_2 /*size_3*/ /*size_4*/ bath_bin total_sqft_bin
location_Whitefield location_Sarjapur location_JPNagar location_Electronic location_Kanakapura location_Thanisandra location_Yelahanka location_Uttarahalli location_Hebbal location_RajaRaj location_Marathahalli location_Hennur location_Bannerghatta location_HaralurRoad
/ vif; output out=reg_out p=yhat; run;
data reg_out (keep=price yhat); set reg_out; run;
proc sql; select sqrt(avg((price-yhat)*(price-yhat))) as RMSE from reg_out; quit;


/*Final model*/
proc corr data=rg.temp4_train noprob; var _numeric_; run;
proc reg data=rg.temp4_train; model price = /*availability_now*/ area_type_bua area_type_pa /*balcony_bin*/
size_1 size_2 /*size_3*/ /*size_4*/ bath_bin total_sqft_bin location_bin
/ vif; output out=reg_out p=yhat; run;
data reg_out (keep=price yhat); set reg_out; run;
proc sql; select sqrt(avg((price-yhat)*(price-yhat))) as RMSE from reg_out; quit;