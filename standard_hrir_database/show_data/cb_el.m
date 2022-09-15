% Callback function for POP_EL popup menu
% Copyright (C) 2001 The Regents of the University of California

if start_flag ~= 1,
   blink_load_data;
   return;
end;

el_handle = findobj(gcf,'Tag','POP_EL');  % Find elevation index
Ie = get(el_handle,'Value');
plot_data;
clear el_wav;                             % Delete sound array
