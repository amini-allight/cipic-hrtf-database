function play_sound_array(sound_array, fs)
% function play_sound_array(sound_array [fs])
% 
% Plays the sound data at a sampling frequency fs,
% which defaults to fs = 44100.
% Assumes that sound_array(:,1) is the left channel
% and that sound_array(:,2) is the right channel,
% and that the maximum absolute value of the values
% in sound_array is less than 1.
% Copyright (C) 2001 The Regents of the University of California

%% Check for valid arguments

if nargin < 1,
   fprintf('Format: play_sound_array(sound_array [fs])\n');
   return;
end;

if nargin < 2,
   fs = 44100;
end;

num_channels = size(sound_array,2);
if num_channels > 2,
   error('sound_array cannot have more than two channels.');
elseif num_channels == 1,
   sound_array = [sound_array sound_array];
end;


%% Use proper sound output function

switch computer,
   
case 'PCWIN'                                    % MS-windows OS
   vernum = version_number;
   if vernum < 6,
      sound_array = sound_array(:,[2,1]);       % Swap left and right channels for 5.x
   end;
   if exist('wavplay') == 2,
      wavplay(sound_array,fs,'sync');
   elseif exist('sound') == 2,
      sound(sound_array,fs);
   else
      fprintf('\n  This message should not appear.\n');
      fprintf('  Unable to find either wavplay.m or sound.m\n\n');
   end;
   
case 'LNX86'                                    % Linux Intel OS for MATLAB 5.x
   if exist('sound') == 2,
      sound(sound_array,fs);
   else
      fprintf('\n  This message should not appear.\n');
      fprintf('  Unable to find sound.m\n\n');
   end;

case 'GLNX86'                                   % Linux Intel OS for MATLAB 6 R12
   if exist('sound') == 2,
      sound(sound_array,fs);
   else
      fprintf('\n  This message should not appear.\n');
      fprintf('  Unable to find sound.m\n\n');
   end;
   
   %%%  Insert other cases here %%%
   
otherwise                                       % Unknown OS
   fprintf('\n  This message should not appear.\n');
   fprintf('  If playing sound has been enabled,\n');
   fprintf('  you need to edit play_sound_array\n');
   fprintf('  to specify how sound_array is\n');
   fprintf('  to be played.\n');
   
end;
