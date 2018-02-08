proc logistic data=rg.c3 desc;
model pass = p_failures p_t_pout p_t_pjob p_t_absences p_t_higher_reason_ssup  
/ link=logit lackfit;
output out=bin_model p=prob;
run;

%macro cutoff_val (var);
data temp (keep = pass prob act pred);
set bin_model;
act = pass;
if prob > &var. then pred = 1; else pred = 0;
run;
proc sql;
select act, pred, count(*) as cnt
from temp
group by act, pred;
quit;
%mend;

%cutoff_val (0.4);
%cutoff_val (0.45);
%cutoff_val (0.5);
%cutoff_val (0.55);
%cutoff_val (0.6);
