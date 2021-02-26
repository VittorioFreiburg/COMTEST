function [subjnr, subjects]= SubjNumbers (subjects,subjIni)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% derived from SubjNrGroup
% Subjectnumbers V 1
% 6.2.2008
% 
% function ermittelt die Versuchserperson basierend auf den Initialien im Dateinamen
% und ordnet ihr eine Nummer (subjnr) zu. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Subjects durchnummerieren
ll = size(subjects);

if sum(ismember(subjects,subjIni,'rows'))> 0
    for subjnr = 1:ll(1)
        if strcmp(subjects(subjnr,:),subjIni)
            break
        end
    end
else
    subjects = [subjects;subjIni];
    subjnr = ll(1)+1;       
end   
                