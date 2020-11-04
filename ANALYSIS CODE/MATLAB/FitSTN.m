%	FitSTN.m		13-Nov-06%%	Inputs:%		ki = initial fit guess (units = N m/deg s)%		kp = initial fit guess (units = N m/deg)%		kd = initial fit guess (units = N m s/deg)%		wp,wg,wv = initial fit guess (no units)%		td = initial fit guess (units = s)%function [Ki,Kp,Kd,Wp,Td,Kpas,Bpas]=FitSTN(ki,kp,kd,wp,td,kpas,bpas);global Fd TF J mgh ms;PID_fit=[ki kp kd wp td kpas bpas];					% J fit% [PID_fit,options]=constr('FitSTN_err',PID_fit,options,fit_lb,fit_ub);%  PID_fit=fmincon('FitSTN_err',PID_fit,[],[],[],[],fit_lb,fit_ub);PID_fit=fminsearch('FitSTN_err',PID_fit);Ki=PID_fit(1);Kp=PID_fit(2);Kd=PID_fit(3);Wp=PID_fit(4);Td=PID_fit(5);Kpas=PID_fit(6);Bpas=PID_fit(7);