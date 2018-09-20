data temp; set macro_econ; run;

proc sort data=temp; by time; run;

%macro rg_me (var);
data macro_econ (drop=&var._time &var._yoy); set macro_econ; 
&var._yoy = (&var._time-lag4(&var._time))/lag4(&var._time);
&var._lag0 = &var._time; &var._yoy_lag0 = &var._yoy;
&var._lag1 = lag(&var._time); &var._yoy_lag1 = lag(&var._yoy);
&var._lag2 = lag2(&var._time); &var._yoy_lag2 = lag2(&var._yoy);
&var._lag3 = lag3(&var._time); &var._yoy_lag3 = lag3(&var._yoy);
&var._lag4 = lag4(&var._time); &var._yoy_lag4 = lag4(&var._yoy); run;
%mend;

%rg_me(interest_rate);
%rg_me(hpi);
%rg_me(rgdp);
%rg_me(uer);
%rg_me(cpi);
%rg_me(oil_price);
