function plotSingleSubjRaw(subject,sText,mText,rotReize,transReize,is)


sText = 'subject.eyes{eye}.reiz{rNr,wdh}.';
mText = 'LB';

for eye = 1:2
    figure(figNr-1+eye)
    for rNr = 1:9
        wdh = 1;
        eval(['data1 = ',sText,'.sponSway.COP']);  
        subplot(3,3,rNr)
        
        if rNr == 1
            loglog(data1.dftPos.f(:,35),data1.dftPos.ps(:,35),'r')
            ylabel('Power SpSw COPx Pos [cm^2]')
            xlabel('f[Hz]')
            title (datname)
            
            if not(isempty(subject.eyes{eye}.reiz{rNr,2}.data))
                wdh = 2;
                eval(['data1 = ',sText,'.sponSway.COP']);
                hold on
                loglog(data1.sponSway.dftPos.f(:,35),data1.sponSway.dftPos.ps(:,35),'g')
            end
        else

            if ismember(rNr,rotReize)
                eval(['data1 = ',sText,'.prts.angle',mText]);
                loglog(data1.rot.f,data1.rot.mag,'r')
                hold on
            end
            if ismember(rNr,transReize)
                eval(['data1 = ',sText,'.prts.',mText]);
                loglog(data1.trans.f,data1.trans.mag,'b')
                hold on
            end
            
            ylabel(['gain ',num2str(data1.reizInfo.ampRot),'° ',num2str(data1.reizInfo.ampTrans),'cm'])
            
            
        end
    end
end
