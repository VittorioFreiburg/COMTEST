OUT=['PRTS_Sample_np_PF_110208_a1_1_c_z.csv'];
DATA=np_PF_110208_a1_1_c_z.data(:,:);

hh=np_PF_110208_a1_1_c_z.info.h3;
hs=np_PF_110208_a1_1_c_z.info.h2;
LBx = DATA(:,15);
UBx = DATA(:,9) - LBx;
COMx = LBx + 1/4*(UBx);
hCOM = (hh + 1/4*(hs-hh))*100;
angleCOM = 180/pi*asin((COMx)/hCOM);
TIME=(1:length(angleCOM))*0.01;

dlmwrite(OUT,[TIME',angleCOM]);
