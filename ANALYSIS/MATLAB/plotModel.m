function [figNr] = plotModel(subject,sText,mText,legende,figNr,errBar)

plotInfo = subject.plotInfo;
legendeG = [];
lll = size(legende);

for eye = 1:2
    if isfield(subject.eyes{eye},'mean') || isfield(subject.eyes{eye},'subjMean')
        if eye ==1
            eText='EO';
        elseif eye ==2
            eText='EC';
        end

        eval(['data =',sText,';'])
        fn1=fieldnames(data);
        for fn1z = 1:2
            fn1Text = cell2mat(fn1(fn1z));
            eval(['paras =',sText,'.',fn1Text,'.paras;']);
            eval(['meanTF =',sText,'.',fn1Text,'.basis.TF;']);
            eval(['freqs =',sText,'.',fn1Text,'.basis.f;']);

            if fn1z == 1
               gColor = 'c';
            else
               gColor = 'b';
            end
            

%% Figure Nyquist

        
            mark = [plotInfo.color,plotInfo.marker];

            figure(figNr)
            subplot(2,2,(eye-1)*2+fn1z) 

            title ([fn1Text,'  ',eText])
            plot(real(paras.modelTF),imag(paras.modelTF),mark,'MarkerFaceColor',plotInfo.color)
            hold on
            plot(real(meanTF),imag(meanTF),plotInfo.combi)
            nAx = 3;
            axis([-nAx,nAx,-nAx,nAx])


            xlabel ('real Axis (TF)')
            ylabel('imaginary Axis (TF)')

            if fn1z == 1 
                if eye == 1
                    legendeNy=[];
                    ll=size(legende);
                    for i=1:ll(1)
                        legendeNy=[legendeNy;legende(i,:),' Model';legende(i,:),' Mean ';legende(i,:),' Model';legende(i,:),' Mean ';legende(i,:),' Model';legende(i,:),' Mean '];
                    end
                    legend (legendeNy)
                end
            end

%% Figure Ki,Kp,Kd,Wp,Td,Kpas,Bpas
            fn2=fieldnames(paras);
            for fn2z = 2:8
                fn2Text = cell2mat(fn2(fn2z));
                figure(figNr+1)
                subplot(2,7,(eye-1)*7+ fn2z-1)

                eval(['data1 = paras.',fn2Text,';'])
                hold on

                if not(isempty(errBar))
                    eval(['eb =',errBar,fn1Text,'.paras.',fn2Text,';']);
                    errorbar(fn1z+0.1*lll(1),data1,eb,eb,mark)
                else
                    plot(fn1z+0.1*lll(1),data1,mark)
        %         axis([xAx,yMag])
                end
                ylabel(fn2Text)
                xlabel ('rotation [deg]')
                title (eText)


                if fn2z == 2
                    text(0.1,350,eText)    
                    if eye == 1
                        if not(isempty(errBar))
                            legendeEB=[];
                            ll=size(legende);
                            for i=1:ll(1)
                                legendeEB=[legendeEB;legende(i,:);legende(i,:)];
                            end
                            legend (legendeEB)
                        else
                            legende2=[];
                            ll=size(legende);
                            for i=1:ll(1)
                                legende2=[legende2;legende(i,:);legende(i,:)];
                            end
                            legend(legende2)
                        end
                    end
                end
            end
%% Figure TF vs tf       
% subjMean rot05 & rot_1 EO EC
% real & imag getrennt
% alle Frequenzen
            markF = ['k>';'r+';'g*';'mv';'bo';'yh';'c^';'k.';'r<';'gp';'ms'];
            legendeFF = ['0.05Hz'; '0.15Hz'; '0.30Hz'; '0.40Hz'; '0.55Hz'; '0.70Hz'; '0.90Hz'; '1.10Hz'; '1.35Hz'; '1.75Hz'; '2.20Hz'];

            for ff = 1:11
                figure (figNr+2);
                subplot(2,2,(eye-1)*2+fn1z) 

                title ([fn1Text,'  ',eText])
                plot(real(meanTF(ff)),real(paras.modelTF(ff)),markF(ff,:))
                hold on
                xlabel ('real meassured TF')
                ylabel ('real modelled TF')
                axis([-2,5,-2,5])

                if eye == 1 && fn1z ==1
                    legend (legendeFF)
                end

                figure (figNr+3);
                subplot(2,2,(eye-1)*2+fn1z) 

                title ([fn1Text,'  ',eText])
                plot(imag(meanTF(ff)),imag(paras.modelTF(ff)),markF(ff,:))
                hold on
                xlabel ('imag meassured TF')
                ylabel ('imag modelled TF')
                axis([-5,3,-5,3])

                if eye == 1 && fn1z ==1
                    legend (legendeFF)
                end
            end

            %% figure nur groupmeans alle in eine Figure
            if not(isfield(subject,'reiz'))

                markG = [gColor,plotInfo.marker];
                gFill = 'w';
                if eye == 2
                    gFill = gColor;
                end

                figure (figNr+4)
                subplot (2,1,1) 
                plot(real(meanTF),real(paras.modelTF),markG,'MarkerFaceColor',gFill)
                hold on
                xlabel ('real meassured TF')
                ylabel ('real modelled TF')
                axis([-2,5,-2,5])

                legendeG = [legendeG;fn1Text,'  ',eText];
                legend(legendeG)

                subplot (2,1,2) 
                plot(imag(meanTF),imag(paras.modelTF),markG,'MarkerFaceColor',gFill)
                hold on
                xlabel ('imag meassured TF')
                ylabel ('imag modelled TF')
                axis([-5,3,-5,3])

            end

        end % fn1z =rot05-trans15
    else
        ['no subject Means, ',plotInfo.name, ' eye=',num2str(eye)]
    end
end %eye

figNr = figNr+5;
