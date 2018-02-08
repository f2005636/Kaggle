
proc contents data=rg.train; run;

data rg.c1; 
format y best32.;
format t_BMI $20.;
format t_EI_1 $20.;
format t_EI_2 $20.;
format t_EI_3 $20.;
format t_EI_4 $20.;
format t_EI_5 $20.;
format t_EI_6 $20.;
format t_FH_1 $20.;
format t_FH_2 $20.;
format t_FH_3 $20.;
format t_FH_4 $20.;
format t_FH_5 $20.;
format t_Ht $20.;
format t_Ins_Age $20.;
format t_IH_1 $20.;
format t_IH_2 $20.;
format t_IH_3 $20.;
format t_IH_4 $20.;
format t_IH_5 $20.;
format t_IH_7 $20.;
format t_IH_8 $20.;
format t_IH_9 $20.;
format t_PI_1 $20.;
format t_PI_2 $20.;
format t_PI_3 $20.;
format t_PI_4 $20.;
format t_PI_5 $20.;
format t_PI_6 $20.;
format t_PI_7 $20.;
format t_Wt $20.;

set rg.train; 
y = Response;

/*BMI*/
if BMI <= 0.313 then t_BMI = 'bin a';
else if BMI <= 0.345 then t_BMI = 'bin b';
else if BMI <= 0.369 then t_BMI = 'bin c';
else if BMI <= 0.391 then t_BMI = 'bin d';
else if BMI <= 0.41 then t_BMI = 'bin e';
else if BMI <= 0.427 then t_BMI = 'bin f';
else if BMI <= 0.445 then t_BMI = 'bin g';
else if BMI <= 0.463 then t_BMI = 'bin h';
else if BMI <= 0.481 then t_BMI = 'bin i';
else if BMI <= 0.501 then t_BMI = 'bin j';
else if BMI <= 0.526 then t_BMI = 'bin k';
else if BMI <= 0.556 then t_BMI = 'bin l';
else if BMI <= 0.598 then t_BMI = 'bin m';
else if BMI <= 0.67 then t_BMI = 'bin n';
else t_BMI = 'bin o';

/*employment hist*/
if Employment_Info_1 = . or Employment_Info_1 <= 0.030 then t_EI_1 = "a. low";
else if Employment_Info_1 <= 0.043 then t_EI_1 = "b. low_mid";
else if Employment_Info_1 <= 0.060 then t_EI_1 = "c. mid_mid";
else if Employment_Info_1 <= 0.092 then t_EI_1 = "d. high_mid";
else t_EI_1 = "e. high";

if Employment_Info_2 <= 1 then t_EI_2 = "a. low";
else if Employment_Info_2 <= 7 then t_EI_2 = "b. low_mid";
else if Employment_Info_2 <= 11 then t_EI_2 = "e. high";
else if Employment_Info_2 <= 12 then t_EI_2 = "b. low_mid";
else if Employment_Info_2 <= 13 then t_EI_2 = "a. low";
else t_EI_2 = "d. high_mid";

t_EI_3 = compress(Employment_Info_3);

if Employment_Info_4 = . then t_EI_4 = "c. mid_mid";
else if Employment_Info_4 <= 0.000 then t_EI_4 = "d. high_mid";
else if Employment_Info_4 <= 0.002 then t_EI_4 = "e. high";
else if Employment_Info_4 <= 0.025 then t_EI_4 = "b. low_mid";
else t_EI_4 = "a. low";

t_EI_5 = compress(Employment_Info_5);

if Employment_Info_6 = . then t_EI_6 = "c. mid_mid";
else if Employment_Info_6 <= 0.018 then t_EI_6 = "a. low";
else if Employment_Info_6 <= 0.350 then t_EI_6 = "c. mid_mid";
else t_EI_6 = "e. high";

/*Family Hist*/
t_FH_1 = compress(Family_Hist_1);
if Family_Hist_2 = . then t_FH_2 = "0"; else t_FH_2 = "1";
if Family_Hist_3 = . then t_FH_3 = "0"; else t_FH_3 = "1";
if Family_Hist_4 = . then t_FH_4 = "0"; else t_FH_4 = "1";
if Family_Hist_5 = . then t_FH_5 = "0"; else t_FH_5 = "1";

/*Ht*/
if Ht <= 0.582 then t_Ht = 'bin c';
else if Ht <= 0.6 then t_Ht = 'bin a';
else if Ht <= 0.636 then t_Ht = 'bin a';
else if Ht <= 0.655 then t_Ht = 'bin b';
else if Ht <= 0.673 then t_Ht = 'bin b';
else if Ht <= 0.691 then t_Ht = 'bin d';
else if Ht <= 0.709 then t_Ht = 'bin e';
else if Ht <= 0.727 then t_Ht = 'bin f';
else if Ht <= 0.745 then t_Ht = 'bin f';
else if Ht <= 0.764 then t_Ht = 'bin g';
else if Ht <= 0.782 then t_Ht = 'bin i';
else if Ht <= 0.8 then t_Ht = 'bin h';
else if Ht <= 1 then t_Ht = 'bin j';
else if Ht <= 0.67 then t_Ht = 'bin k';
else t_Ht = 'bin l';

