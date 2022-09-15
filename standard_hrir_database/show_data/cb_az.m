% Callback function for POP_AZ popup menu
% Copyright (C) 2001 The Regents of the University of California

if start_flag ~= 1,
   blink_load_data;
   return;
end;

az_handle = findobj(gcf,'Tag','POP_AZ');  % Find azimuth index
Ia = get(az_handle,'Value');
plot_data;
clear cone_wav el_wav;                    % Clear sound arrays
