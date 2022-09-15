function s = stimulus(fm,T,fs)
% function s = stimulus(fm,T [,fs])
%
% Stimulus generation program.
% Produces white noise amplitude modulated at a rate fm (in Hz)
% with duration T (in miliseconds) and sampling rate fs (in Hz).
% Extends duration (if needed) to complete the last modulation cycle.
% Copyright (C) 2001 The Regents of the University of California

if nargin < 2,
   fprintf('Format: s = stimulus(fm,T [,fs])\n');
   return;
end;
if nargin < 3, fs = 44100; end;

T = fix(fm*(T/1000)+0.9999)/fm;    % Extend duration for an integer
L = round(fs*T);                   % number of modulation cycles
x = 0:L-1;
m = 0.5*(1-cos(2*pi*x*fm/fs));
r = randn(1,L);
s = r.*m;
