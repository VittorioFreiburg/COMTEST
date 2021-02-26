function [ModelParas] = Model_SingelPendelCOMrot(Fd,TF,J,mgh,ms)

% global Fd TF J mgh ms;
ModelParas.basis.TF = TF;
ModelParas.basis.f = Fd;
ModelParas.basis.J = J;
ModelParas.basis.mass = ms;
ModelParas.basis.mgh = mgh;
save ModelParasBasis ModelParas

%% Startparameter  

ka=2;
ki=77;
kp=950;
kd=250;
wp=0.8;
td=0.15;
kpas=90;
bpas=60;
kt=0.001;

%% 
trialanderror = 0; 

if trialanderror==0;
    startpara=[ka kp kd wp td kpas bpas]; % J fit
    [Ka,Kp,Kd,Wp,Td,Kpas,Bpas]=FitSTN_SingelPendelCOMrotIris(ka,kp,kd,wp,td,kpas,bpas);


    if Wp>1; Wp=1; end
%     if Ki<0; Ki=0; end%
    Ki=77;%
%     Ki=0;%
    if Td<0.1; Td=0.1; end%
    if Kp>1500; Kp=1500; end%
    if Kp<500; Kp=500; end%
    if Kd>800; Kd=800; end%
    if Kd<100; Kd=100; end%
    if Kpas>300; Kpas=300; end%
    if Kpas<0; Kpas=0; end%
    if Bpas>200; Bpas=200; end%
    if Bpas<0; Bpas=0; end%


else
    Ka=ka;
    Ki=ki;
    Kp=kp;
    Kd=kd;
    Wp=wp;
    Td=td;
    Kpas=kpas;
    Bpas=bpas;
end

w=2*pi*Fd;
s=j*w;
Bi=J*s.*s-mgh*ones(size(w));
TD=cos(w*Td)-j*sin(w*Td);
PIDTD=(Ka*(s.*s.*s)+Kd*(s.*s)+Kp*s+Ki).*TD;
num=Wp*PIDTD+Kpas*s+Bpas*(s.*s);              %  tilt experiment Tc vs. FS
den=s.*Bi+PIDTD+Kpas*s+Bpas*(s.*s);            %  tilt experiment Tc vs. FS
% num=Wp*PIDTD+Kpas*s+Bpas*(s.*s);              %  tilt experiment Tc vs. FS
% den=s.*Bi-Kt*PIDTD+Kpas*s+Bpas*(s.*s)+Wp*PIDTD;            %  tilt experiment Tc vs. FS

tf=num./den;

% fit error
d2=(TF-tf)./abs(TF+tf);	% normalize individual vectors by magnitude of fit at each frequency

mse=mean(d2(2:end-1).*conj(d2(2:end-1)));
[Ki,Kp/10,Kd,Wp,Td,Kpas,Bpas];
Magtf=abs(tf);		% transfer function gain
Phatf=phase(tf)*180/pi;		% transfer function phase

ModelParas.paras.all =[Ka,Kp,Kd,Wp,Td,Kpas,Bpas,mse];
ModelParas.paras.Ki = Ka; 
ModelParas.paras.Kp = Kp; 
ModelParas.paras.Kd = Kd; 
ModelParas.paras.Wp = Wp; 
ModelParas.paras.Td = Td; 
ModelParas.paras.Kpas = Kpas; 
ModelParas.paras.Bpas = Bpas; 
ModelParas.paras.mse = mse; 
ModelParas.paras.modelTF = tf; 

