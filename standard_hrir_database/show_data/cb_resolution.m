% Callback function for POP_RESOLUTION popup menu
% Copyright (C) 2001 The Regents of the University of California

resolution_handle = findobj(gcf,'Tag','POP_RESOLUTION');  % Find resolution index
resolution_val = get(resolution_handle,'Value');

switch resolution_val,
case 1              % low
   NFFT = 0.5*LT;
case 2              % med
   NFFT = LT;
case 3              % high
   NFFT = 2*LT;
otherwise
   error('Should not happen!');
end;

if start_flag,
   plot_data;
end;

