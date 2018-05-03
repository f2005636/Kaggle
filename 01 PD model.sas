libname rg '/ccr/ccar_secured/rg83892/in2016ye';

/*1. data*/
/*data rg.hmeq; set hmeq; run;*/
proc contents data=rg.hmeq; run;

/*2. cat variables*/
data cat; set rg.hmeq;
if REASON = "HomeImp" then REASON_bin = -1.25132;
else REASON_bin = -1.45188;

if JOB in ("Sales","Self") then JOB_bin = -0.76353;
else if JOB in ("Mgr","Other") then JOB_bin = -1.19521;
else if JOB = "ProfExe" then JOB_bin = -1.61320;
else if JOB = "Office" then JOB_bin = -1.88464;
else JOB_bin = -2.40968;

if DEROG in (.,0) then DEROG_bin = -1.6534;
else if DEROG = 1 then DEROG_bin = -0.45360;
else if DEROG = 2 then DEROG_bin = 0.05001;
else DEROG_bin = 1.078203;

if DELINQ in (.,0) then DELINQ_bin = -1.83508;
else if DELINQ = 1 then DELINQ_bin = -0.66575;
else if DELINQ = 2 then DELINQ_bin = -0.20875;
else if DELINQ in (3,4) then DELINQ_bin = 0.26236;
else DELINQ_bin = 2.47293;

if NINQ in (.,0) then NINQ_bin = -1.6968;
else if NINQ = 1 then NINQ_bin = -1.4520;
else if NINQ in (2,3) then NINQ_bin = -1.1215;
else if NINQ = 4 then NINQ_bin = -0.4430;
else NINQ_bin = -0.1751;
run;

%macro cat_bin(var);
proc sql;
select &var., count(*) as cnt, avg(BAD) as pd, log(avg(BAD) / (1-avg(BAD))) as log_pd
from cat
group by &var.;
quit;
%mend;
%cat_bin(REASON_bin);
%cat_bin(JOB_bin);
%cat_bin(DEROG_bin);
%cat_bin(DELINQ_bin);
%cat_bin(NINQ_bin);

/*3. num variables*/
data num; set cat; run;
%macro rank_bin(var);
proc rank data=num out=num groups=12;
var &var; ranks &var._;
run;
data num; set num;
if &var._ = . then &var._ = -1;
run;
proc sql;
select &var._, count(*) as cnt, min(&var) as min_var, max(&var) as max_var, avg(&var) as mean_avg,
avg(BAD) as pd, log(avg(BAD) / (1-avg(BAD))) as log_pd
from num
group by &var._;
quit;
%mend;
%rank_bin(LOAN);
%rank_bin(MORTDUE);
%rank_bin(VALUE);
%rank_bin(YOJ);
%rank_bin(CLAGE);
%rank_bin(CLNO);
%rank_bin(DEBTINC);

data num; set cat; 
if LOAN <= 7000 then LOAN_bin = -0.46679; else LOAN_bin = -1.50117;

if MORTDUE > 0 and MORTDUE <= 37000 then MORTDUE_bin = -0.99659;
else if MORTDUE > 73000 and MORTDUE <= 106000 then MORTDUE_bin = -1.72294;
else MORTDUE_bin = -1.38798;

if VALUE = . then VALUE_bin = 2.70805;
else if VALUE > 0 and VALUE <= 45900 then VALUE_bin = -0.71479;
else if VALUE > 89000 and VALUE <= 120000 then VALUE_bin = -1.81316;
else VALUE_bin = -1.48528;

if YOJ = . or YOJ > 22 then YOJ_bin = -1.95571;
else if YOJ > 0.4 and YOJ <= 2.9 then YOJ_bin = -0.98141;
else YOJ_bin = -1.36986;

if CLAGE = . then CLAGE_new = 0.14; else CLAGE_new = CLAGE / 1000;
CLAGE_bin = (15.49*CLAGE_new*CLAGE_new) - (12.06*CLAGE_new) + 0.0789;

