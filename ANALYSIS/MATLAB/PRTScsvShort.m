%function [r] = PRTScsvShort(FILE)
%t
FILE='prtsShort_16.csv';
prts=16*(stim(:,2));
t=stim(:,1);

fileID = fopen(FILE,'w');
fprintf(fileID,'%12.3f , %12.5f \r\n',[t,prts]');
fclose(fileID)

