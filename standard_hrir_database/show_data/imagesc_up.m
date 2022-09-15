function handle = imagesc_up(X, Y, C, CLIM, up_rows, up_cols, contours);
% handle = imagesc_up(X [, Y, C, CLIM, up_rows, up_cols, contours]);
%
% With one argument, this is the same as imagesc, with X the image.
% With three arguments, this is the same as imagesc(X, Y, C).
% With four arguments, this is the same as imagesc(X, Y, C, CLIM).
% With five or six arguments, it upsamples C before displaying.
% With seven arguments, adds contour lines.
%
% Notes:
%  1. If you want to upsample without specifing CLIM, use CLIM = 'auto'.
%  2. Unfortunately, if you want contours, you can't use X and Y.
% Copyright (C) 2001 The Regents of the University of California

if nargin < 1,
   fprintf('Format: handle = imagesc_up(X [, Y, C, CLIM, up_rows, up_cols, contours]);\n');
   return
end;

if nargin == 1,
   handle = imagesc(X);
   return;
end;

if nargin == 2,
   error('imagesc cannot have two arguments.');
end;

if nargin == 3,
   handle = imagesc(X, Y, C);
   return;
end;

if nargin == 4,
   if strcmp(CLIM, 'auto'),
      handle = imagesc(X, Y, C);
   else
      handle = imagesc(X, Y, C, CLIM);
   end;
   return;
end;

if nargin == 5,
   up_cols = up_rows;
end;

if ((up_rows == 1) & (up_cols == 1)),
   if strcmp(CLIM, 'auto'),
      handle = imagesc(X, Y, C);
   else
      handle = imagesc(X, Y, C, CLIM);
   end;
   return;
end;

if (up_rows ~= round(up_rows)) | (up_cols ~= round(up_cols)),
   error('imagesc_up requires integer upsampling.'),
elseif (up_rows < 1) | (up_cols < 1),
   error('imagesc_up cannot downsample.'),
elseif (up_rows > 16) | (up_cols > 16),
   error('imagesc_up balks at upsampling more than 16 times.');
end;

if nargin < 7,
   contours = [];
end;

%C = resample(C', up_cols, 1);  simple, but bad edge effects
%C = resample(C', up_rows, 1);  simple, but bad edge effects

num_rows = size(C, 1);
num_cols = size(C, 2);

Cup = zeros(num_rows, up_cols*num_cols);
for k = 1:num_rows,
   Cup(k, :) = interp(C(k,:), up_cols);
end;
Cupup = zeros(up_rows*num_rows, up_cols*num_cols);
for k = 1:up_cols*num_cols,
   Cupup(:, k) = interp(Cup(:, k), up_rows);
end;

if isempty(contours),
   if strcmp(CLIM, 'auto'),
      handle = imagesc(X, Y, Cupup);
   else
      handle = imagesc(X, Y, Cupup, CLIM);
   end;
else
   if strcmp(CLIM, 'auto'),
      handle = imagesc(Cupup);
   else
      handle = imagesc(Cupup, CLIM);
   end;
   hold on;
   contour(Cupup, contours, 'k');
   hold off;
end;
