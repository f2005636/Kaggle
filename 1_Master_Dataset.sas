libname rg "/ccr/ccar_secured/rg83892";
options compress=yes;

/*RG.TEMP1: train and test dataset */
/*RG.TEMP1 has 14800 observations and 10 variables*/
data rg.location; set WORK.location; row_num=_n_; run;
data rg.train; set WORK.train; row_num=_n_; run;
data rg.test (drop=price); set WORK.test; row_num=_n_; run;
data rg.temp1; set rg.train rg.test; run;

/*RG.TEMP2 has 14800 observations and 10 variables*/
data rg.temp2; set rg.temp1; run;

/*area_type*/
/*12 var = dropped 1 added 3*/
data rg.temp2 (drop=area_type); set rg.temp2;
if compress(area_type) = "Built-upArea" then area_type_bin = 104.2855; else if compress(area_type) = "CarpetArea" then area_type_bin = 89.5024; else if compress(area_type) = "PlotArea" then area_type_bin = 208.4955; else if compress(area_type) = "Superbuilt-upArea" then area_type_bin = 92.9718; else area_type_bin = .;
if compress(area_type) = "Built-upArea" then area_type_bua = 1; else area_type_bua = 0;
if compress(area_type) = "PlotArea" then area_type_pa = 1; else area_type_pa = 0;
run;
proc sql; select area_type_bin, avg(price) as price, count(*) as cnt from rg.temp2 group by area_type_bin; quit;

/*availability*/
/*13 var = dropped 1 added 2*/
data rg.temp2 (drop=availability y q m t); set rg.temp2;
y = input(substr(availability,1,2),2.); m = substr(availability,4,3);
if m in ('Jan','Feb','Mar') then q = 1; if m in ('Apr','May','Jun') then q = 2; if m in ('Jul','Aug','Sep') then q = 3; if m in ('Oct','Nov','Dec') then q = 4; 
t = compress(y)||"-"||compress(q); if t = '.-.' then t = availability; availability = t;
if compress(availability) in ("ReadyToMove","ImmediatePossession") then availability_bin = 102.49; else availability_bin = 115.15;
if compress(availability) in ("ReadyToMove","ImmediatePossession") then availability_now = 1; else availability_now = 0;
run;
proc sql; select availability_bin, avg(price) as price, count(*) as cnt from rg.temp2 group by availability_bin; quit;

/*size*/
/*17 var = dropped 1 added 5*/
data rg.temp2 (drop=size s1 s2 s3); set rg.temp2;
s1 = lowcase(compress(size)); s1 = lowcase(compress(s1,'abcdefghijklmnopqrstuvwxyz'));
s2 = input(s1,2.);
if s2 =. then s3 = 3; else if s2 >= 10 then s3 = 10; else if s2 >= 4 then s3 = 4; else s3 = s2;
if s3 = 1 then size_bin =44.6334; else if s3 = 2 then size_bin =59.5792; else if s3 = 3 then size_bin =110.9128; else if s3 = 4 then size_bin =263.3807; else if s3 = 10 then size_bin =426.1538; else size_bin = .;
if s3 = 1 then size_1 = 1; else size_1 = 0; 
if s3 = 2 then size_2 = 1; else size_2 = 0; 
if s3 = 3 then size_3 = 1; else size_3 = 0; 
if s3 = 4 then size_4 = 1; else size_4 = 0; 
run;
proc sql; select size_bin, avg(price) as price, count(*) as cnt from rg.temp2 group by size_bin; quit;

