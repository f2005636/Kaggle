/*BIG MART SALES*/
/*https://datahack.analyticsvidhya.com/contest/practice-problem-big-mart-sales-iii/*/

/*1. import*/
data rg.train; set Train_UWu5bXk; run;
data rg.test; set Test_u94Q5KV; run;
data rg.sub; set SampleSubmission_TmnO39y; run;

/*2. data prep*/
data train; format flag $10.;
set rg.train (keep=Item_Outlet_Sales Outlet_Identifier Item_Identifier);
flag = "rg"; run;

data test; format flag $10.;
set rg.test (keep=Outlet_Identifier Item_Identifier);
flag = "rg"; run;

data sub;
set rg.sub (drop=Item_Outlet_Sales);
run;

proc sql;
create table OI_Identifier as select Outlet_Identifier, Item_Identifier, avg(Item_Outlet_Sales) as OI_Sales
from train group by Outlet_Identifier, Item_Identifier; 
create table O_Identifier as select Outlet_Identifier, avg(Item_Outlet_Sales) as O_Sales
from train group by Outlet_Identifier; 
create table I_Identifier as select Item_Identifier, avg(Item_Outlet_Sales) as I_Sales
from train group by Item_Identifier; 
create table A_Identifier as select flag, avg(Item_Outlet_Sales) as A_Sales
from train group by flag; 
quit;

/*3. predicted*/
proc sql;
create table p1 as select a.*, b.OI_Sales, c.O_Sales, d.I_Sales, e.A_Sales from test as a 
left join OI_Identifier as b on a.Outlet_Identifier = b.Outlet_Identifier and a.Item_Identifier = b.Item_Identifier
left join O_Identifier as c on a.Outlet_Identifier = c.Outlet_Identifier 
left join I_Identifier as d on a.Item_Identifier = d.Item_Identifier
left join A_Identifier as e on a.flag = e.flag;
quit;

data p2; set p1;
if OI_Sales ^= . then Item_Outlet_Sales = OI_Sales;
else Item_Outlet_Sales = I_Sales * O_Sales / A_Sales;
run;

proc sql;
create table rg_sub as  select a.*, b.Item_Outlet_Sales
from sub as a left join p2 as b on a.Outlet_Identifier = b.Outlet_Identifier and a.Item_Identifier = b.Item_Identifier;
quit;