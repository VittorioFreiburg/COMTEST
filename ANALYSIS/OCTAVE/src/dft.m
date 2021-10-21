function [y,f]=dft(x,Fs,fpts)
%
%  [y,f]=dft(x,Fs,fpts)
%
%  DFT - Computes a brute force discrete Fourier transform of the
%  input time series.  The output y is scaled so that a unit
%  time domain sinusoid corresponds to a unit amplitude in
%  the frequency domain.
% 
%	x = input time series (a column vector)
%	Fs = sampling frequency of time series (pts/sec)
%	fpts = number of frequency points to calculate beginning
%		   with the fundamental
%
%	y = Fourier coefficients (complex numbers)
%	f = frequency (Hz)
%
sz=size(x);
tpts=max(size(x));		% # time series sample points
%x=detrend(x);			% take out any linear trend
if sz(2)>sz(1)
  x=x';
end
t=((0:(tpts-1))/Fs)';	% time (column vector)
w=2*pi*Fs/tpts			% fundamental frequency
for n=1:fpts			% loop through frequencies
	c=cos(n*w*t);
	s=sin(n*w*t);
% disp(['size c ',num2str(size(c)) ]);
%    disp(['size x ',num2str(size(x)) ]);
	y(n)=(x'*c-i*x'*s)*2/tpts;	% real & imag Fourier coefficients
	f(n)=w*n/(2*pi);
end
