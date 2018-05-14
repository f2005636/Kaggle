data temp6; set rg.step2;
format RE $10.; 
if REtype_CO_orig_time = 1 then CO="CO"; else CO="NA";
if REtype_PU_orig_time = 1 then PU="PU"; else PU="NA";
if REtype_SF_orig_time = 1 then SF="SF"; else SF="NA";
RE=CO||PU||SF;
run;
 
data temp7 (drop= RE
REtype_CO_orig_time CO
REtype_PU_orig_time PU
REtype_SF_orig_time SF);
set temp6;
if RE="CONANA" then RE_bin = -3.5763;
else if RE="NANANA" then RE_bin = -3.6732;
else RE_bin = -3.6089;
run;

%macro cat_bin(df, var);
proc sql;
select &var., count(*) as cnt, avg(default) as pd, log(avg(default) / (1-avg(default))) as log_pd
from &df.
group by &var.;
quit;
%mend;
%cat_bin(temp6, RE);
%cat_bin(temp7, RE_bin);

proc contents data=temp7; run;

/*6. model*/
%macro log_model(var);
proc logistic data=temp7 desc;
model default = &var.; run;
%mend;
%log_model(hpi_diff_bin);
%log_model(hpi_qoq_bin);
%log_model(uer_mom_bin);
%log_model(uer_qoq_bin);
%log_model(LTV_time_bin);
%log_model(int_rate_diff_bin);
%log_model(balance_time_bin);
%log_model(orig_time_bin);
%log_model(FICO_orig_bin);
%log_model(balance_orig_bin);
%log_model(balance_time_bin);
%log_model(RE_bin);

/*7. raw model*/
proc logistic data=temp7 desc;
model default = uer_qoq_bin  LTV_time_bin  int_rate_diff_bin  orig_time_bin FICO_orig_bin ; 
output out=bin_model p=prob; run;

proc reg data=temp7;
model default = uer_qoq_bin  LTV_time_bin  int_rate_diff_bin  orig_time_bin FICO_orig_bin /vif; run;

/*8. measurement*/
data temp; set _null_; run;
%macro f_val(var);
data bin_model_rg;
set bin_model (keep=default prob);
if prob >= INPUT("&var" ,8.)then pred = 1; else pred = 0;
run;
data bin_model_rg;
set bin_model_rg;
if default = 0 and pred = 0 then fap00 = 1; else fap00 = 0; 
if default = 0 and pred = 1 then fap01 = 1; else fap01 = 0; 
if default = 1 and pred = 0 then fap10 = 1; else fap10 = 0; 
if default = 1 and pred = 1 then fap11 = 1; else fap11 = 0; 
c = &var.;
run;
proc sql;
create table con_mat as
select avg(c) as c, sum(fap00) as fap00, sum(fap01) as fap01, sum(fap10) as fap10, sum(fap11) as fap11
from bin_model_rg;
quit;
data temp; set temp con_mat; 
a = (fap00 + fap11) / (fap00 + fap01 + fap10 + fap11);
p = fap11 / (fap11 + fap01);
r = fap11 / (fap11 + fap01);
f = (2 * p * r) / (p + r);
run;
%mend;
%f_val(0.05);
%f_val(0.075);
%f_val(0.10);
%f_val(0.125);
%f_val(0.15);

proc logistic data=temp7 desc noprint;
model default = uer_qoq_bin  LTV_time_bin  int_rate_diff_bin  orig_time_bin FICO_orig_bin / 
outroc=ROCData;
run;
data ROCData;
set ROCData;
row_num = _n_;
if mod(row_num,100) = 0;
run;