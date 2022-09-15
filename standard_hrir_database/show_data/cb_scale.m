% Callback function for POP_SCALE popup menu
% Copyright (C) 2001 The Regents of the University of California

scale_handle = findobj(gcf,'Tag','POP_SCALE');  % Find smooth index
scale_val = get(scale_handle,'Value');

switch scale_val,
case 1              % log
   log_scale = 1;
case 2              % linear
   log_scale = 0;
otherwise
   error('Should not happen!');
end;

if start_flag,
   plot_data;
end;

