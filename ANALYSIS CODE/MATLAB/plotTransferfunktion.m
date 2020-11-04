function [figNr] = plotTransferfunktion(subject,sText,mText,legende,figNr,errBar)

yMag = [0.1, 15];
yPha = [-400, 200];
plotInfo = subject.plotInfo;

for eye = 1:2
    if isfield(subject.eyes{eye},'mean') || isfield(subject.eyes{eye},'subjMean')
       
        if eye ==1
        eText='EO';
        
    elseif eye ==2
        eText='EC';
    end

        eval(['data =',sText,mText,';'])
        fn1=fieldnames(data);
        for fn1z = 1:4
            fn1Text = cell2mat(fn1(fn1z));
            if strcmp(fn1Text(1:3),'rot')
                eval(['data1 =',sText,'angle',mText,'.',fn1Text,';']);
                xAx = [0.04, 2.7];
            else
                eval(['data1 =',sText,mText,'.',fn1Text,';']);
                xAx = [0.04, 4.5];
            end
        
%% Figure Gain & Phase
            figure(figNr)
            subplot(4,4,(eye-1)*8+ fn1z) % Mag

            loglog(data1.f,data1.mag,plotInfo.combi)
            axis([xAx,yMag])
            hold on

            if not(isempty(errBar))
                if strcmp(fn1Text(1:3),'rot')
                    eval(['eb =',errBar,'angle',mText,'.',fn1Text,';']);
                else
                    eval(['eb =',errBar,mText,'.',fn1Text,';']);
                end
                mark = [plotInfo.color, plotInfo.marker];
                errorbar(data1.f,data1.mag,eb.mag,eb.mag,mark)

            end



            title ([mText,'  ',fn1Text])

            if fn1z == 1 
                ylabel('Gain')
                if eye == 1
                    if not(isempty(errBar))
                        legendeEB=[];
                        ll=size(legende);
                        for i=1:ll(1)
                            legendeEB=[legendeEB;legende(i,:);legende(i,:)];
                        end
                        legend (legendeEB)
                    else
                        legend(legende)
                    end
                end
            end


            subplot(4,4,(eye-1)*8+ fn1z+4) % Pha 

            semilogx(data1.f,data1.pha,plotInfo.combi)

            axis([xAx,yPha])
            hold on

            if not(isempty(errBar))
                if strcmp(fn1Text(1:3),'rot')
                    eval(['eb =',errBar,'angle',mText,'.',fn1Text,';']);
                else
                    eval(['eb =',errBar,mText,'.',fn1Text,';']);
                end
                mark = [plotInfo.color, plotInfo.marker];
                errorbar(data1.f,data1.pha,eb.pha,eb.pha,mark)
            end

            xlabel ('f[Hz]')
            if fn1z == 1 
                text(0.1,350,eText)
                ylabel ('Phase [°]')
            end
        
        
%% Figure Nyquist

            figure(figNr+1)
            subplot(2,4,(eye-1)*4+ fn1z) 

            plot(real(data1.tf),imag(data1.tf),plotInfo.combi)
            nAx = 3;
            axis([-nAx,nAx,-nAx,nAx])
            hold on

    %         if not(isempty(errBar))
    %             if strcmp(fn1Text(1:3),'rot')
    %                 eval(['eb =',errBar,'angle',mText,'.',fn1Text,';']);
    %             else
    %                 eval(['eb =',errBar,mText,'.',fn1Text,';']);
    %             end
    %             mark = [plotInfo.color, plotInfo.marker];
    %             errorbar(data1.f,data1.mag,eb.mag,eb.mag,mark)
    %         
    %         end

            xlabel ('real Axis (TF)')
            ylabel('imaginary Axis (TF)')
            title ([mText,'  ',fn1Text])

            if fn1z == 1 

                if eye == 1
    %                 if not(isempty(errBar))
    %                     legendeEB=[];
    %                     ll=size(legende);
    %                     for i=1:ll(1)
    %                         legendeEB=[legendeEB;legende(i,:);legende(i,:)];
    %                     end
    %                     legend (legendeEB)
    %                 else
                        legend(legende)
    %                 end
                end
            end
        
        
        
        end % fn1z =rot05-trans15
    else
        ['no subject Means, ',plotInfo.name, ' eye=',num2str(eye)]
    end 
end %eye

figNr = figNr+2;
