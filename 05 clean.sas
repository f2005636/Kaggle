options compress=yes;
libname rg "/ccr/ccar_secured/rg83892/us_2017/data";

data rg.c1; format flag $20.;
set rg.train; flag = "train";
run;

data rg.c2; format flag $20.;
set rg.test; flag = "test";
run;

data rg.c3; format row_num;
set rg.c1 rg.c2; row_num = _n_;
run;

proc contents data=rg.c3; run;

%macro var1(var);
proc rank data=rg.c3 out=rg.c3 groups=15;
var &var.;
ranks t_&var.;
run;
data rg.c3;
set rg.c3;
if t_&var. = . then t_&var. = 15;
run;
proc sql;
create table &var. as 
select t_&var., min(&var.) as min_var, max(&var.) as max_var, 
count(*) as cnt_var, avg(Response * Response) as avg_Response
from rg.c3
group by t_&var.;
quit;
%mend;

%macro var2(var);
proc sort data=&var.; by t_&var.; run;
data &var.;
set &var.;
retain a_bin;
if cnt_var > 79 then a_bin = t_&var.;
run;
proc sort data=&var.; by descending t_&var.; run;
data &var.;
set &var.;
retain d_bin;
if cnt_var > 79 then d_bin = t_&var.;
run;
proc sql;
create table rg.c3 as 
select a.*, b.a_bin, b.d_bin
from rg.c3 as a left join &var. as b
on a.t_&var. = b.t_&var.;
quit;
data rg.c3 (drop=a_bin d_bin &var.);
set rg.c3;
t_&var. = max(a_bin,d_bin);
/*if t_&var. = . then t_&var. = 15;*/
run;
%mend;

%macro var3(var);
proc sql;
select t_&var., avg(Response * Response) as avg_Response, count(*) as cnt
from rg.c3
group by t_&var.;
quit;
%mend;

%var1(BMI);	%var2(BMI);	%var3(BMI);
%var1(Employment_Info_1);	%var2(Employment_Info_1);	%var3(Employment_Info_1);
%var1(Employment_Info_2);	%var2(Employment_Info_2);	%var3(Employment_Info_2);
%var1(Employment_Info_3);	%var2(Employment_Info_3);	%var3(Employment_Info_3);
%var1(Employment_Info_4);	%var2(Employment_Info_4);	%var3(Employment_Info_4);
%var1(Employment_Info_5);	%var2(Employment_Info_5);	%var3(Employment_Info_5);
%var1(Employment_Info_6);	%var2(Employment_Info_6);	%var3(Employment_Info_6);
%var1(Family_Hist_1);	%var2(Family_Hist_1);	%var3(Family_Hist_1);
%var1(Family_Hist_2);	%var2(Family_Hist_2);	%var3(Family_Hist_2);
%var1(Family_Hist_3);	%var2(Family_Hist_3);	%var3(Family_Hist_3);
%var1(Family_Hist_4);	%var2(Family_Hist_4);	%var3(Family_Hist_4);
%var1(Family_Hist_5);	%var2(Family_Hist_5);	%var3(Family_Hist_5);
%var1(Ht);	%var2(Ht);	%var3(Ht);
%var1(Ins_Age);	%var2(Ins_Age);	%var3(Ins_Age);
%var1(Insurance_History_1);	%var2(Insurance_History_1);	%var3(Insurance_History_1);
%var1(Insurance_History_2);	%var2(Insurance_History_2);	%var3(Insurance_History_2);
%var1(Insurance_History_3);	%var2(Insurance_History_3);	%var3(Insurance_History_3);
%var1(Insurance_History_4);	%var2(Insurance_History_4);	%var3(Insurance_History_4);
%var1(Insurance_History_5);	%var2(Insurance_History_5);	%var3(Insurance_History_5);
%var1(Insurance_History_7);	%var2(Insurance_History_7);	%var3(Insurance_History_7);
%var1(Insurance_History_8);	%var2(Insurance_History_8);	%var3(Insurance_History_8);
%var1(Insurance_History_9);	%var2(Insurance_History_9);	%var3(Insurance_History_9);
%var1(InsuredInfo_1);	%var2(InsuredInfo_1);	%var3(InsuredInfo_1);
%var1(InsuredInfo_2);	%var2(InsuredInfo_2);	%var3(InsuredInfo_2);
%var1(InsuredInfo_3);	%var2(InsuredInfo_3);	%var3(InsuredInfo_3);
%var1(InsuredInfo_4);	%var2(InsuredInfo_4);	%var3(InsuredInfo_4);
%var1(InsuredInfo_5);	%var2(InsuredInfo_5);	%var3(InsuredInfo_5);
%var1(InsuredInfo_6);	%var2(InsuredInfo_6);	%var3(InsuredInfo_6);
%var1(InsuredInfo_7);	%var2(InsuredInfo_7);	%var3(InsuredInfo_7);

