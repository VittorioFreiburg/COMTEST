function r=xsens2COM(varargin)
% [BS] = XSENS2COM(OUTPUT_FILE,BS_FILE)
% creates a csv file with time and COM sway from xsense angles 
% [BS] = XSENS2COM(OUTPUT_FILE,LS_FILE,TS_FILE)
% creates a csv file with time and COM sway from xsense angles 
%
% The script searches for the pitch angle in the file
%
% assumes the coluns to be like:
% PacketCounter,Roll,Pitch,Yaw
if nargin==2
  OUTPUT_FILE=varargin{1};
  LS_FILE=varargin{2};
  FR=dlmread (LS_FILE, ',', 13, 0);
  BS=FR(:,3);
  
elseif nargin==3
  OUTPUT_FILE=varargin{1};
  LS_FILE=varargin{2};
  TS_FILE=varargin{3};
  FR=dlmread (LS_FILE, ',', 13, 0);
  LS=FR(:,3);
  FR=dlmread (TS_FILE, ',', 13, 0);
  TS=FR(:,3);
  BS=LS+0.2*(TS-LS);
else 
  error ("The function expects 2 or 3 input arguments");
endif
t=[0.01*(0:(length(BS)-1))]';
t_BS=[t,BS];
csvwrite (OUTPUT_FILE, t_BS);
endfunction
