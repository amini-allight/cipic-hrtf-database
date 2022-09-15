% Callback function for PLAY_CONE
% Copyright (C) 2001 The Regents of the University of California

if start_flag ~= 1,
   blink_load_data;
   return;
end;

status_handle = findobj(gcf,'Tag','STATUS');
old_status = get(status_handle,'string');

if exist('cone_wav'),     
   play_sound_array(cone_wav,fs);
else
   status_text = 'Computing the spatialized sound.  ';
   status_text = [status_text '[This may take a while the first time; '];
   status_text = [status_text 'please be patient ... ]'];
   set(status_handle,'string',status_text);
   hl = squeeze(hrir_l(Ia,:,:));
   hr = squeeze(hrir_r(Ia,:,:));
   cutoff_freq = 20000;
   stimulus_dur = 200;         % duration in ms
   gap_dur = 100;              % duration in m
   cone_wav = play_stimulus(hl,hr,cutoff_freq,stimulus_dur,gap_dur);
   set(status_handle,'string',old_status);
end;
