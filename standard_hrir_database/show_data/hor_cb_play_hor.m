% Callback function for PLAY_HOR
% Copyright (C) 2001 The Regents of the University of California

if start_flag ~= 1,
   blink_load_data;
   return;
end;

status_handle = findobj(gcf,'Tag','STATUS');
old_status = get(status_handle,'string');

if exist('hor_wav'), play_sound_array(hor_wav,fs); return; end;

fig_han = findobj(gcf,'Tag','main_fig');              % Select figure
figure(fig_han);

subject_id_handle = findobj(gcf,'Tag','SUBJECT_ID');  % Keep user from diddling
set(subject_id_handle, 'visible', 'off');

status_text = 'Computing the spatialized sound.  ';
status_text = [status_text '[This may take a while the first time; '];
status_text = [status_text 'please be patient ... ]'];
set(status_handle,'string',status_text);
drawnow;

hl    = hl_int';
hr    = hr_int';
fs    = 44100;                     % Sampling frequency
fm    = 30;                        % Modulation frequency
sd    = 100;                       % stimulus duration in ms
gd    = 25;                        % gap duration in ms
Insig = stimulus(fm,sd,fs);
Insig = [Insig zeros(1,round(gd/1000*fs))];
Lsig  = length(Insig);
[N,L] = size(hl);
hor_wav = zeros(N*Lsig,2);
ramp  = ones(size(Insig));
hann  = hanning(round(.05*fs));
ramp(1:round(0.025*fs)) = hann(1:round(0.025*fs));
ramp(end-round(0.025*fs)+1:end) = hann(round(0.025*fs):end);
Insig = Insig.*ramp;
for i = 1:N,
   hor_wav(((i-1)*Lsig+1):(i*Lsig),1) = filter(hl(i,:),1,Insig)';
   hor_wav(((i-1)*Lsig+1):(i*Lsig),2) = filter(hr(i,:),1,Insig)';         
end;
max_val = 1.05*max(max(abs(hor_wav)));
hor_wav = hor_wav/max_val;
play_sound_array(hor_wav,fs);

set(status_handle,'string',old_status);
set(subject_id_handle, 'visible', 'on');

