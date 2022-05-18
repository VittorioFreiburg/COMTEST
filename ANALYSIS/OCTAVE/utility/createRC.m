function out=createRC(speed,amplitude,fname)
% OUT=createRC(SPEED,AMPLITUDE,FILENAME)creates a csv file that can be
% used to control the platform with a raised cosine tilt profile
% 
% SPEED = radiants/s for the cosine profile
% AMPLITUDE in degrees of the desired tilt
% FILENAME file name without .csv
%
%OUT returns the stimulus profile
stim=zeros(100,1);
speed=speed/100;
%speed=0.5*i*pi/200;    
stim=[stim;0.5*amplitude*[sin(-pi/2:speed:pi/2)+1]';amplitude*ones(1000,1);0.5*amplitude*[sin(pi/2:-speed:-pi/2)+1]';zeros(1000,1);]; %#ok<NBRAK,*AGROW>
t=(1:length(stim))*0.01;
plot(stim)
out=stim
writematrix([t',stim],[fname,'.csv']);