/*Age*/
if Ins_Age <= 0.104 then t_Ins_Age = 'bin a';
else if Ins_Age <= 0.164 then t_Ins_Age = 'bin a';
else if Ins_Age <= 0.209 then t_Ins_Age = 'bin a';
else if Ins_Age <= 0.239 then t_Ins_Age = 'bin b';
else if Ins_Age <= 0.284 then t_Ins_Age = 'bin c';
else if Ins_Age <= 0.328 then t_Ins_Age = 'bin d';
else if Ins_Age <= 0.373 then t_Ins_Age = 'bin e';
else if Ins_Age <= 0.418 then t_Ins_Age = 'bin f';
else if Ins_Age <= 0.463 then t_Ins_Age = 'bin g';
else if Ins_Age <= 0.507 then t_Ins_Age = 'bin h';
else if Ins_Age <= 0.552 then t_Ins_Age = 'bin h';
else if Ins_Age <= 0.597 then t_Ins_Age = 'bin i';
else if Ins_Age <= 0.642 then t_Ins_Age = 'bin j';
else if Ins_Age <= 0.687 then t_Ins_Age = 'bin k';
else t_Ins_Age = 'bin l';

/*Insurance Hist*/
t_IH_1 = compress(Insurance_History_1);

if Insurance_History_2 = 3 then t_IH_2 = "1"; else t_IH_2 = "0";

if Insurance_History_3 = 1 then t_IH_3 = "1"; else t_IH_3 = "0";
 
t_IH_4 = compress(Insurance_History_4);

if Insurance_History_5 = . then t_IH_5 = "c. mid_mid";
else if Insurance_History_5 <= 0.000433 then t_IH_5 = "a. low";
else if Insurance_History_5 <= 0.001333 then t_IH_5 = "c. mid_mid";
else t_IH_5 = "e. high";

t_IH_7 = compress(Insurance_History_7);

t_IH_8 = compress(Insurance_History_8);

t_IH_9 = compress(Insurance_History_9);

/*Product Info*/
t_PI_1 = compress(Product_Info_1);

t_PI_2 = compress(Product_Info_2);

if Product_Info_3 <= 10 then t_PI_3= 'e. high ';
else if Product_Info_3 <= 26 then t_PI_3= 'c. mid_mid ';
else t_PI_3= 'a. low ';

if Product_Info_4 <= 0.072 then t_PI_4 = "a. low";
else if Product_Info_4 <= 0.077 then t_PI_4 = "b. low_mid";
else if Product_Info_4 <= 0.282 then t_PI_4 = "c. mid_mid";
else if Product_Info_4 <= 0.487 then t_PI_4 = "d. high_mid";
else t_PI_4 = "e. high";

t_PI_5 = compress(Product_Info_5);

t_PI_6 = compress(Product_Info_6);

if Product_Info_7 = 3 then t_PI_7 = "1"; else t_PI_7 = "0"; 

/*Wt*/
if Wt <= 0.172 then t_Wt = 'bin a';
else if Wt <= 0.192 then t_Wt = 'bin b';
else if Wt <= 0.213 then t_Wt = 'bin c';
else if Wt <= 0.232 then t_Wt = 'bin d';
else if Wt <= 0.247 then t_Wt = 'bin e';
else if Wt <= 0.266 then t_Wt = 'bin f';
else if Wt <= 0.278 then t_Wt = 'bin g';
else if Wt <= 0.289 then t_Wt = 'bin h';
else if Wt <= 0.308 then t_Wt = 'bin i';
else if Wt <= 0.32 then t_Wt = 'bin j';
else if Wt <= 0.339 then t_Wt = 'bin k';
else if Wt <= 0.362 then t_Wt = 'bin l';
else if Wt <= 0.391 then t_Wt = 'bin m';
else if Wt <= 0.433 then t_Wt = 'bin n';
else t_Wt = 'bin o';
run;

%macro var1(var);
proc sql;
select &var., avg(Response * Response) as avg_Response, count(*) as cnt
from rg.c1
group by &var.;
quit;
%mend;

%macro var2(var);
proc means data=rg.c1 min p5 p10 p25 p50 p75 p90 p95 max nmiss;
var Employment_Info_1;
run;
%mend;

%macro var3(var);
proc rank data=rg.c1 out=rg.c1 groups=15;
var &var.;
ranks &var._;
run;
data rg.c1;
set rg.c1;
if &var._ = . then &var._ = -1;
run;
proc sql;
select &var._, min(&var.) as min_var, max(&var.) as max_var, 
count(*) as cnt_var, avg(Response * Response) as avg_Response
from rg.c1
group by &var._;
quit;
%mend;


%var1(t_IH_1);
%var1(t_IH_2);
%var1(t_IH_3);
%var1(t_IH_4);
%var1(t_IH_5);
%var1(t_IH_7);
%var1(t_IH_8);
%var1(t_IH_9);

