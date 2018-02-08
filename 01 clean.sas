proc contents data=rg.student; run;

data c; set rg.student; run;
%macro cat_var (var);
proc sql;
create table temp as 
select &var., avg(pass)/(1-avg(pass)) as p_&var.
from c
group by &var.;
quit;
proc sql;
create table c as 
select a.*, b.p_&var.
from c as a left join temp as b
on a.&var. = b.&var.;
quit;
data c (drop=&var.);
set c;
p_&var. = log(1+p_&var.);
run;
%mend;

/*1 numerical*/
data c (drop = absences age);
format t_absences $10.;
format t_age $10.;

set c;
if absences = 0 then t_absences = "b. 11-20";
else if absences <= 10 then t_absences = "a. 1-10";
else if absences <= 20 then t_absences = "b. 11-20";
else t_absences = "c. 20+";

if age <= 16 then t_age = "a. 16-";
else t_age = "b. 16+";
run;

%cat_var (t_absences);
%cat_var (t_age);

/*2 categorical*/
data c (drop=famrel fedu medu);
format t_famrel $10.;
format t_fedu $10.;
format t_medu $10.;

set c;
if famrel in (1,5) then t_famrel = "c. 1 or 5";
else if famrel in (4) then t_famrel = "b. 4";
else t_famrel = "c. 2 or 3";

if fedu in (0,4) then t_fedu = "c. 0 or 4";
else if fedu in (2,3) then t_fedu = "b. 2 or 3";
else t_fedu = "c. 1";

if medu in (4) then t_medu = "c. 4";
else if medu in (0,2,3) then t_medu = "b. 0 or 2 or 3";
else t_medu = "c. 1";
run;

%cat_var (activities);
%cat_var (address);
%cat_var (dalc);
%cat_var (failures);
%cat_var (t_famrel);
%cat_var (famsize);
%cat_var (famsup);

%cat_var (t_fedu);
%cat_var (fjob);
%cat_var (freetime);
%cat_var (goout);
%cat_var (guardian);
%cat_var (health);
%cat_var (higher);

%cat_var (internet);
%cat_var (t_medu);
%cat_var (mjob);
%cat_var (nursery);
%cat_var (paid);
%cat_var (pstatus);
%cat_var (reason);

%cat_var (romantic);
%cat_var (school);
%cat_var (schoolsup);
%cat_var (sex);
%cat_var (studytime);
%cat_var (traveltime);
%cat_var (walc);

/*3 final dataset*/
data rg.c1; set c; run;
proc contents data=rg.c1; run;
