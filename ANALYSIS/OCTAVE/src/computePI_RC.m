function r=computePI_RC(FILE,DIR)
%takes the input file name FILE and thre result directory DIR as an input
fileIN = fopen(FILE,'r'); %open csv file
fileOUT = fopen([DIR,FILE(1:end-4),'_resp.csv'],'w');


r=RCinfo(y,t)