%var1(Medical_History_1);	%var2(Medical_History_1);	%var3(Medical_History_1);
%var1(Medical_History_2);	%var2(Medical_History_2);	%var3(Medical_History_2);
%var1(Medical_History_3);	%var2(Medical_History_3);	%var3(Medical_History_3);
%var1(Medical_History_4);	%var2(Medical_History_4);	%var3(Medical_History_4);
%var1(Medical_History_5);	%var2(Medical_History_5);	%var3(Medical_History_5);
%var1(Medical_History_6);	%var2(Medical_History_6);	%var3(Medical_History_6);
%var1(Medical_History_7);	%var2(Medical_History_7);	%var3(Medical_History_7);
%var1(Medical_History_8);	%var2(Medical_History_8);	%var3(Medical_History_8);
%var1(Medical_History_9);	%var2(Medical_History_9);	%var3(Medical_History_9);
%var1(Medical_History_10);	%var2(Medical_History_10);	%var3(Medical_History_10);
%var1(Medical_History_11);	%var2(Medical_History_11);	%var3(Medical_History_11);
%var1(Medical_History_12);	%var2(Medical_History_12);	%var3(Medical_History_12);
%var1(Medical_History_13);	%var2(Medical_History_13);	%var3(Medical_History_13);
%var1(Medical_History_14);	%var2(Medical_History_14);	%var3(Medical_History_14);
%var1(Medical_History_15);	%var2(Medical_History_15);	%var3(Medical_History_15);
%var1(Medical_History_16);	%var2(Medical_History_16);	%var3(Medical_History_16);
%var1(Medical_History_17);	%var2(Medical_History_17);	%var3(Medical_History_17);
%var1(Medical_History_18);	%var2(Medical_History_18);	%var3(Medical_History_18);
%var1(Medical_History_19);	%var2(Medical_History_19);	%var3(Medical_History_19);
%var1(Medical_History_20);	%var2(Medical_History_20);	%var3(Medical_History_20);
%var1(Medical_History_21);	%var2(Medical_History_21);	%var3(Medical_History_21);
%var1(Medical_History_22);	%var2(Medical_History_22);	%var3(Medical_History_22);
%var1(Medical_History_23);	%var2(Medical_History_23);	%var3(Medical_History_23);
%var1(Medical_History_24);	%var2(Medical_History_24);	%var3(Medical_History_24);
%var1(Medical_History_25);	%var2(Medical_History_25);	%var3(Medical_History_25);
%var1(Medical_History_26);	%var2(Medical_History_26);	%var3(Medical_History_26);
%var1(Medical_History_27);	%var2(Medical_History_27);	%var3(Medical_History_27);
%var1(Medical_History_28);	%var2(Medical_History_28);	%var3(Medical_History_28);
%var1(Medical_History_29);	%var2(Medical_History_29);	%var3(Medical_History_29);
%var1(Medical_History_30);	%var2(Medical_History_30);	%var3(Medical_History_30);
%var1(Medical_History_31);	%var2(Medical_History_31);	%var3(Medical_History_31);
%var1(Medical_History_32);	%var2(Medical_History_32);	%var3(Medical_History_32);
%var1(Medical_History_33);	%var2(Medical_History_33);	%var3(Medical_History_33);
%var1(Medical_History_34);	%var2(Medical_History_34);	%var3(Medical_History_34);
%var1(Medical_History_35);	%var2(Medical_History_35);	%var3(Medical_History_35);
%var1(Medical_History_36);	%var2(Medical_History_36);	%var3(Medical_History_36);
%var1(Medical_History_37);	%var2(Medical_History_37);	%var3(Medical_History_37);
%var1(Medical_History_38);	%var2(Medical_History_38);	%var3(Medical_History_38);
%var1(Medical_History_39);	%var2(Medical_History_39);	%var3(Medical_History_39);
%var1(Medical_History_40);	%var2(Medical_History_40);	%var3(Medical_History_40);
%var1(Medical_History_41);	%var2(Medical_History_41);	%var3(Medical_History_41);

