% Callback function for PREV_AZ button
% Copyright (C) 2001 The Regents of the University of California

if start_flag ~= 1,
   blink_load_data;
   return;
end;

if Ia > 1
   Ia = Ia - 1;
   az_handle = findobj(gcf,'Tag','POP_AZ');  % Find azimuth index
   set(az_handle,'Value',Ia);                % and modify it
   plot_data;
   clear cone_wav el_wav;                    % Delete sound array
end;
