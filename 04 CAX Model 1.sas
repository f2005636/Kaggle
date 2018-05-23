options compress=yes;
libname rg '/ccr/ccar_secured/rg83892/in2016ye';

data rg.CAX_Startup_Sub; set WORK.CAX_Startup_Pred_Sub_Format; row_num = _n_; run;
data rg.CAX_Startup_Train; set WORK.CAX_Startup_Train; flag = 'TRAIN'; run;
data rg.CAX_Startup_Test; set WORK.CAX_Startup_Test (drop=Dependent); flag = 'TEST'; run;
data rg.CAX_Startup_Data; set rg.CAX_Startup_Train rg.CAX_Startup_Test; X = 'X'; run;
proc contents data=rg.CAX_Startup_Data;run;

%macro rg_bin (var);
proc sql;
create table m1 as 
select &var., mean(Dependent) as &var._bin
from temp
group by &var.;
quit;
proc sql;
create table m2 as 
select a.*, b.&var._bin
from temp as a left join m1 as b
on a.&var. = b.&var.;
quit;
proc print data=m1; run;
data temp; set m2 (drop=&var.); if &var._bin = . then &var._bin = 0.5; run;
%mend;

data temp_num;
format Company_investor_count_seed best32.; format Company_investor_count_Angel_VC best32.; format Company_cofounders_count best32.; format Company_advisors_count best32.; 
format Company_senior_team_count best32.; format Company_repeat_investors_count best32.; format Founder_university_quality best32.; format Founders_Popularity best32.; 
format Founders_fortune1000_company_sco best32.; format Founders_skills_score best32.; format Founders_Entrepreneurship_skills best32.; format Founders_Operations_skills_score best32.; 
format Founders_Engineering_skills_scor best32.; format Founders_Marketing_skills_score best32.; format Founders_Leadership_skills_score best32.; format Founders_Data_Science_skills_sco best32.; 
format Founders_Business_Strategy_skill best32.; format Founders_Product_Management_skil best32.; format Founders_Sales_skills_score best32.; format Founders_Domain_skills_score best32.; 
format Company_competitor_count best32.; format Company_1st_investment_time best32.; format Company_avg_investment_time best32.; format Company_analytics_score best32.; 
set rg.CAX_Startup_Data;
run;

data temp;
format CAX_ID $100.; format Dependent best32.; format flag $100.; format Company_Location $100.; 
format Company_raising_fund $100.; format Company_Industry_count $100.; format Company_mobile_app $100.; format Company_top_Angel_VC_funding $100.; 
format Founders_top_company $100.; format Founders_previous_company $100.; format Founders_startup_experience $100.; format Founders_big_5_experience $100.; 
format Company_business_model $100.; format Founders_experience $100.; format Founders_global_exposure $100.; format Founders_Industry_exposure $100.; 
format Founder_education $100.; format Founders_profile_similarity $100.; format Founders_publications $100.; format Company_incubation_investor $100.; 
format Company_crowdsourcing $100.; format Company_crowdfunding $100.; format Company_big_data $100.; format Company_Product_or_service $100.; 
format Company_subscription $100.; format Founder_highest_degree_type $100.; format Company_difficulty_obtaining $100.; format Company_Founder_Patent $100.; 

set temp_num (rename=(Founders_previous_company_employ=Founders_previous_company
Founders_top_company_experience = Founders_top_company
Company_difficulty_obtaining_wor = Company_difficulty_obtaining
Company_subscription_offering = Company_subscription));
Company_Location = upcase(compress(Company_Location));

Company_raising_fund = upcase(compress(Company_raising_fund));
Company_Industry_count = upcase(compress(Company_Industry_count));
Company_mobile_app = upcase(compress(Company_mobile_app));
Company_top_Angel_VC_funding = upcase(compress(Company_top_Angel_VC_funding));

Founders_top_company = upcase(compress(Founders_top_company));
Founders_previous_company = upcase(compress(Founders_previous_company));
Founders_startup_experience = upcase(compress(Founders_startup_experience));
Founders_big_5_experience = upcase(compress(Founders_big_5_experience));

Company_business_model = upcase(compress(Company_business_model));
Founders_experience = upcase(compress(Founders_experience));
Founders_global_exposure = upcase(compress(Founders_global_exposure));
Founders_Industry_exposure = upcase(compress(Founders_Industry_exposure));

Founder_education = upcase(compress(Founder_education));
Founders_profile_similarity = upcase(compress(Founders_profile_similarity));
Founders_publications = upcase(compress(Founders_publications));
Company_incubation_investor = upcase(compress(Company_incubation_investor));

Company_crowdsourcing = upcase(compress(Company_crowdsourcing));
Company_crowdfunding = upcase(compress(Company_crowdfunding));
Company_big_data = upcase(compress(Company_big_data));
Company_Product_or_service = upcase(compress(Company_Product_or_service));

Company_subscription = upcase(compress(Company_subscription));
Founder_highest_degree_type = upcase(compress(Founder_highest_degree_type));
Company_difficulty_obtaining = upcase(compress(Company_difficulty_obtaining));
Company_Founder_Patent = upcase(compress(Company_Founder_Patent));
run;
%rg_bin(Company_Location);

%rg_bin(Company_raising_fund);
%rg_bin(Company_Industry_count);
%rg_bin(Company_mobile_app);
%rg_bin(Company_top_Angel_VC_funding);

%rg_bin(Founders_top_company);
%rg_bin(Founders_previous_company);
%rg_bin(Founders_startup_experience);
%rg_bin(Founders_big_5_experience);

%rg_bin(Company_business_model);
%rg_bin(Founders_experience);
%rg_bin(Founders_global_exposure);
%rg_bin(Founders_Industry_exposure);

%rg_bin(Founder_education);
%rg_bin(Founders_profile_similarity);
%rg_bin(Founders_publications);
%rg_bin(Company_incubation_investor);

%rg_bin(Company_crowdsourcing);
%rg_bin(Company_crowdfunding);
%rg_bin(Company_big_data);
%rg_bin(Company_Product_or_service);

%rg_bin(Company_subscription);
%rg_bin(Founder_highest_degree_type);
%rg_bin(Company_difficulty_obtaining);
%rg_bin(Company_Founder_Patent);

proc contents data=temp; run;

data rg.CAX_Startup_Data; set temp (drop=X); run;