%var1(Medical_Keyword_1);	%var2(Medical_Keyword_1);	%var3(Medical_Keyword_1);
%var1(Medical_Keyword_2);	%var2(Medical_Keyword_2);	%var3(Medical_Keyword_2);
%var1(Medical_Keyword_3);	%var2(Medical_Keyword_3);	%var3(Medical_Keyword_3);
%var1(Medical_Keyword_4);	%var2(Medical_Keyword_4);	%var3(Medical_Keyword_4);
%var1(Medical_Keyword_5);	%var2(Medical_Keyword_5);	%var3(Medical_Keyword_5);
%var1(Medical_Keyword_6);	%var2(Medical_Keyword_6);	%var3(Medical_Keyword_6);
%var1(Medical_Keyword_7);	%var2(Medical_Keyword_7);	%var3(Medical_Keyword_7);
%var1(Medical_Keyword_8);	%var2(Medical_Keyword_8);	%var3(Medical_Keyword_8);
%var1(Medical_Keyword_9);	%var2(Medical_Keyword_9);	%var3(Medical_Keyword_9);
%var1(Medical_Keyword_10);	%var2(Medical_Keyword_10);	%var3(Medical_Keyword_10);
%var1(Medical_Keyword_11);	%var2(Medical_Keyword_11);	%var3(Medical_Keyword_11);
%var1(Medical_Keyword_12);	%var2(Medical_Keyword_12);	%var3(Medical_Keyword_12);
%var1(Medical_Keyword_13);	%var2(Medical_Keyword_13);	%var3(Medical_Keyword_13);
%var1(Medical_Keyword_14);	%var2(Medical_Keyword_14);	%var3(Medical_Keyword_14);
%var1(Medical_Keyword_15);	%var2(Medical_Keyword_15);	%var3(Medical_Keyword_15);
%var1(Medical_Keyword_16);	%var2(Medical_Keyword_16);	%var3(Medical_Keyword_16);
%var1(Medical_Keyword_17);	%var2(Medical_Keyword_17);	%var3(Medical_Keyword_17);
%var1(Medical_Keyword_18);	%var2(Medical_Keyword_18);	%var3(Medical_Keyword_18);
%var1(Medical_Keyword_19);	%var2(Medical_Keyword_19);	%var3(Medical_Keyword_19);
%var1(Medical_Keyword_20);	%var2(Medical_Keyword_20);	%var3(Medical_Keyword_20);
%var1(Medical_Keyword_21);	%var2(Medical_Keyword_21);	%var3(Medical_Keyword_21);
%var1(Medical_Keyword_22);	%var2(Medical_Keyword_22);	%var3(Medical_Keyword_22);
%var1(Medical_Keyword_23);	%var2(Medical_Keyword_23);	%var3(Medical_Keyword_23);
%var1(Medical_Keyword_24);	%var2(Medical_Keyword_24);	%var3(Medical_Keyword_24);
%var1(Medical_Keyword_25);	%var2(Medical_Keyword_25);	%var3(Medical_Keyword_25);
%var1(Medical_Keyword_26);	%var2(Medical_Keyword_26);	%var3(Medical_Keyword_26);
%var1(Medical_Keyword_27);	%var2(Medical_Keyword_27);	%var3(Medical_Keyword_27);
%var1(Medical_Keyword_28);	%var2(Medical_Keyword_28);	%var3(Medical_Keyword_28);
%var1(Medical_Keyword_29);	%var2(Medical_Keyword_29);	%var3(Medical_Keyword_29);
%var1(Medical_Keyword_30);	%var2(Medical_Keyword_30);	%var3(Medical_Keyword_30);
%var1(Medical_Keyword_31);	%var2(Medical_Keyword_31);	%var3(Medical_Keyword_31);
%var1(Medical_Keyword_32);	%var2(Medical_Keyword_32);	%var3(Medical_Keyword_32);
%var1(Medical_Keyword_33);	%var2(Medical_Keyword_33);	%var3(Medical_Keyword_33);
%var1(Medical_Keyword_34);	%var2(Medical_Keyword_34);	%var3(Medical_Keyword_34);
%var1(Medical_Keyword_35);	%var2(Medical_Keyword_35);	%var3(Medical_Keyword_35);
%var1(Medical_Keyword_36);	%var2(Medical_Keyword_36);	%var3(Medical_Keyword_36);
%var1(Medical_Keyword_37);	%var2(Medical_Keyword_37);	%var3(Medical_Keyword_37);
%var1(Medical_Keyword_38);	%var2(Medical_Keyword_38);	%var3(Medical_Keyword_38);
%var1(Medical_Keyword_39);	%var2(Medical_Keyword_39);	%var3(Medical_Keyword_39);
%var1(Medical_Keyword_40);	%var2(Medical_Keyword_40);	%var3(Medical_Keyword_40);
%var1(Medical_Keyword_41);	%var2(Medical_Keyword_41);	%var3(Medical_Keyword_41);
%var1(Medical_Keyword_42);	%var2(Medical_Keyword_42);	%var3(Medical_Keyword_42);
%var1(Medical_Keyword_43);	%var2(Medical_Keyword_43);	%var3(Medical_Keyword_43);
%var1(Medical_Keyword_44);	%var2(Medical_Keyword_44);	%var3(Medical_Keyword_44);
%var1(Medical_Keyword_45);	%var2(Medical_Keyword_45);	%var3(Medical_Keyword_45);
%var1(Medical_Keyword_46);	%var2(Medical_Keyword_46);	%var3(Medical_Keyword_46);
%var1(Medical_Keyword_47);	%var2(Medical_Keyword_47);	%var3(Medical_Keyword_47);
%var1(Medical_Keyword_48);	%var2(Medical_Keyword_48);	%var3(Medical_Keyword_48);

