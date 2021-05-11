function r=computePI_PRTS(FILE,OUT,yaml = 1)
%takes the input file name FILE and the output file OUT as an input
MatrixIN = csvread(FILE); %open csv file
t=MatrixIN(:,1);
y=MatrixIN(:,2);
%y=MatrixIN(:,3);
FOUT=fopen(OUT,'w');
r=PRTSinfo(y,t);

if (yaml==1) %default
 L=length(fieldnames(r));

 fprintf(FOUT,"type: 'scalar'\n")
 fprintf(FOUT,"label: [score]\n");
 fprintf(FOUT,"value: ["); 
 fprintf(FOUT,"%g",r.score)
 fprintf(FOUT,"]\n");  
 disp(['yaml saved: ', OUT])
 fclose(FOUT);

 else % csv output  

for [val,key] = r
fprintf(FOUT,"%s,%g\n",key,val)
end
disp(['csv saved: ', OUT])
fclose(FOUT);
end
