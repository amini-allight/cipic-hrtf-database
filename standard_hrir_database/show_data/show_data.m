% This script initializes the GUI for HRTF data display
% Change parameter settings only in this file
%
% Note: This program ASSUMES that show_data and all of its
%       functions are in the show_data directory, and that the
%       HRTF data arrays hrir_final.mat for the various
%       subjects are in directories named subject_xxx that are at
%       the same level in the directory tree.  You can copy the
%       various files from the CD-ROM to a hard drive, but
%       if you change the relative directory structure or rename
%       directories, show_data will not be able to find the files.
%
%       The subject numbers that appear in the listbox are
%       saved in the cell array defined in subject_numbers.m.
%       These are "compiled into" the GUI.  To change the numbers:
%         (a) edit the file subject_numbers.m as desired
%         (b) start show_data
%         (c) use either guide or propedit(gca) to change the
%             string property of the listbox uicontrol named
%             FILE_IDS to 'subject_numbers' (no quotes)
%         (d) save the results
% Copyright (C) 2001 The Regents of the University of California

% Revision history
% 8/29/01
% Added good_colorbar variable to fix colorbar problem with MATLAB 6.1
% 7/27/04
% Converted subject_numbers from a script to a function to be compatible
% with MATLAB 7.0

show_warning = 1;          % Set this to zero to turn off warning messages

%% Check system requirements

vernum = version_number;
if vernum < 5,
   if show_warning,
      fprintf('\n\nI''m sorry, show_data uses three-dimensional arrays,\n');
      fprintf('and thus needs Version 5.0 or greater of MATLAB.\n\n');
   end;
   return;
end;

%% Check OS sound output and set play_sound_flag

check_sound;

%%  Initialize globals

start_flag = 0;             % Prevents any action until data is available
log_scale  = 1;             % Default to use a logarithmic frequency scale
do_smooth  = 1;             % Default to use constant-Q smoothing

Q          = 8;             % For constant-Q smoothing, of course
fs         = 44100;         % Sampling frequency in Hz
fNy        = fs/2000;       % Nyquist frequency in kHz
Ia         = 13;            % Initial azimuth index   (0 deg)
Ie         = 9;             % Initial elevation index (0 deg)
 
A = [-80 -65 -55 -45:5:45 55 65 80];   LA = length(A);  % Azimuths
E = -45:(360/64):235;                  LE = length(E);  % Elevation
LT = 200;                                               % Number of time points
T = (0:(1/fs):((LT-1)/fs))*1000;                        % Times in ms
subject_numbers = sub_nums; % Load cell array of subject numbers from file
NFFT = LT;                  % More freq resolution if NFFT > LT, but slows computing

Fmin = 0.5; Fmax = 16;      % Min and max frequency in kHz
Tmin = 0.3; Tmax = 2.5;     % Min and max time in ms
miI =  0.0; mxI = 0.75;     % Min and max ITD in ms
miT = max(find(T<=Tmin));   % Min time index
mxT = min(find(T>=Tmax));   % Max time index
dBmin = -30;                % Lower limit for spectral plots in dB
dBmax = +20;                % Upper limit for spectral plots in dB

%% Find path to hrir data files

script_name = 'show_data.m';
data_path_head = which(script_name);   
if isempty(data_path_head),
   error(['Cannot find ' script_name '.  This should not happen!']);
end;
num_chars = length(data_path_head);
sep = data_path_head(num_chars-length(script_name));
sep_locs = findstr(sep,data_path_head);
if length(sep_locs) < 2,
   error([script_name ' cannot be at the root of the file directory tree.']);
end;
data_path_head = [data_path_head(1:sep_locs(end-1)) 'subject_'];
data_path_tail = [sep 'hrir_final.mat'];

%% Adjust the font size to the screen resolution

resolution = get(0, 'ScreenSize');
y_pixels = resolution(4);
switch y_pixels,
case 1024
   Fsize = 14;
case 768
   Fsize = 10;
case 600
   Fsize = 8;
otherwise
   if show_warning,
      fprintf('\n\n  I can handle screen resolutions of\n');
      fprintf('  800-by-600, 1024-by-768 and 1280-by-1024.\n\n');
      fprintf(['  Your resolution appears to be ' num2str(resolution(3))]);
      fprintf(['-by-' num2str(resolution(4)) '.\n']);
      fprintf('  I can try, but this may not look very pretty.\n');
      fprintf('  Alternatively, if you can reset your screen resolution,\n');
      fprintf('  quit MATLAB, reset the resolution, and try again.\n\n');
      fprintf('Press any key to continue ... ');
      pause
      fprintf('\n');
   end;
   pixels_list = [1024 768 600];      % Find best match
   [junk, kbest] = min(abs(pixels_list - y_pixels));
   pixels = pixels_list(kbest);
   switch pixels,
   case 1024
      Fsize = 14;
   case 768
      Fsize = 10;
   case 600
      Fsize = 8;
   otherwise
      error('Invalid number of pixels. This should never happen!');
   end;   
end;

%% Start the GUI

clear good_colorbar;
hrtf_display;

%% Hide the play buttons if there is no sound capability

if play_sound_flag == 0,
   play_cone_handle = findobj(gcf,'Tag','PLAY_CONE');
   set(play_cone_handle, 'visible', 'off');
   play_el_handle = findobj(gcf,'Tag','PLAY_EL');
   set(play_el_handle, 'visible', 'off');
end;

%% Backdoor to manual file specification
 
if exist('manual_selection')==1,
   subject_id_handle = findobj(gcf,'Tag','SUBJECT_ID');
   set(subject_id_handle, 'visible', 'off');
   text_subject_handle = findobj(gcf,'Tag','TEXT_SUBJECT');
   set(text_subject_handle, 'visible', 'off');
   edit_file_id_handle = findobj(gcf,'Tag','EDIT_FILE_ID');
   set(edit_file_id_handle, 'visible', 'on');
   set(edit_file_id_handle, 'FontSize', Fsize);
   clear manual_selection;
else
   subject_id_handle = findobj(gcf,'Tag','SUBJECT_ID');
   set(subject_id_handle, 'visible', 'on');
   text_subject_handle = findobj(gcf,'Tag','TEXT_SUBJECT');
   set(text_subject_handle, 'visible', 'on');
   edit_file_id_handle = findobj(gcf,'Tag','EDIT_FILE_ID');
   set(edit_file_id_handle, 'visible', 'off');
end;

%% Get parameters for status messages

status_handle = findobj(gcf,'Tag','STATUS');
status_bkgnd_color = get(status_handle,'BackgroundColor');