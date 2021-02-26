function r = RCtransResp(BS,X)
% r = RCtransResp(BS,X)
% a variable to compare support surface translation response to the one to 
% voluntary movements and support surface tilt
% BS expressed in radiants
% X in meters
nBS = (BS-BS(0))*0.9500; % using the parameters from previous works
r=X+nBS;  