%var1(Product_Info_1);	%var2(Product_Info_1);	%var3(Product_Info_1);

data rg.c3 (drop=a_bin d_bin Product_Info_2);
set rg.c3;
Product_Info_2 = compress(Product_Info_2);
a_bin = substr(Product_Info_2,1,1);
d_bin = input(substr(Product_Info_2,2,1),2.);
if a_bin = "A" then t_Product_Info_2 = 10 + d_bin;
else if a_bin = "B" then t_Product_Info_2 = 20 + d_bin;
else if a_bin = "C" then t_Product_Info_2 = 30 + d_bin;
else if a_bin = "D" then t_Product_Info_2 = 40 + d_bin;
else t_Product_Info_2 = 50;
run;	
%var3(Product_Info_2);

%var1(Product_Info_3);	%var2(Product_Info_3);	%var3(Product_Info_3);
%var1(Product_Info_4);	%var2(Product_Info_4);	%var3(Product_Info_4);
%var1(Product_Info_5);	%var2(Product_Info_5);	%var3(Product_Info_5);
%var1(Product_Info_6);	%var2(Product_Info_6);	%var3(Product_Info_6);
%var1(Product_Info_7);	%var2(Product_Info_7);	%var3(Product_Info_7);
%var1(Wt);	%var2(Wt);	%var3(Wt);

