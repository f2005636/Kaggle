options compress=yes;
libname outlib "/ccr/ccar_secured/rg83892/us_2017/data";

data temp1 (keep=
obsdate
HK_EQUITYP_HS_M
HK_RATE_LENDINGB_M
HK_RATE_POLICY_M
HK_XREALGDP_Q
SG_EQUITYP_STI_M
SG_EXRATE_M
SG_RATE_LENDING_M
SG_REALGDP_Q
US_CPI_M
US_LBR_M
US_OILPRICE_M
US_RATE_POLICY_M
US_RGDP_Q
US_RHPI_M
);
set outlib.macro_file;
format obsdate date9.; /*Create reporting date variable*/
yyyy=year(Mnemonics);
mm=month(Mnemonics);
dd = 31;
if mm in(4,6,9,11) then dd = 30;
if mm = 2 then dd = 28;
if mm = 2 and yyyy in (2000,2004,2008,2012,2016) then dd = 29;
obsdate = mdy(mm,dd,yyyy);
run;

proc sort data=temp1 out=temp2 nodup;
by obsdate;
run;


/*This code is to conduct macro variable transformation*/
%macro MacroVar(dfMacro, MacroVar);
data &dfMacro(drop=lag3&MacroVar lag12&MacroVar s k temp1 temp2);
retain s k;
set temp2;

lag3&MacroVar=lag3(&MacroVar); /*create macro variable transformation and lags*/
lag12&MacroVar=lag12(&MacroVar);
format Dqoq_&MacroVar best12.;
if missing(lag3&MacroVar) or missing(&MacroVar) then Dqoq_&MacroVar='.';
else Dqoq_&MacroVar=&MacroVar-lag3&MacroVar;
format Pctqoq_&MacroVar best12.;
Pctqoq_&MacroVar=Dqoq_&MacroVar/lag3&MacroVar;
format Pctyoy_&MacroVar best12.;
if missing(lag12&MacroVar) or missing(&MacroVar) then Pctyoy_&MacroVar='.';
else Pctyoy_&MacroVar=(&MacroVar-lag12&MacroVar)/lag12&MacroVar;

s = sum (s, &MacroVar, -lag120(&MacroVar)) ; /*create moving average*/
k = sum (k, &MacroVar, -lag3(&MacroVar)) ;
temp1 = s / 120;
temp2 = k / 3;
D10YrAvg_&MacroVar = &MacroVar - lag(temp1);
D3MonMavg_&MacroVar = temp2 - lag(temp2);
run;

proc sort data=&dfMacro;by obsdate; run;

data &dfMacro;
set &dfMacro;
/*lagN1_&MacroVar=lag(&MacroVar);*/
/*lagN2_&MacroVar=lag2(&MacroVar);*/
lagN3_&MacroVar=lag3(&MacroVar);
/*lagN4_&MacroVar=lag4(&MacroVar);*/
/*lagN5_&MacroVar=lag5(&MacroVar);*/
lagN6_&MacroVar=lag6(&MacroVar);
/*lagN7_&MacroVar=lag7(&MacroVar);*/
/*lagN8_&MacroVar=lag8(&MacroVar);*/
lagN9_&MacroVar=lag9(&MacroVar);
/*lagN10_&MacroVar=lag10(&MacroVar);*/
/*lagN11_&MacroVar=lag11(&MacroVar);*/
lagN12_&MacroVar=lag12(&MacroVar);

/*lagN1_Pctqoq_&MacroVar=lag1(Pctqoq_&MacroVar);*/
/*lagN2_Pctqoq_&MacroVar=lag2(Pctqoq_&MacroVar);*/
lagN3_Pctqoq_&MacroVar=lag3(Pctqoq_&MacroVar);
/*lagN4_Pctqoq_&MacroVar=lag4(Pctqoq_&MacroVar);*/
/*lagN5_Pctqoq_&MacroVar=lag5(Pctqoq_&MacroVar);*/
lagN6_Pctqoq_&MacroVar=lag6(Pctqoq_&MacroVar);
/*lagN7_Pctqoq_&MacroVar=lag7(Pctqoq_&MacroVar);*/
/*lagN8_Pctqoq_&MacroVar=lag8(Pctqoq_&MacroVar);*/
lagN9_Pctqoq_&MacroVar=lag9(Pctqoq_&MacroVar);
/*lagN10_Pctqoq_&MacroVar=lag10(Pctqoq_&MacroVar);*/
/*lagN11_Pctqoq_&MacroVar=lag11(Pctqoq_&MacroVar);*/
lagN12_Pctqoq_&MacroVar=lag12(Pctqoq_&MacroVar);

