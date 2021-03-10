function r=computePI_RC(FILE,OUT)
%takes the input file name FILE and the output file OUT as an input
MatrixIN = csvread(FILE); %open csv file
y=MatrixIN(:,1);
t=MatrixIN(:,2);
FOUT=fopen(OUT,'w');
r=RCinfo(y,t);

for [val,key] = r
fprintf(FOUT,"%s,%g\n",key,val)
end
disp(['csv saved: ', OUT])
fclose(FOUT);

