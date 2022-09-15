% Callback function for the SUBJECT_ID listbox
% This script, which must be executed first, sets start_flag to enable other actions
% Copyright (C) 2001 The Regents of the University of California

subject_handle = findobj(gcf,'Tag','SUBJECT_ID');  % Find subject index
subject_index = get(subject_handle,'Value');
subject_string = subject_numbers{subject_index};

if isempty(subject_string), return; end;

Fname = [data_path_head subject_string data_path_tail];

if exist(Fname) ~= 2,                 % Check if file exists
   set(status_handle,'String',['Data file for Subject ' subject_string ' not found']);
   set(status_handle,'BackgroundColor',[1 0.4 0.4]);
   pause(1);
   set(status_handle,'BackgroundColor',status_bkgnd_color);
   return;
end;

if exist('hrir_l') == 1,              % Save data from a previous run
   hrir_temp = hrir_l;
   clear hrir_l;
end;

load(Fname);

if exist('hrir_l') ~= 1,              % Check if data exists
   set(status_handle,'String',['File ''' Fname ''' does not contain HRTF data']);
   if exist('hrir_temp') == 1,
      hrir_l = hrir_temp;
   end;
   return;
end;

%% Check the data

name_string = strrep(name,'_',' ');   % title can't deal with underscores
if ~strcmp(subject_string, name(end-2:end)),
   msg = ['Warning: File ''' Fname ''' contains data for ' name ' ...'];
   set(status_handle,'string',msg);
   set(status_handle,'BackgroundColor',[1 0.4 0.4]);
   pause(1);
   set(status_handle,'BackgroundColor',status_bkgnd_color);
end;

if size(hrir_l,3)~=LT,
   msg = ['Warning: The data in File ''' Fname ''' contains an unexpected number of data points' ];
   set(status_handle,'string',msg);
   set(status_handle,'BackgroundColor',[1 0.4 0.4]);
   pause(1);
   set(status_handle,'BackgroundColor',status_bkgnd_color);
end;

if start_flag == 1,                 % Old data may be around
   clear cone_wav el_wav;
else
   start_flag = 1;                  % This flag enables the other scripts 
end;

%% Start the processing

set(status_handle,'string',['Processing file ' Fname ' ... ']);
plot_data;                          % Run script to plot the data
