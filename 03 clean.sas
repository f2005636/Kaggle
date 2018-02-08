proc logistic data=rg.c2 desc;
model pass = p_failures p_t_absences p_goout p_higher p_t_age p_t_fedu
p_t_medu p_dalc p_mjob p_guardian p_reason p_freetime p_schoolsup p_romantic
/ link=logit lackfit;
output out=bin_model p=prob;
run;

proc logistic data=rg.c2 desc;
model pass = p_failures p_t_absences p_goout p_t_age p_mjob p_freetime p_schoolsup
/ link=logit lackfit;
output out=bin_model p=prob;
run;

