proc contents data=all3; run;

proc corr data=all3 (drop=employee_id is_promoted) noprob;
var _all_; run;

proc corr data=all3 (drop=employee_id is_promoted no_of_trainings_bin age_bin) noprob;
var _all_; run;



data train; set all3; where is_promoted ^= . ; run;
data test ; set all3; where is_promoted = .  ; run;

proc logistic data=train desc;
model is_promoted = department_bin
region_bin
education_bin
/*gender_bin*/
/*recruitment_channel_bin*/
KPIs_met__80__bin
awards_won__bin
previous_year_rating_bin
avg_training_score_bin
gender_age_bin
rc_trainings_bin;
run;

proc logistic data=train desc;
model is_promoted = 
/*department_bin*/
region_bin
/*education_bin*/
KPIs_met__80__bin
awards_won__bin
previous_year_rating_bin
avg_training_score_bin
gender_age_bin
rc_trainings_bin;
output out=all4 p=prob;
run;

%macro rg_cut (var);
data temp; set all4 (keep=is_promoted prob); 
if prob > &var. then prob = 1; else prob = 0; run;
proc sql; select is_promoted, prob, count(*) as cnt
from temp group by is_promoted, prob; quit;
%mend;

%rg_cut(0.1);
%rg_cut(0.2); /* correct cut-off*/
%rg_cut(0.3);
%rg_cut(0.4);
%rg_cut(0.5);
%rg_cut(0.6);
%rg_cut(0.7);
%rg_cut(0.8);
%rg_cut(0.9);





proc logistic data=train desc outmodel=estimates;
model is_promoted = 
region_bin
KPIs_met__80__bin
awards_won__bin
previous_year_rating_bin
avg_training_score_bin
gender_age_bin
rc_trainings_bin;
output out=fin_model p=prob;
run;

proc logistic inmodel = estimates;
score data = test out= scored_data (rename=(p_1 = prob));
run;

data all5 (keep=employee_id is_promoted); set scored_data (drop=is_promoted);
if prob >= 0.2 then is_promoted = 1; else is_promoted =0; run;