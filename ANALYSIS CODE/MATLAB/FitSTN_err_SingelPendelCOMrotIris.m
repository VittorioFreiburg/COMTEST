%	 FitSTN_err_SingelPendelCOMrotIris.m		10-Nov-04 --> 11.6.2012function [mse,g] = FitSTN_err_SingelPendelCOMrotIris(PID_fit)g=0;ka=PID_fit(1);kp=PID_fit(2);kd=PID_fit(3);wp=PID_fit(4);td=PID_fit(5);kpas=PID_fit(6);bpas=PID_fit(7);% kpas=90;% bpas=60;% ki = 0;ki = 77;if td<0.1; td=0.1; end%if kp>1500; kp=1500; end%if kp<500; kp=500; end%if kd>800; kd=800; end%if kd<100; kd=100; end%if kpas>300; kpas=300; end%if kpas<0; kpas=0; end%if bpas>200; bpas=200; end%if bpas<0; bpas=0; end%% if ki<0; ki=0; end%if wp>1; wp=1; end%if td<0.1; td=0.1; end%load ModelParasBasisTF = ModelParas.basis.TF;Fd = ModelParas.basis.f ;J = ModelParas.basis.J;mgh = ModelParas.basis.mgh;w=2*pi*Fd;s=j*w;Bi=J*s.*s-mgh*ones(size(w));TD=cos(w*td)-j*sin(w*td);PIDTD=(ka*(s.*s.*s)+kd*(s.*s)+kp*s+ki).*TD;num=wp*PIDTD+kpas*s+bpas*(s.*s);              %  tilt experiment Tc vs. FSden=s.*Bi+PIDTD+kpas*s+bpas*(s.*s);            %  tilt experiment Tc vs. FS% num=wp*PIDTD+kpas*s+bpas*(s.*s);              %  tilt experiment Tc vs. FS% den=s.*Bi-kt*PIDTD+kpas*s+bpas*(s.*s)+wp*PIDTD;            %  tilt experiment Tc vs. FStf=num./den;d2=(TF-tf)./abs(TF+tf);	% normalize individual vectors by magnitude of fit at each frequencymse=mean(d2(2:end-1).*conj(d2(2:end-1)));