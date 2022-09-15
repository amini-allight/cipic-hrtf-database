function y = cycshift(x,n)
% y = cycshift(x,n)
% shifts x cyclically down n places
% If x is a matrix, shifts columns 
% Copyright (C) 2001 The Regents of the University of California

if nargin < 2,
  fprintf('Format: y = cycshift(x,n)\n');
  return;
end;

if n ~= fix(n),
  fprintf('Error in cycshift; shift not an integer.\n');
  return;
end;

col_vec = 1;         % Check and convert to column vector if necessary
if size(x,1) == 1,
  col_vec = 0;
  x = x';
end;

N = size(x,1);
n = rem(n,N);
if n == 0,
  y = x;
elseif n > 0,
  y(n+1:N,:) = x(1:N-n,:);
  y(1:n,:) = x(N-n+1:N,:);
else
  n = -n;
  y(1:N-n,:) = x(n+1:N,:);
  y(N-n+1:N,:) = x(1:n,:);
end;

if ~col_vec,
  y = y';
end;


