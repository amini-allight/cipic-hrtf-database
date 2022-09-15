function out = play_stimulus(hl,hr,fc,sd,gd,fs)
% Routine to synthesize and play binaural sound
%
% function out = play_stimulus(hl,hr,fc,sd,gd [,fs])
%    hl and hr = 2-D hrir data
%           sd = stimulus duration in ms
%           gd = gap duration in ms
%           fc = cut-off frequency of stimulus
% Copyright (C) 2001 The Regents of the University of California

if nargin < 5,
   fprintf('Format: out = play_stimulus(hl,hr,fc,sd,gd [,fs])\n');
   return;
end;

if nargin < 6, fs = 44100; end;
fm    = 30;                        % Modulation frequency (Hz)
Insig = stimulus(fm,sd,fs);
Insig = [Insig zeros(1,round(gd/1000*fs))];

Lsig  = length(Insig);
[N,L] = size(hl);
out   = zeros(N*Lsig,2);
ramp  = ones(size(Insig));
hann  = hanning(round(.05*fs));
ramp(1:round(0.025*fs)) = hann(1:round(0.025*fs));
ramp(end-round(0.025*fs)+1:end) = hann(round(0.025*fs):end);
Insig = Insig.*ramp;

if fc < 19000,                     % Low-pass filter the stimulus
   [B,A] = butter(20,fc/(fs/2));
   Insig = filtfilt(B,A,Insig);
end;

for i = 1:N,
   out(((i-1)*Lsig+1):(i*Lsig),1) = filter(hl(i,:),1,Insig)';
   out(((i-1)*Lsig+1):(i*Lsig),2) = filter(hr(i,:),1,Insig)';
end;

max_val = 1.05*max(max(abs(out)));
out = out/max_val;                 % scale
play_sound_array(out,fs);
