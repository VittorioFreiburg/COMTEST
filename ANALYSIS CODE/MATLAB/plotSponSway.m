function [figNr] = plotSponSway(subject,sText,mText,legende,figNr,errBar)

plotInfo = subject.plotInfo;
for eye = 1:2
    if isfield(subject.eyes{eye},'mean') || isfield(subject.eyes{eye},'subjMean')
        eval(['data =',sText,mText,';']);
        if eye ==1
            eText='EO';
            mfColor = 'w';
        elseif eye ==2
            eText='EC';
            mfColor = plotInfo.color;
        end

        for apml = 1:2
            % Powerspektren
            if apml == 1
                amText = 'AP';
            else
                amText = 'ML';
            end
        
%% Powerspektrum Position
            figure(figNr) 
            marker = [plotInfo.color,plotInfo.line];
    %         title (['Powerspektrum Position ',mText])

            subplot (2,2,(eye-1)*2 + apml)
            loglog(data.dftPos.f(:,apml),data.dftPos.ps(:,apml),marker)
            hold on
            % labels

            ylabel (['Power Position ',mText,' [cm^2]'])
            xlabel ('f [Hz]')
            text(0.8,0.8,[eText,' ',amText])
            axis([min(data.dftPos.f(:,1)),max(data.dftPos.f(:,1)),0.000001,10])

            if not(isempty(errBar))
                eval(['eb =',errBar,mText,'.dftPos.ps;']);
                errorbar(data.dftPos.f(:,apml),data.dftPos.ps(:,apml),eb(:,apml),eb(:,apml),plotInfo.color)
            end


            if eye==1 && apml==1;
                legend (legende)
                if not(isempty(errBar))
                    legendeEB=[];
                    ll=size(legende);
                    for i=1:ll(1)
                        legendeEB=[legendeEB;legende(i,:);legende(i,:)];
                    end
                    legend (legendeEB)
                end
            end

%% Powerspektrum Velocity
        
           figure(figNr+1) 
            marker = [plotInfo.color,plotInfo.line];

            subplot (2,2,(eye-1)*2 + apml)
            loglog(data.dftVel.f(:,apml),data.dftVel.ps(:,apml),marker)
            hold on
            % labels

            ylabel (['Power Velocity ',mText,' [cm^2]'])
            xlabel ('f [Hz]')
            text(0.8,0.8,[eText,' ',amText])
             axis([min(data.dftVel.f(:,1)),max(data.dftVel.f(:,1)),0.00001,10])

            if eye==1 && apml==1;
                legend (legende)
            end     

            if not(isempty(errBar))
                eval(['eb =',errBar,mText,'.dftVel.ps;']);
                errorbar(data.dftVel.f(:,apml),data.dftVel.ps(:,apml),eb(:,apml),eb(:,apml),plotInfo.color)
                if eye==1 && apml==1;
                    legend(legendeEB)
                end
            end




        end %apml
    
    %% Parameter
        marker = [plotInfo.color,plotInfo.marker];

        fn1=fieldnames(data.paras);
        for fn1z = 1:4
            fn1Text = cell2mat(fn1(fn1z));
            eval(['data1 = data.paras','.',fn1Text,';']); 
            eval(['pNames = data.paras.rowLabels.',fn1Text,';']);
            for pz = 1:4;
                pText = cell2mat(pNames(pz,:));
                figure(figNr+2)
                subplot(4,4,(fn1z-1)*4+pz)
                if not(isempty(errBar))
                    eval(['eb =',errBar,mText,'.paras','.',fn1Text,';']);
                    errorbar(data1(pz,2),data1(pz,1),eb(pz,1),eb(pz,1),marker,'MarkerFaceColor',mfColor)
                    hold on
                    herrorbar(data1(pz,2),data1(pz,1),eb(pz,2),eb(pz,2),marker)
                else
                    plot(data1(pz,2),data1(pz,1),marker,'MarkerFaceColor',mfColor)
                    hold on
                end


                if fn1z==1 
                    if eye ==2 && pz == 1
                        legendeEyes=[];
                        ll=size(legende);
                        for i=1:ll(1)
                            if not(isempty(errBar))
    %                             if i ==1;
    %                                 legendeEyes=[legendeEyes;legende(i,:),'   ';legende(i,:),' eo';legende(i,:),' ec';legende(i,:),'   ';legende(i,:),' eo';'line   '];
    %                             else
                                    legendeEyes=[legendeEyes;legende(i,:),'   ';legende(i,:),'   ';legende(i,:),' eo';legende(i,:),' ec';legende(i,:),'   ';legende(i,:),' eo';];
    %                             end
                            else
                                legendeEyes=[legendeEyes;legende(i,:),' eo';legende(i,:),' ec'];
                            end
                        end    
                        legend (legendeEyes)
                    end
                    title (mText)
                end
                xlabel([pText,'  ML'])
                ylabel([pText,'  AP'])
    %             axis ([0, ceil(data1(pz,1)*2),0,ceil(data1(pz,1)*2)])


             end %pz
        end %fn1z
    else
        ['no subject Means, ',plotInfo.name, ' eye=',num2str(eye)]
    end
end %eye

figNr = figNr+3;