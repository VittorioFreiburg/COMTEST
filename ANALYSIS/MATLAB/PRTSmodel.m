function PRTSmodel

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% für COM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        ms=mass; hs=h/100 ;J=70; % mass, height, moment of inertia
        mgh=ms*hs*9.81;
        TF=H31;
        Fd=f12;

    % 			ki=134.0014;kp=991.7756;kd=326.3876;wp=0.7;td=0.1454;        
                ki=80;kp=950;kd=250;wp=0.8;td=0.15;kpas=90;bpas=60;
        %         ki=100;kp=900;kd=300;wp=0.9;td=0.12;
        if trialanderror==0;
            startpara=[ki kp kd wp td kpas bpas]; % J fit
            [Ki,Kp,Kd,Wp,Td,Kpas,Bpas]=FitSTN(ki,kp,kd,wp,td,kpas,bpas);


            if Wp>1; Wp=1; end
            if Ki<0; Ki=0; end%
            if Td<0.1; Td=0.1; end%
%             Ki=100;
%             Kpas=90;
%             Bpas=60;

        else Ki=ki;Kp=kp;Kd=kd;Wp=wp;Td=td;Kpas=kpas;Bpas=bpas;
        end

        w=2*pi*Fd;
        s=j*w;
        Bi=J*s.*s-mgh*ones(size(w));
        TD=cos(w*Td)-j*sin(w*Td);
        PIDTD=(Kd*(s.*s)+Kp*s+Ki).*TD;
        num=Wp*PIDTD+Kpas*s+Bpas*(s.*s);              %  tilt experiment Tc vs. FS
        den=s.*Bi+PIDTD+Kpas*s+Bpas*(s.*s);            %  tilt experiment Tc vs. FS
    % 			num=Wp/9.81/ms*PIDTD;              %  tilt experiment Tc vs. FS
    % 			den=s+PIDTD./Bi;            %  tilt experiment Tc vs. FS
    % 		num=-PIDTD.*s.*s;           %  trans experiment Tc vs. Text
    % 		den=s.*Bi+PIDTD;            %  trans experiment Tc vs. Text
        tf=num./den;
        %
        % fit error
        %
        d2=(TF-tf)./abs(TF+tf);	% normalize individual vectors by magnitude of fit at each frequency

    % 		mse=mean(d2(3:end-3).*conj(d2(3:end-3)));
        mse=mean(d2(2:end-1).*conj(d2(2:end-1)));
        [Ki,Kp/10,Kd,Wp,Td,Kpas,Bpas];
        Magtf=abs(tf);		% transfer function gain
        Phatf=phase(tf)*180/pi;		% transfer function phase

        
        %  6+2*17
    %     efname.name=([efname.name;fname(1:16)]);

        ModelParas=([ModelParas;x1,x2,x3,subjnr,marker, amptext1,amptext3,length(ax),Ki,Kp,Kd,Wp,Td,Kpas,Bpas,mse,ms,hs]);
        [x1,x2,x3,subjnr,marker];

    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zl=zl+1;