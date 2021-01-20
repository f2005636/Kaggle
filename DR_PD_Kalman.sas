data PD_DR;
input PD 11. DR 11. ;
datalines;
0.003126698	0.000000000
0.003108295	0.000000000
0.003212995	0.000000000
0.003392376	0.000000000
0.004105120 0.000000000
0.004821731	0.009796133
0.011874813	0.004557660
0.009840630 0.000000000
0.009784389	0.002894018
;
run;

proc sql noprint;
select std(DR-PD) into :PDstd
from PD_DR
;
quit;

%put PD_std=&PDstd;

data k_input;
set PD_DR;
PD_res=DR-PD;
PD_std=&PDstd.;
month="Month"||compress(_N_);
run;

%K_fltr (c=9);

%macro K_fltr (C=);

data K_fltr_t;
set _NULL_;
run;

%do j=1 %to &c;
%let j=1;
Data _NULL_;
set k_input;
if _N_=&j then do;
call symput ('res_j', left(PD_res));
call symput ('std_j', left(PD_std));
call symput ('month_j', left(month));
call symput ('PD_j', left(PD));
call symput ('DR_j', left(DR));
end;
run;
%put res_j=&res_j;
%put std_j=&std_j;
%put month_j=&month_j;
%put PD_j=&PD_j;
%put DR_j=&DR_j;

proc IML;

%let J_1 = %eval(&j - 1);

%if &j_1 = 1 %then 
%do;
XRR = {&res_j, 0};
PRR = (&std_j**2) * {1 0.0, 0.0 1};
%end;
%else 
%do;
use tetXRRj_1.;
read all into XRR;
use tetPRR&j_1;
read all into PRR;
%end;

A = {1 1, 01};
H = {1 0};
Q = (&std_j**2) * {1 0.0, 0.0 1};
R = &std_j**2;
ID = I(2);

Xhat = A * XRR;
Phat = A * PRR * A` + Q;

Y = &res_j - H * Xhat;
S = H * Phat * H` + R;
K = Phat * H` * inv(S);
X = Xhat + K * Y;
P = (ID - K * H) * Phat;

XF = X;
create tetXRR&j from XF;
append from XF;
*print XF;
XF1 = XF`;
create tetXRRF&j from XF1;
append from XF1;

PF = P;
create tetPRR&j from PF;
append from PF;
*print PF;
PF2 = vecdiag(PF); PF3 = PF2`;
create tetPRRF&j from PF3;
append from PF3;

data tetXRRF;
set tetXRRF&j;
time = &month_j;
PD_res_obs = &res_j;
PD_res_hat = col1;
PD_lt_hat = col2;
PD = PD_j;
DR = DR_j;
drop col1 col2;
run;

data K_fltr_t;
set K_fltr_t tetXRRF;
run;

quit;

%end;
%mend;

Proc sgplot data=K_fltr_t;
xaxis type=discrete;
series x=time y=PD_res_hat /lineattrs= (THICKNESS = 1 pattern=dash);
scatter x=time y= DR /MARKERATTRS= (color=blue size =8);
series x=time y= PD /lineattrs= (THICKNESS = 1);
Title "PD res Kalman filter";
run;

