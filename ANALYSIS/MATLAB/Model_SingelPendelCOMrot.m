function [ModelParas] = Model_SingelPendelCOMrot(Fd,TF,J,mgh,ms)

% global Fd TF J mgh ms;
ModelParas.basis.TF = TF;
ModelParas.basis.f = Fd;
ModelParas.basis.J = J;
ModelParas.basis.mass = ms;
ModelParas.basis.mgh = mgh;
save ModelParasBasis ModelParas

%% Startparameter  

ki=77;
kp=950;
kd=250;
wp=0.8;
td=0.15;
kpas=90;
bpas=60;
kt=0.01;

%% 
trialanderror = 0; 

if trialanderror==0;
    startpara=[ki kp kd wp td kpas bpas]; % J fit
    [Ki,Kp,Kd,Wp,Td,Kpas,Bpas]=FitSTN_SingelPendelCOMrot(ki,kp,kd,wp,td,kpas,bpas);


    if Wp>1; Wp=1; end
    if Ki<0; Ki=0; end%
    if Td<0.1; Td=0.1; end%


else
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
PIDTD=(Kd*(s.*s)+Kp*s+Ki).*TD;
% num=180/pi*((s.*s)-Kt*PIDTD); % stable platform, ideal Stim, i force feedb
% den=Bi.*((s.*s)-Kt*PIDTD)+PIDTD.*(Wp*s+Wg*s)+(s.*s).*(Kb*ones(size(w))+B*s);
num=Wp*PIDTD+Kpas*s+Bpas*(s.*s);              %  tilt experiment Tc vs. FS
den=s.*Bi+PIDTD+Kpas*s+Bpas*(s.*s);            %  tilt experiment Tc vs. FS

tf=num./den;

% fit error
d2=(TF-tf)./abs(TF+tf);	% normalize individual vectors by magnitude of fit at each frequency

mse=mean(d2(2:end-1).*conj(d2(2:end-1)));
[Ki,Kp/10,Kd,Wp,Td,Kpas,Bpas];
Magtf=abs(tf);		% transfer function gain
Phatf=phase(tf)*180/pi;		% transfer function phase

ModelParas.paras.all =[Ki,Kp,Kd,Wp,Td,Kpas,Bpas,mse];
ModelParas.paras.Ki = Ki; 
ModelParas.paras.Kp = Kp; 
ModelParas.paras.Kd = Kd; 
ModelParas.paras.Wp = Wp; 
ModelParas.paras.Td = Td; 
ModelParas.paras.Kpas = Kpas; 
ModelParas.paras.Bpas = Bpas; 
ModelParas.paras.mse = mse; 
ModelParas.paras.modelTF = tf; 

