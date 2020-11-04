function [COMn]=COMnasa(size,weight)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COM calculation from NASA Tables
% for American Male Crewmembers of different sizes
% 
% size in cm
% input weight in kg
%       weight in lbs = kg *  2.204622622    % factor from Wikipedia
%
% nCOM = [x = AP; y = ML; z = height]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

size = 175;
weight = 77;

weight = weight * 2.204622622; % weight in lbs

COMn=[-0.035*size+0.024*weight+11.008;...
    0.021*weight+8.609;...
    0.486*size-0.014*weight-4.775];
