% Callback function for the EDIT_FILE_ID textbox
% This script sets start_flag to enable other actions
% Copyright (C) 2001 The Regents of the University of California

file_id_handle = findobj(gcf,'Tag','EDIT_FILE_ID');
Fname = get(file_id_handle,'String');
Fname_length = length(Fname);

if Fname_length > 4,
   if ~strcmp(lower(Fname(Fname_length-3:Fname_length)), '.mat'),
      Fname = [Fname, '.mat'];
   end;
else
   Fname = [Fname, '.mat'];
end;

if exist(Fname) ~= 2,             % check if file exists
   set(status_handle,'String',['File not found']);
   set(status_handle,'BackgroundColor',[1 0.4 0.4]);
   set(file_id_handle,'BackgroundColor',[1 0.4 0.4]);
   pause(1);
   set(status_handle,'BackgroundColor',status_bkgnd_color);
   set(file_id_handle,'BackgroundColor', [1, 1, 1]);
   return;
end;

if exist('hrir_l') == 1,          % Save data from a previous run
   hrir_temp = hrir_l;
   clear hrir_l;
end;

load(Fname);

if exist('hrir_l') ~= 1,          % Check if data exists
   set(status_handle,'String',['Not an HRTF file']);
      set(status_handle,'BackgroundColor',[1 0.4 0.4]);
   set(file_id_handle,'BackgroundColor',[1 0.4 0.4]);
   pause(1);
   set(status_handle,'BackgroundColor',status_bkgnd_color);
   set(file_id_handle,'BackgroundColor', [1, 1, 1]);
   if exist('hrir_temp') == 1,
      hrir_l = hrir_temp;
   end;
   return;
end;

name_string = strrep(name,'_',' '); % title can't deal with underscores

if start_flag == 1,                 % Old data may be around
   clear cone_wav el_wav;
else
   start_flag = 1;                  % This flag enables the other scripts 
end;

%% Start the processing

set(status_handle,'string','Processing file ...');
plot_data;                          % Run script to plot the data
