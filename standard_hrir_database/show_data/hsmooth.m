function dB = hsmooth(H,Q)
% function hsmooth(H [,Q])
% Smooths the magnitude of a transfer function
% with a simple auditory filter.
% Computes the amplitude in dB for the transfer function H,
% smoothed with a Gaussian filter with constant Q.
% If H is an array, its columns are treated as transfer functions.
% Q defaults to 8.

% Notes:
%  1.  Smooths the squared magnitude
%  2.  Q = center_frequency/half-power_bandwidth
%  3.  Scaled so that input power = output power
%  4.  Tacitly assumes a periodic extension of the spectrum

if nargin < 1,
  fprintf('Format: dB = hsmooth(H [,Q])\n');
  return;
end;
if nargin < 2,
  Q = 8;
end; 

mindB = -100;
min_mag = 10^(mindB/20);

colvec = 1;
numrows = size(H,1);
numcols = size(H,2);
if numrows == 1,      % if necessary, convert to column vector
  colvec = 0;
  H = H';
  numrows = numcols;
  numcols = 1;
end;

alpha = 2*sqrt(2*log(2));         % half-power scale factor
if rem(numrows,2) == 0,
  evencase = 1;
	npts = numrows/2 + 1;           % number from DC to Nyquist
	noffset = npts - 3;
else
  evencase = 0;
	npts = (numrows+1)/2;           % number from DC to Nyquist
	noffset = npts - 2;
end;

A = max(abs(H), min_mag);
A = A.*A;

if Q > 0,
  tau = (-(npts-1):(npts-1));	
  Asmoothed = zeros(npts,numcols);
  Asmoothed(1,:) = A(1,:);
  for k=2:npts,
    sigma = (k-1)/(alpha*Q);
    window = exp(-(0.5*tau.*tau/(sigma^2)));
		if evencase,
		  window = window(2:(2*npts-1));
		end;
    window = window/sum(window);
    Asmoothed(k,:) = window*cycshift(A,k+noffset);
  end;
else
  Asmoothed = A(1:npts,:);
end;

dB = 10*log10(Asmoothed);
if ~colvec,
  dB = dB';
end;
