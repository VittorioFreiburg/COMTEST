function r=computePI_SIN(FILE,OUT)
%takes the input file name FILE and the output file OUT as an input
MatrixIN = csvread(FILE); %open csv file
t=MatrixIN(:,1);
u=MatrixIN(:,2);
y=MatrixIN(:,3);
FOUT=fopen(OUT,'w');
r=sinResp(u,y,t);

for [val,key] = r
fprintf(FOUT,"%s,%g\n",key,val)
end
disp(['csv saved: ', OUT])
fclose(FOUT);