/*bath*/
/*21 var = dropped 1 added 5*/
data rg.temp2 (drop=bath b); set rg.temp2;
if bath =. then b = 3; else if bath >= 5 then b = 5; else b = bath;
if b = 1 then bath_bin = 47.5846; else if b = 2 then bath_bin = 63.4041; else if b = 3 then bath_bin = 125.5617; else if b = 4 then bath_bin = 237.0058; else if b = 5 then bath_bin = 299.8568; else bath_bin = .;
if b = 1 then bath_1 = 1; else bath_1 = 0; 
if b = 2 then bath_2 = 1; else bath_2 = 0; 
if b = 3 then bath_3 = 1; else bath_3 = 0; 
if b = 4 then bath_4 = 1; else bath_4 = 0; 
run;
proc sql; select bath_bin, avg(price) as price, count(*) as cnt from rg.temp2 group by bath_bin; quit;

/*balcony*/
/*23 var = dropped 1 added 3*/
data rg.temp2 (drop=balcony b); set rg.temp2;
if balcony =. then b = 3; else if balcony >= 3 then b = 2; else b = 1;
if b = 1 then balcony_bin = 99.2904; else if b = 2 then balcony_bin = 150.7488; else if b = 3 then balcony_bin = 248.3673; else balcony_bin = .;
if b = 1 then balcony_1 = 1; else balcony_1 = 0; 
if b = 2 then balcony_2 = 1; else balcony_2 = 0; 
run;
proc sql; select balcony_bin, avg(price) as price, count(*) as cnt from rg.temp2 group by balcony_bin; quit;

/*total_sqft*/
/*31 var = dropped 1 added 9*/
data rg.temp2 (drop=total_sqft sl sr s1 s2 s3); set rg.temp2;
s1 = lowcase(compress(total_sqft)); s1 = lowcase(compress(s1,'abcdefghijklmnopqrstuvwxyz')); s1 = scan(s1,1,".");
sl = input(scan(s1,1,"-"),10.); sr = input(scan(s1,2,"-"),10.);
s2 = 5*round(mean(sl,sr)/5,100)/1000; 
if s2 < 1 then s3 = 1; else if s2 >= 5.5 and s2 <= 6.0 then s3 = 6.0; else if s2 > 7 then s3 = 7; else s3 = s2;
total_sqft_bin = (22.718*s3*s3) - (33.213*s3) + 117.21;
total_sqft_1 = 0; total_sqft_2 = 0; total_sqft_3 = 0; total_sqft_4 = 0; total_sqft_5 = 0; total_sqft_6 = 0; total_sqft_7 = 0; total_sqft_8 = 0;
if s3 <= 1.5 then total_sqft_1 = 1;  
else if s3 <= 2 then total_sqft_2 = 1; 
else if s3 <= 3 then total_sqft_3 = 1;  
else if s3 <= 3.5 then total_sqft_4 = 1;  
else if s3 <= 4 then total_sqft_5 = 1;  
else if s3 <= 5 then total_sqft_6 = 1;  
else if s3 <= 6 then total_sqft_7 = 1;  
else if s3 <= 6.5 then total_sqft_8 = 1;  
run;
proc sql; select total_sqft_bin, avg(price) as price, count(*) as cnt from rg.temp2 group by total_sqft_bin; quit;

/*Final Dataset*/
/*RG.TEMP2_TRAIN has 13320 observations and 31 variables*/
/*RG.TEMP2_TEST has 1480 observations and 31 variables*/
data rg.temp2_train; set rg.temp2 (where=(price^=.)); run;
data rg.temp2_test; set rg.temp2 (where=(price=.)); run;
proc means data=rg.temp2; var _numeric_; run;
proc means data=rg.temp2_train; var _numeric_; run;
proc means data=rg.temp2_test; var _numeric_; run;

/*Final model*/
proc corr data=rg.temp2_train noprob; var _numeric_; run;
proc reg data=rg.temp2_train; model price = /*availability_now*/ area_type_bua area_type_pa /*balcony_bin*/
size_1 size_2 /*size_3*/ /*size_4*/ bath_bin total_sqft_bin
/ vif; output out=reg_out p=yhat; run;
data reg_out (keep=price yhat); set reg_out; run;
proc sql; select sqrt(avg((price-yhat)*(price-yhat))) as RMSE from reg_out; quit;