/*lagN1_Pctyoy_&MacroVar=lag1(Pctyoy_&MacroVar);*/
/*lagN2_Pctyoy_&MacroVar=lag2(Pctyoy_&MacroVar);*/
lagN3_Pctyoy_&MacroVar=lag3(Pctyoy_&MacroVar);
/*lagN4_Pctyoy_&MacroVar=lag4(Pctyoy_&MacroVar);*/
/*lagN5_Pctyoy_&MacroVar=lag5(Pctyoy_&MacroVar);*/
lagN6_Pctyoy_&MacroVar=lag6(Pctyoy_&MacroVar);
/*lagN7_Pctyoy_&MacroVar=lag7(Pctyoy_&MacroVar);*/
/*lagN8_Pctyoy_&MacroVar=lag8(Pctyoy_&MacroVar);*/
lagN9_Pctyoy_&MacroVar=lag9(Pctyoy_&MacroVar);
/*lagN10_Pctyoy_&MacroVar=lag10(Pctyoy_&MacroVar);*/
/*lagN11_Pctyoy_&MacroVar=lag11(Pctyoy_&MacroVar);*/
lagN12_Pctyoy_&MacroVar=lag12(Pctyoy_&MacroVar);
run;
%mend;

%MacroVar(HK_EQUITYP_HS_M,HK_EQUITYP_HS_M);
%MacroVar(HK_RATE_LENDINGB_M,HK_RATE_LENDINGB_M);
%MacroVar(HK_RATE_POLICY_M,HK_RATE_POLICY_M);
%MacroVar(HK_XREALGDP_Q,HK_XREALGDP_Q);
%MacroVar(SG_EQUITYP_STI_M,SG_EQUITYP_STI_M);
%MacroVar(SG_EXRATE_M,SG_EXRATE_M);
%MacroVar(SG_RATE_LENDING_M,SG_RATE_LENDING_M);
%MacroVar(SG_REALGDP_Q,SG_REALGDP_Q);
%MacroVar(US_CPI_M,US_CPI_M);
%MacroVar(US_LBR_M,US_LBR_M);
%MacroVar(US_OILPRICE_M,US_OILPRICE_M);
%MacroVar(US_RATE_POLICY_M,US_RATE_POLICY_M);
%MacroVar(US_RGDP_Q,US_RGDP_Q);
%MacroVar(US_RHPI_M,US_RHPI_M);

/*To compare total number of observations*/
proc contents data=HK_EQUITYP_HS_M; run;
proc contents data=HK_RATE_LENDINGB_M; run;
proc contents data=HK_RATE_POLICY_M; run;
proc contents data=HK_XREALGDP_Q; run;
proc contents data=SG_EQUITYP_STI_M; run;
proc contents data=SG_EXRATE_M; run;
proc contents data=SG_RATE_LENDING_M; run;
proc contents data=SG_REALGDP_Q; run;
proc contents data=US_CPI_M; run;
proc contents data=US_LBR_M; run;
proc contents data=US_OILPRICE_M; run;
proc contents data=US_RATE_POLICY_M; run;
proc contents data=US_RGDP_Q; run;
proc contents data=US_RHPI_M; run;

proc sql;
create table outlib.macro_us as 
select a.*, b.*, c.*, d.*, e.*, f.*, g.*, h.*, i.*, j.*, k.*, l.*, m.*, n.*, o.*
from temp2 as a
left join HK_EQUITYP_HS_M as b on a.obsdate = b.obsdate
left join HK_RATE_LENDINGB_M as c on a.obsdate = c.obsdate
left join HK_RATE_POLICY_M as d on a.obsdate = d.obsdate
left join HK_XREALGDP_Q as e on a.obsdate = e.obsdate
left join SG_EQUITYP_STI_M as f on a.obsdate = f.obsdate
left join SG_EXRATE_M as g on a.obsdate = g.obsdate
left join SG_RATE_LENDING_M as h on a.obsdate = h.obsdate
left join SG_REALGDP_Q as i on a.obsdate = i.obsdate
left join US_CPI_M as j on a.obsdate = j.obsdate
left join US_LBR_M as k on a.obsdate = k.obsdate
left join US_OILPRICE_M as l on a.obsdate = l.obsdate
left join US_RATE_POLICY_M as m on a.obsdate = m.obsdate
left join US_RGDP_Q as n on a.obsdate = n.obsdate
left join US_RHPI_M as o on a.obsdate = o.obsdate;
quit;

data outlib.macro_us;
set outlib.macro_us;
where obsdate < '01JAN2016'd;
run;