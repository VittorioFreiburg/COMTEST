function [r] = PRTScsv(FILE)
%automatic CSV to be put in OCTAVE FOLDER
S=open(FILE);
M=S.subject.eyes{1, 1}.subjMean.prts.angleCOM.trans15.mag;
PH=S.subject.eyes{1, 1}.subjMean.prts.angleCOM.trans15.pha;
F=S.subject.eyes{1, 1}.subjMean.prts.angleCOM.trans15.f;
fileID = fopen([FILE(1:end-3),'csv'],'w');
fprintf(fileID,'%12.8f , %12.8f , %12.8f\r\n',[F;M;PH]);
fclose(fileID)
r=0;
