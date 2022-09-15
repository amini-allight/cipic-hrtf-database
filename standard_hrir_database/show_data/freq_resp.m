function [dB, sampfreqns] = freq_resp(h, fmin, fmax, Q, log_scale, NFFT, fs)
% [dB, sampfreqns] = freq_resp(h [, fmin, fmax, Q, log_scale, NFFT, fs])
% Samples the amplitude response of columns in impulse response h.
% Returns the dB values and the frequencies sampfreqns.
% Frequencies range from fmin to fmax
%              (fmin defaults to lowest non-zero discrete frequency)
%                         (fmax defaults to Nyquist frequency, fs/2)
%       (You can also use fmin = 0 and fmax = Inf to get this range)
% Smooths with a constant-Q filter             (defaults to Q = Inf)
% Uses a log_frequency scale if log_scale = 1        (defaults to 0)
% NFFT is the length of the FFT        (defaults to the length of h)
% Sampling frequency fs                       (defaults to 44.1 kHz)
% Copyright (C) 2001 The Regents of the University of California
%
% Modified by ROD to fix the case of log_scale and fmin = 0.

if nargin < 1,
    fprintf('Format: [dB, sampfreqns] = freq_resp(h [, fmin, fmax, Q, log_scale, NFFT, fs])\n');
    return;
end;

colvec = 1;
numrows = size(h,1);
numcols = size(h,2);
if numrows == 1,                   % if necessary, convert to column vector
    colvec = 0;
    h = h';
    numrows = numcols;
    numcols = 1;
end;

if nargin < 7, fs = 44100; end;
if nargin < 6, NFFT = numrows; end;
if nargin < 5, log_scale = 0; end;
if nargin < 4, Q = Inf; end;

if NFFT > numrows,                 % zero pad the impulse responses
    h = [h; zeros(NFFT-numrows, numcols)];  
    numrows = NFFT;
elseif NFFT < numrows,             % trim off the tails of the impulse responses
    h = h(1:NFFT,:);
    numrows = NFFT;
end;

nfreq = floor(numrows/2);          % DC is not counted
freqns = (0:nfreq)*(fs/(2*nfreq));
fmin0 = freqns(1);
fmax0 = freqns(end);

if nargin < 3, fmax = fmax0; end;
if nargin < 2, fmin = fmin0; end;
if fmin > fmax,
    error(['fmin = ' num2str(fmin) ' cannot exceed fmax = ' num2str(fmax)]);
end;
if fmin < fmin0, fmin = fmin0; end;
if fmax > fmax0, fmax = fmax0; end;
[junk, kfmin] = max(freqns-fmin>=0);
[junk, kfmax] = max(freqns-fmax>=0);

if Q == Inf,
    dB = abs(fft(h))+eps;
    dB = 20*log10(dB(1:nfreq+1,:));
else
    dB = hsmooth(fft(h),Q);
end;

if log_scale,
    if fmin <= 0,
        if kfmax == 1,
            error(['Cannot have fmin = ' num2str(fmin) ' with a log-frequency scale and such a small fmax']);
        end;
        kfmin = 2;  
        fmin = freqns(kfmin);
    end;
    sampfreqns = logspace(log10(fmin),log10(fmax),kfmax-kfmin+1);
    dB = interp1(freqns, dB, sampfreqns);
    if size(dB,1) == 1,
        dB = dB';   % grr; interp1 turns a column vector into a row vector
    end;
else
    dB = dB(kfmin:kfmax,:);
    sampfreqns = freqns(kfmin:kfmax);
end;