if CLNO = . or CLNO >= 36 then CLNO_bin = -1.10998;
else if CLNO >= 0 and CLNO <= 8 then CLNO_bin = -0.68969;
else CLNO_bin = -1.51438;

if DEBTINC = . then DEBTINC_bin = 0.49109;
else if DEBTINC > 41 then DEBTINC_bin = -1.08005;
else DEBTINC_bin = -2.70624;
run;

%macro num_bin(var);
proc sql;
select &var., count(*) as cnt, avg(BAD) as pd, log(avg(BAD) / (1-avg(BAD))) as log_pd
from num
group by &var.;
quit;
%mend;
%num_bin(LOAN_bin);
%num_bin(MORTDUE_bin);
%num_bin(VALUE_bin);
%num_bin(YOJ_bin);
%num_bin(CLNO_bin);
%num_bin(DEBTINC_bin);

/*4. raw model*/
proc logistic data=cat;
model bad = REASON_bin JOB_bin DEROG_bin DELINQ_bin NINQ_bin ;
run;
proc reg data=cat;
model bad = REASON_bin JOB_bin DEROG_bin DELINQ_bin NINQ_bin /vif ;
run;

proc logistic data=num;
model bad = LOAN_bin MORTDUE_bin VALUE_bin YOJ_bin CLNO_bin DEBTINC_bin CLAGE_bin;
run;
proc reg data=num;
model bad = LOAN_bin MORTDUE_bin VALUE_bin YOJ_bin CLNO_bin DEBTINC_bin CLAGE_bin /vif ;
run;

/*5. final model*/
data fin; set num; run;

proc logistic data=fin desc;
model bad = /*REASON_bin*/ JOB_bin /*DEROG_bin*/ DELINQ_bin /*NINQ_bin*/
/*LOAN_bin*/ /*MORTDUE_bin*/ VALUE_bin YOJ_bin CLNO_bin DEBTINC_bin CLAGE_bin;
output out=bin_model p=prob;
run;

proc reg data=fin;
model bad = /*REASON_bin*/ JOB_bin /*DEROG_bin*/ DELINQ_bin /*NINQ_bin*/
/*LOAN_bin*/ /*MORTDUE_bin*/ VALUE_bin YOJ_bin CLNO_bin DEBTINC_bin CLAGE_bin /vif ;
run;

data temp; set _null_; run;
%macro f_val(var);
data bin_model;
set bin_model (keep=bad prob);
if prob >= INPUT("&var" ,8.)then pred = 1; else pred = 0;
run;
data bin_model;
set bin_model;
if BAD = 0 and pred = 0 then fap00 = 1; else fap00 = 0; 
if BAD = 0 and pred = 1 then fap01 = 1; else fap01 = 0; 
if BAD = 1 and pred = 0 then fap10 = 1; else fap10 = 0; 
if BAD = 1 and pred = 1 then fap11 = 1; else fap11 = 0; 
c = &var.;
run;
proc sql;
create table con_mat as
select avg(c) as c, sum(fap00) as fap00, sum(fap01) as fap01, sum(fap10) as fap10, sum(fap11) as fap11
from bin_model;
quit;
data temp; set temp con_mat; 
a = (fap00 + fap11) / (fap00 + fap01 + fap10 + fap11);
p = fap11 / (fap11 + fap01);
r = fap11 / (fap11 + fap01);
f = (2 * p * r) / (p + r);
run;
%mend;
%f_val(0.5);

proc logistic data=fin desc noprint;
model bad = /*REASON_bin*/ JOB_bin /*DEROG_bin*/ DELINQ_bin /*NINQ_bin*/
/*LOAN_bin*/ /*MORTDUE_bin*/ VALUE_bin YOJ_bin CLNO_bin DEBTINC_bin CLAGE_bin / 
outroc=ROCData;
run; 
