function delayed_sig = delaysinc(sig, ndelay)
% delayed_sig = delaysinc(sig, ndelay)
%    uses sinc interpolation to delay sig by ndelay samples,
%    where ndelay does NOT have to be an integer;
%    advances if ndelay < 0
% Copyright (C) 2001 The Regents of the University of California

if nargin < 2,
  fprintf('Format: delayed_sig = delaysinc(sig, ndelay)\n');
	return;
end;

colvec = 1;
if size(sig,1) == 1,
  colvec = 0;
	sig = sig';
end;

N = length(sig);
h = sinc((-N:N)-ndelay)';
delayed_sig = conv(sig,h);
delayed_sig = delayed_sig((N+1):2*N);

if ~colvec,
  delayed_sig = delayed_sig';
end;