data rg.c3 (rename=(
t_BMI = BMI_
t_Employment_Info_1 = EI_1_
t_Employment_Info_2 = EI_2_
t_Employment_Info_3 = EI_3_
t_Employment_Info_4 = EI_4_
t_Employment_Info_5 = EI_5_
t_Employment_Info_6 = EI_6_
t_Family_Hist_1 = FH_1_
t_Family_Hist_2 = FH_2_
t_Family_Hist_3 = FH_3_
t_Family_Hist_4 = FH_4_
t_Family_Hist_5 = FH_5_
t_Ht = HT_
t_Ins_Age = IAGE_
t_Insurance_History_1 = IH_1_
t_Insurance_History_2 = IH_2_
t_Insurance_History_3 = IH_3_
t_Insurance_History_4 = IH_4_
t_Insurance_History_5 = IH_5_
t_Insurance_History_7 = IH_7_
t_Insurance_History_8 = IH_8_
t_Insurance_History_9 = IH_9_
t_InsuredInfo_1 = II_1_
t_InsuredInfo_2 = II_2_
t_InsuredInfo_3 = II_3_
t_InsuredInfo_4 = II_4_
t_InsuredInfo_5 = II_5_
t_InsuredInfo_6 = II_6_
t_InsuredInfo_7 = II_7_

t_Medical_History_1 = MH_1_
t_Medical_History_2 = MH_2_
t_Medical_History_3 = MH_3_
t_Medical_History_4 = MH_4_
t_Medical_History_5 = MH_5_
t_Medical_History_6 = MH_6_
t_Medical_History_7 = MH_7_
t_Medical_History_8 = MH_8_
t_Medical_History_9 = MH_9_
t_Medical_History_10 = MH_10_
t_Medical_History_11 = MH_11_
t_Medical_History_12 = MH_12_
t_Medical_History_13 = MH_13_
t_Medical_History_14 = MH_14_
t_Medical_History_15 = MH_15_
t_Medical_History_16 = MH_16_
t_Medical_History_17 = MH_17_
t_Medical_History_18 = MH_18_
t_Medical_History_19 = MH_19_
t_Medical_History_20 = MH_20_
t_Medical_History_21 = MH_21_
t_Medical_History_22 = MH_22_
t_Medical_History_23 = MH_23_
t_Medical_History_24 = MH_24_
t_Medical_History_25 = MH_25_
t_Medical_History_26 = MH_26_
t_Medical_History_27 = MH_27_
t_Medical_History_28 = MH_28_
t_Medical_History_29 = MH_29_
t_Medical_History_30 = MH_30_
t_Medical_History_31 = MH_31_
t_Medical_History_32 = MH_32_
t_Medical_History_33 = MH_33_
t_Medical_History_34 = MH_34_
t_Medical_History_35 = MH_35_
t_Medical_History_36 = MH_36_
t_Medical_History_37 = MH_37_
t_Medical_History_38 = MH_38_
t_Medical_History_39 = MH_39_
t_Medical_History_40 = MH_40_
t_Medical_History_41 = MH_41_

t_Medical_Keyword_1 = MK_1_
t_Medical_Keyword_2 = MK_2_
t_Medical_Keyword_3 = MK_3_
t_Medical_Keyword_4 = MK_4_
t_Medical_Keyword_5 = MK_5_
t_Medical_Keyword_6 = MK_6_
t_Medical_Keyword_7 = MK_7_
t_Medical_Keyword_8 = MK_8_
t_Medical_Keyword_9 = MK_9_
t_Medical_Keyword_10 = MK_10_
t_Medical_Keyword_11 = MK_11_
t_Medical_Keyword_12 = MK_12_
t_Medical_Keyword_13 = MK_13_
t_Medical_Keyword_14 = MK_14_
t_Medical_Keyword_15 = MK_15_
t_Medical_Keyword_16 = MK_16_
t_Medical_Keyword_17 = MK_17_
t_Medical_Keyword_18 = MK_18_
t_Medical_Keyword_19 = MK_19_
t_Medical_Keyword_20 = MK_20_
t_Medical_Keyword_21 = MK_21_
t_Medical_Keyword_22 = MK_22_
t_Medical_Keyword_23 = MK_23_
t_Medical_Keyword_24 = MK_24_
t_Medical_Keyword_25 = MK_25_
t_Medical_Keyword_26 = MK_26_
t_Medical_Keyword_27 = MK_27_
t_Medical_Keyword_28 = MK_28_
t_Medical_Keyword_29 = MK_29_
t_Medical_Keyword_30 = MK_30_
t_Medical_Keyword_31 = MK_31_
t_Medical_Keyword_32 = MK_32_
t_Medical_Keyword_33 = MK_33_
t_Medical_Keyword_34 = MK_34_
t_Medical_Keyword_35 = MK_35_
t_Medical_Keyword_36 = MK_36_
t_Medical_Keyword_37 = MK_37_
t_Medical_Keyword_38 = MK_38_
t_Medical_Keyword_39 = MK_39_
t_Medical_Keyword_40 = MK_40_
t_Medical_Keyword_41 = MK_41_
t_Medical_Keyword_42 = MK_42_
t_Medical_Keyword_43 = MK_43_
t_Medical_Keyword_44 = MK_44_
t_Medical_Keyword_45 = MK_45_
t_Medical_Keyword_46 = MK_46_
t_Medical_Keyword_47 = MK_47_
t_Medical_Keyword_48 = MK_48_
t_Product_Info_1 = PI_1_
t_Product_Info_2 = PI_2_
t_Product_Info_3 = PI_3_
t_Product_Info_4 = PI_4_
t_Product_Info_5 = PI_5_
t_Product_Info_6 = PI_6_
t_Product_Info_7 = PI_7_
t_Wt = WT_)
drop=Response);
format y best32.;
set rg.c3;
y = Response;
run;

proc sort data=rg.c3;
by flag row_num;
run;

data rg.df_train1 (drop = flag row_num Id); set rg.c3; 
where flag = "train" and row_num <= 10000;
run; 

data rg.df_train2 (drop = flag row_num Id); set rg.c3; 
where flag = "train" and row_num >= 10001 and row_num <= 20000;
run; 

data rg.df_train3 (drop = flag row_num Id); set rg.c3; 
where flag = "train" and row_num >= 20001 and row_num <= 30000;
run; 

data rg.df_train4 (drop = flag row_num Id); set rg.c3; 
where flag = "train" and row_num >= 30001 and row_num <= 40000;
run; 

data rg.df_train5 (drop = flag row_num Id); set rg.c3; 
where flag = "train" and row_num >= 40001 and row_num <= 50000;
run; 

data rg.df_train6 (drop = flag row_num Id); set rg.c3; 
where flag = "train" and row_num >= 50001;
run; 

data rg.df_test(drop = flag row_num Id Response); set rg.c3; 
where flag = "test";
run; 

