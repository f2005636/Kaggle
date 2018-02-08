%macro uni_var (var);
proc logistic data=rg.c1 desc;
model pass = &var. / link=logit lackfit;
output out=bin_model p=prob;
run;
%mend;

%uni_var(p_t_absences);
%uni_var(p_t_age);

%uni_var(p_activities);
%uni_var(p_address);
%uni_var(p_dalc);
%uni_var(p_failures);
%uni_var(p_t_famrel);
%uni_var(p_famsize);
%uni_var(p_famsup);

%uni_var(p_t_fedu);
%uni_var(p_fjob);
%uni_var(p_freetime);
%uni_var(p_goout);
%uni_var(p_guardian);
%uni_var(p_health);
%uni_var(p_higher);

%uni_var(p_internet);
%uni_var(p_t_medu);
%uni_var(p_mjob);
%uni_var(p_nursery);
%uni_var(p_paid);
%uni_var(p_pstatus);
%uni_var(p_reason);

%uni_var(p_romantic);
%uni_var(p_school);
%uni_var(p_schoolsup);
%uni_var(p_sex);
%uni_var(p_studytime);
%uni_var(p_traveltime);
%uni_var(p_walc);

data rg.c2 (keep = pass p_failures p_t_absences p_goout p_higher p_t_age p_t_fedu 
p_t_medu p_dalc p_mjob p_guardian p_reason p_freetime p_schoolsup p_romantic p_paid);
set rg.c1;
run;

proc corr data=rg.c2 out=temp;
var pass p_failures p_t_absences p_goout p_higher p_t_age p_t_fedu 
p_t_medu p_dalc p_mjob p_guardian p_reason p_freetime p_schoolsup p_romantic p_paid;
run;
