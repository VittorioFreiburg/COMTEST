function [rNr,reizNr] = reizNummer (ampRot,ampTrans,platext,x3,datname,check)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stimulusnummer ermitteln
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


reizAmp= [  0    0
            0.5  0
            1    0
            0    0.8
            0.5  0.8
            1    0.8
            0    1.5
            0.5  1.5
            1    1.5 ];


diffTab (:,1)= abs(reizAmp(:,1)- ampRot);
diffTab (:,2)= abs(reizAmp(:,2)- ampTrans);
diffTab (:,3)= diffTab (:,1) + diffTab (:,2);

for idx = 1:9
    if diffTab(idx,3)==min(diffTab (:,3))
        rNr = idx;
        break
    end
end

%%%%%%%%%%% Fehler %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if check == 1
    if x3==0
        x3 = 1;
    end
    if rNr ~= x3
       display ([datname,' Falscher Ordner? b',num2str(x3)])
    end

    if  platext >0.1 && rNr == 1 
        display ([datname,' Plattformauslenkung: ',num2str(platext),'   Achtung!!! Plattformbewegung ohne Reiz'])
        pause
    end

    if rNr > 1 && platext <0.1 
        display ([datname,' Reizgennummer = ',num2str(rNr),'  Achtung!!! Plattform hat sich nicht bewegt oder Optotrak war aus'])
        ampRot_ampTrans_ampPlattformX3= [ampRot    ampTrans    platext    x3]
        %%rNr = getReiznummer(1)???
        pause
        if rNr ~= x3
            rNr = x3;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if rNr == 0;
    reizNr = 10;
else
    reizNr = rNr;
end
