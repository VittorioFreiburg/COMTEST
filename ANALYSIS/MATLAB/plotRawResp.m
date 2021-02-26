function [figNr]=plotRawResp(Sammel,figNr,mark,legende)

zeit = [0:0.01:20];

for eye = 1:2
    if eye == 1
        eText = 'EO';
    elseif eye ==2
        eText = 'EC';
    end
    achsen = [0,20,-1.5,1.5];
    
    MW = nanmean(Sammel.eyes{eye}.rot05.stim,2);
        
    anf = 2000;
    while MW(anf)< 0
        anf = anf+1;
    end
    ende = anf+2000;

    offset = mean(MW(anf:ende));
    MW (:) = MW-offset;
    

    figure (figNr+eye-1)
    
    subplot (3,2,5)
    plot (zeit,MW(anf:ende),'k-','LineWidth',2)
    hold on
    plot (zeit,zeros(size(zeit)),'k:')
    axis(achsen)
    ylabel ('stimulus [deg]')
    ylabel ('time [sec]')
    
    
    
    MW = nanmean(Sammel.eyes{eye}.rot05.angleUB,2);
    gf1 = 3;gf2 = 41;
    MW = sgolayfilt(MW,gf1,gf2);
    SD = nanstd(Sammel.eyes{eye}.rot05.angleUB,0,2);
    
    offset = mean(MW(anf:ende));
    MW (:) = MW-offset;
    
    subplot (3,2,1)
    plot (zeit,MW(anf:ende),mark,'LineWidth',2)
    hold on
%     plot (zeit,MW(anf:ende)+SD(anf:ende),mark)
%     plot (zeit,MW(anf:ende)-SD(anf:ende),mark)
    plot (zeit,zeros(size(zeit)),'k:')
    axis(achsen)
    ylabel ('angle UB [deg]')
    title (['rotation 0.5° ',eText])
    legend(legende)%,'Location','NorthEast')
    
    MW = nanmean(Sammel.eyes{eye}.rot05.angleLB,2);
    SD = nanstd(Sammel.eyes{eye}.rot05.angleLB,0,2);
    
    offset = mean(MW(anf:ende));
    MW (:) = MW-offset;
    
    subplot (3,2,3)
    plot (zeit,MW(anf:ende),mark,'LineWidth',2)
    hold on
%     plot (zeit,MW(anf:ende)+SD(anf:ende),mark)
%     plot (zeit,MW(anf:ende)-SD(anf:ende),mark)
    plot (zeit,zeros(size(zeit)),'k:')
    axis(achsen)
    ylabel ('angle LB [deg]')
    
    % 1°Rotation
    
    MW = nanmean(Sammel.eyes{eye}.rot_1.stim,2);
        
    anf = 2000;
    while MW(anf)< 0
        anf = anf+1;
    end
    ende = anf+2000;

    offset = mean(MW(anf:ende));
    MW (:) = MW-offset;

    figure (figNr+eye-1)
    
    subplot (3,2,6)
    plot (zeit,MW(anf:ende),'k-','LineWidth',2)
    hold on
    plot (zeit,zeros(size(zeit)),'k:')
    axis(achsen)
    ylabel ('stimulus [deg]')
    ylabel ('time [sec]')
    
    
    MW = nanmean(Sammel.eyes{eye}.rot_1.angleUB,2);
    gf1 = 3;gf2 = 41;
    MW = sgolayfilt(MW,gf1,gf2);
    SD = nanstd(Sammel.eyes{eye}.rot_1.angleUB,0,2);
    
    offset = mean(MW(anf:ende));
    MW (:) = MW-offset;
    
    subplot (3,2,2)
    plot (zeit,MW(anf:ende),mark,'LineWidth',2)
    hold on
%     plot (zeit,MW(anf:ende)+SD(anf:ende),mark)
%     plot (zeit,MW(anf:ende)-SD(anf:ende),mark)
    plot (zeit,zeros(size(zeit)),'k:')
    axis(achsen)
    ylabel ('angle UB [deg]')
    title (['rotation 1° ',eText])
    
    
    
    MW = nanmean(Sammel.eyes{eye}.rot_1.angleLB,2);
    SD = nanstd(Sammel.eyes{eye}.rot_1.angleLB,0,2);
    
    offset = mean(MW(anf:ende));
    MW (:) = MW-offset;
    
    subplot (3,2,4)
    plot (zeit,MW(anf:ende),mark,'LineWidth',2)
    hold on
%     plot (zeit,MW(anf:ende)+SD(anf:ende),mark)
%     plot (zeit,MW(anf:ende)-SD(anf:ende),mark)
    plot (zeit,zeros(size(zeit)),'k:')
    axis(achsen)
    ylabel ('angle LB [deg]')
    
    
    
    
    
end









