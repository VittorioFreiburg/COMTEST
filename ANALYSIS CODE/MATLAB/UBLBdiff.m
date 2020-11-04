function [UBLB_diff,LBxUB] = UBLBdiff(data)

%% Differenz UB minus LB

UBLB_diff.rot.tf = data.angleUB.rot.tf - data.angleLB.rot.tf;
UBLB_diff.rot.f = data.angleUB.rot.f;
UBLB_diff.rot.mag = abs (UBLB_diff.rot.tf);
UBLB_diff.rot.pha = phase (UBLB_diff.rot.tf)*180/pi;
% UBLB_diff.rot.mag = data.angleUB.rot.mag - data.angleLB.rot.mag;
% UBLB_diff.rot.pha = data.angleUB.rot.pha - data.angleLB.rot.pha;

% figure
% plot(data.angleUB.rot.mag,'r')
% hold on
% plot(data.angleLB.rot.mag,'g')
% plot(data.angleUB.rot.mag-data.angleLB.rot.mag,'b')
% plot(UBLB_diff.rot.mag,'k:')


UBLB_diff.trans.tf = data.UB.trans.tf - data.LB.trans.tf;
UBLB_diff.trans.f = data.UB.trans.f;
UBLB_diff.trans.mag = abs (UBLB_diff.trans.tf);
UBLB_diff.trans.pha = phase (UBLB_diff.trans.tf)*180/pi;


%% UB Transferfunktion  im Verhältnis zum LB 
% Kreuzspektrum

LBUB = conj(data.angleLB.rot.tf).*data.angleUB.rot.tf;    % raw cross power spectra
LBps = conj(data.angleLB.rot.tf).*data.angleLB.rot.tf;     % raw input power spectra
UBps = conj(data.angleUB.rot.tf).*data.angleUB.rot.tf;     % raw output power spectra

LBxUB.rot.tf = LBUB./LBps; 
LBxUB.rot.f = data.angleUB.rot.f;
LBxUB.rot.mag = abs (LBxUB.rot.tf);
LBxUB.rot.pha = phase (LBxUB.rot.tf)*180/pi;


LBUB = conj(data.LB.trans.tf).*data.UB.trans.tf;    % raw cross power spectra
LBps = conj(data.LB.trans.tf).*data.LB.trans.tf;     % raw input power spectra
UBps = conj(data.UB.trans.tf).*data.UB.trans.tf;     % raw output power spectra

LBxUB.trans.tf = LBUB./LBps; 
LBxUB.trans.f = data.angleUB.trans.f;
LBxUB.trans.mag = abs (LBxUB.trans.tf);
LBxUB.trans.pha = phase (LBxUB.trans.tf)*180/pi;