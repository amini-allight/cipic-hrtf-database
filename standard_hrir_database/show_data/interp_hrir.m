function [h_int, shift_int] = interp_hrir(h, angles, angles_int, debug)
% [h_int, shift_int] = interp_hrir(h, angles, angles_int [, debug])
%
% Interpolates impulse responses in h by
%    (a) time aligning
%    (b) using interp2
%    (c) restoring the time alignment
% Also returns the shift needed for time alignment
%
% Assumes that h is a ntimes x nangles array
% with hazimuths (of length nangles) giving the angles for h
% and hazimuths_int giving the target angles
% Copyright (C) 2001 The Regents of the University of California

if nargin < 3,
   fprintf('Format: [h_int, shift_int] = interp_hrir(h, angles, angles_int [, debug])\n');
   return;
end;
if nargin < 4,
   debug = 0;
end;

[num_times, num_angles] = size(h);
if num_angles ~= length(angles),
   error('Wrong number of angles for the impulse response array');
end;

if size(angles,1) ~= 1,          % make sure that angles is a row vector
   angles = angles';
   if size(angles,1) ~= 1, error('angles must be a vector'); end;
end;

if size(angles_int,1) ~= 1,      % make sure that angles_int is a row vector
   angles_int = angles_int';
   if size(angles_int,1) ~= 1, error('angles_int must be a vector'); end;
end;

times = (1:num_times)';          % times is a column vector

[h_aligned, shift] = timealign(h);


shift_int = interp1(angles, shift, angles_int, 'spline');


if debug,
   clf;
   subplot(1,3,1);
   imagesc(angles, times, h_aligned);
   title('Time-aligned input');
   colormap gray;
   subplot(1,3,2);
   plot(angles, shift,'o-');
   title('Delays');
   subplot(1,3,3);
   plot(angles_int, shift_int, 'o-');
   title('Interpolated delays');
   fprintf('[Press any key ... ');
   pause;
   fprintf(']\n');
end;

h_int = interp2(angles, times, h_aligned, angles_int, times, 'cubic');
if debug,
   clf;
   subplot(1,3,1);
   imagesc(angles_int, times, h_int);
   title('Interpolated & aligned');
   subplot(1,3,2);
   imagesc(angles, times, h);
   title('Input');
   drawnow;
end;

num_angles_int = length(angles_int);
for k = 1:num_angles_int,
   h_int(:,k) = delaysinc(h_int(:,k), shift_int(k));
end;

if debug,
   subplot(1,3,3);
   imagesc(angles_int, times, h_int);
   title('Shift restored');
   fprintf('[Press any key ... ');
   pause;
   fprintf(']\n');
end;



