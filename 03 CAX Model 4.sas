options compress=yes;
libname rg '/ccr/ccar_secured/rg83892/in2016ye';

/*data rg.CAX_Startup_Data; set WORK.CAX_Startup_Data; X = 'X'; run;*/
/*proc contents data=rg.CAX_Startup_Data;run;*/

data temp (drop='Number of  of Research publicati'n 'Skills score'n 'Team Composition score'n 'Dificulty of Obtaining Work forc'n
'Pricing Strategy'n 'Hyper localisation'n 'Time to market service or produc'n 'Employee benefits and salary str'n
'Long term relationship with othe'n 'Proprietary or patent position ('n 'Barriers of entry for the compet'n 'Company awards'n
'Controversial history of founder'n 'Legal risk and intellectual prop'n 'Client Reputation'n 'google page rank of company webs'n
'Technical proficiencies to analy'n 'Solutions offered'n 'Invested through global incubati'n 'Industry trend in investing'n
'Disruptiveness of technology'n 'Number of Direct competitors'n 'Employees per year of company ex'n 'Last round of funding received ('n
);

format Research_publications $100.; format Skills_score best32.; format Team_score $100.; format Dificulty_Work $100.;
format Pricing_Strategy $100.; format Hyper_Localisation $100.; format Time_to $100.; format Employee_benefits $100.; 
format Longterm_relationship $100.; format Proprietary_patent $100.; format Barriers_entry $100.; format Company_awards $100.; 
format Controversial_history $100.; format Legal_risk $100.; format Client_Reputation $100.; format google_page_rank best32.; 
format Technical_proficiencies $100.; format Solutions_offered $100.; format Invested_global $100.; format Industry_investing best32.; 
format Disruptiveness $100.; format Direct_competitors best32.; format Employees_per_year best32.; format Last_round_of_funding best32.; 

set rg.CAX_Startup_Data;
Research_publications = 'Number of  of Research publicati'n;
Skills_score = input('Skills score'n, best32.);
Team_score= 'Team Composition score'n;
Dificulty_Work = 'Dificulty of Obtaining Work forc'n;

Pricing_Strategy = 'Pricing Strategy'n;
Hyper_Localisation = 'Hyper localisation'n;
Time_to = 'Time to market service or produc'n;
Employee_benefits = 'Employee benefits and salary str'n;

Longterm_relationship = 'Long term relationship with othe'n;
Proprietary_patent = 'Proprietary or patent position ('n;
Barriers_entry = 'Barriers of entry for the compet'n;
Company_awards = 'Company awards'n;

Controversial_history = 'Controversial history of founder'n;
Legal_risk = 'Legal risk and intellectual prop'n;
Client_Reputation = 'Client Reputation'n;
google_page_rank = input('google page rank of company webs'n, best32.);

Technical_proficiencies = 'Technical proficiencies to analy'n;
Solutions_offered = 'Solutions offered'n;
Invested_global = 'Invested through global incubati'n;
Industry_investing = 'Industry trend in investing'n;

Disruptiveness = 'Disruptiveness of technology'n;
Direct_competitors = input('Number of Direct competitors'n, best32.);
Employees_per_year = input('Employees per year of company ex'n, best32.);
Last_round_of_funding = input('Last round of funding received ('n, best32.);
run;

proc contents data=temp; run;

%macro rg_bin (var);
proc sql;
create table m1 as 
select &var., mean(Status) as &var._bin
from temp
group by &var.;
quit;
proc sql;
create table m2 as 
select a.*, b.&var._bin
from temp as a left join m1 as b
on a.&var. = b.&var.;
quit;
data temp; set m2 (drop=&var.); run;
%mend;
%rg_bin(Research_publications);
%rg_bin(Skills_score);
%rg_bin(Team_score);
%rg_bin(Dificulty_Work);
%rg_bin(Pricing_Strategy);
%rg_bin(Hyper_Localisation);
%rg_bin(Time_to);
%rg_bin(Employee_benefits);
%rg_bin(Longterm_relationship);
%rg_bin(Proprietary_patent);
%rg_bin(Barriers_entry);
%rg_bin(Company_awards);
%rg_bin(Controversial_history);
%rg_bin(Legal_risk);
%rg_bin(Client_Reputation);
%rg_bin(google_page_rank);
%rg_bin(Technical_proficiencies);
%rg_bin(Solutions_offered);
%rg_bin(Invested_global);
%rg_bin(Industry_investing);
%rg_bin(Disruptiveness);
%rg_bin(Direct_competitors);
%rg_bin(Employees_per_year);
%rg_bin(Last_round_of_funding);

data rg.CAX_Startup_Data; set temp; run;
