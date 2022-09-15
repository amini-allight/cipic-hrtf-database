% Callback function for POP_SMOOTH popup menu
% Copyright (C) 2001 The Regents of the University of California

smooth_handle = findobj(gcf,'Tag','POP_SMOOTH');  % Find smooth index
smooth_val = get(smooth_handle,'Value');

switch smooth_val,
case 1              % on
   do_smooth = 1;
case 2              % off
   do_smooth = 0;
otherwise
   error('Should not happen!');
end;

if start_flag,
   plot_data;
end;

