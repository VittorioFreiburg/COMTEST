function r=computePI_PRTS(FILE_IN, FOLDER_OUT, yaml = 1)
%takes the input file name FILE_IN and the output folder FOLDER_OUT as an input
MatrixIN = dlmread (FILE, ',', 1, 0); %open csv file
t=MatrixIN(:,1);
y=MatrixIN(:,2);
%y=MatrixIN(:,3);


r=PRTSinfo(y,t);

if (yaml==1) %default
  L=length(fieldnames(r));

  % generating the name of the file that will contain results
  file_result = strcat(FOLDER_OUT,"/pi_prts_sway.yaml");

  FOUT=fopen(file_result,'w');
  fprintf(FOUT,"type: 'scalar'\n")
  fprintf(FOUT,"label: [score]\n");
  fprintf(FOUT,"value: [");
  fprintf(FOUT,"%g",r.score)
  fprintf(FOUT,"]\n");
  disp(['yaml saved: ', file_result])
  fclose(FOUT);

  file_result = strcat(FOLDER_OUT,"/pi_prts_frf.yaml");

  FOUT=fopen(file_result,'w');
  fprintf(FOUT,"type: 'vector'\n")
  fprintf(FOUT,"label: [FRF]\n");
  fprintf(FOUT,"value: [");
  for k=1:10
    fprintf(FOUT,"%g",r.FRF(k,1))
    imgc=r.FRF(k,2);
    if imgc<0
      fprintf(FOUT,"-%gj, ",abs(imgc))    
    else
      fprintf(FOUT,"+%gj, ",abs(imgc))  
    end
  end
  fprintf(FOUT,"%g",r.FRF(11,1))
  imgc=r.FRF(11,2);
  if imgc<0
    fprintf(FOUT,"-%gj",abs(imgc))    
  else
    fprintf(FOUT,"+%gj",abs(imgc))  
  end
  fprintf(FOUT,"]\n");
  disp(['yaml saved: ', file_result])
  fclose(FOUT);
else % csv output
  % generating the name of the file that will contain results
  file_result = strcat(FOLDER_OUT,"/pi_prts_sway.csv");
  FOUT=fopen(file_result,'w');

  for [val,key] = r
  fprintf(FOUT,"%s,%g\n",key,val)
  end
  disp(['csv saved: ', file_result])
  fclose(FOUT);
end
