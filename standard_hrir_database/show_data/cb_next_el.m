% Callback function for NEXT_EL button
% Copyright (C) 2001 The Regents of the University of California

if start_flag ~= 1,
   blink_load_data;
   return;
end;

if Ie < LE,
   Ie = Ie + 1;
   el_handle = findobj(gcf,'Tag','POP_EL');  % Find elevation index
   set(el_handle,'Value',Ie);                % and modify it
   plot_data;
   clear el_wav;                             % Delete sound array
end;
