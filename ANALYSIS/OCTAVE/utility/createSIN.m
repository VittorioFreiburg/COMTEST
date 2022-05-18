function out=createSIN(speed,amplitude,fname)
% OUT=createSIN(SPEED,AMPLITUDE,FILENAME)creates a csv file that can be
% used to control the platform with a sinusoidal tilt profile
% The signal has a duration of 62 s, with an initial pause of 1 second and 
% 60 seconds of stimulus with the specified amplitude 
% then goes to zero in one second
% SPEED = radiants/s for the cosine profile
% AMPLITUDE in degrees of the desired tilt
% FILENAME file name without .csv
%
%OUT returns the stimulus profile
stim=zeros(100,1);
speed=speed/100;
%speed=0.5*i*pi/200;    
stim=[stim;(sin((0:5999)*speed))']; 
fade=stim(end)*[(0.99:-0.01:0)].^2;
stim=[stim;fade'];
t=(1:length(stim))*0.01;
plot(stim);
out=stim;
writematrix([t',stim],[fname,'.csv']);