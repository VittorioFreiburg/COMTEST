function [COMx,angleCOM,hCOM] = COMcalculation(data,hh,hs)
%sData = Subject.eyes.reiz

% alte Berechnung
LBx = data(:,15);
UBx = data(:,9) - LBx;

COMx = LBx + 1/4*(UBx);
hCOM = (hh + 1/4*(hs-hh))*100;
angleCOM = 180/pi*asin((COMx)/hCOM);

