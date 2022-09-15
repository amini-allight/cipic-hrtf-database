% Script to blink a load-data message
% Copyright (C) 2001 The Regents of the University of California

set(status_handle,'string','Please select a subject first');
set(status_handle,'BackgroundColor',[1 0.4 0.4]);
pause(1);
set(status_handle,'BackgroundColor',status_bkgnd_color);
