% Callback function for PLAY_EL
% Copyright (C) 2001 The Regents of the University of California

if start_flag ~= 1,
   blink_load_data;
   return;
end;

status_handle = findobj(gcf,'Tag','STATUS');
old_status = get(status_handle,'string');
if exist('el_wav'),     
   play_sound_array(el_wav,fs);   
else
   set(status_handle,'string','Computing the spatialized sound ...');
   hl = squeeze(hrir_l(Ia,IndE,:));
   hr = squeeze(hrir_r(Ia,IndE,:));
   cutoff_freq = 20000;
   stimulus_dur = 250;         % duration in ms
   gap_dur = 150;              % duration in ms
   el_wav = play_stimulus(hl,hr,cutoff_freq,stimulus_dur,gap_dur);
   set(status_handle,'string',old_status);
end;
