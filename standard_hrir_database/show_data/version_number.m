function vernum = version_number()
% function vernum = version_number()
% 
% Returns the version number of MATLAB as a number
% Copyright (C) 2001 The Regents of the University of California

if exist('version') ~= 5,
   vernum = 0;    % shouldn't happen
   return
end;

ver_string = version;
if isempty(ver_string),
   vernum = 0;    % shouldn't happen
   return;
end;

loc_dots = findstr(ver_string,'.');

if length(loc_dots) < 2,
   vernum = str2num(ver_string);
else
   vernum = str2num(ver_string(1:loc_dots(2)-1));
end;

