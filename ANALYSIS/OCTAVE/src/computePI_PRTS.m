function r=computePI_PRTS(FILE,OUT)
%takes the input file name FILE and the output file OUT as an input
MatrixIN = csvread(FILE); %open csv file
t=MatrixIN(:,1);
y=MatrixIN(:,2);
%y=MatrixIN(:,3);
FOUT=fopen(OUT,'w');
r=PRTSResp(y,t);

for [val,key] = r
fprintf(FOUT,"%s,%g\n",key,val)
end
disp(['csv saved: ', OUT])
fclose(FOUT);

