function [ppG]=GeschlechterTrennung(gender)

if strcmp(gender,'m')
   ppG = 'D:\DATA\NP\Mann\';
else    
   ppG = 'D:\DATA\NP\Frau\';
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% n�chste 2 Zeilen ins Ausf�hrende/Dateien ladende Skript kopieren

% [ppG]=GeschlechterTrennung(gender);
% 
%   eval(['save ',ppG,pp3,pp4,datname,' ',datname])              
                
