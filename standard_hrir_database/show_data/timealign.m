function [haligned, shift] = timealign(h, leadin);
% [haligned, shift] = timealign(h, [leadin]);
% 
% Time aligns the columns of the impulse response array h.
% Begins by searching backward from global peak to 20% point.
% Then looks for an earlier peak no less than 30% in size.
% Precedes the peak by leadin samples.  Note that shift can
% be fractional.
% Copyright (C) 2001 The Regents of the University of California

if nargin < 1,
   fprintf('Format: [haligned, shift] = timealign(h, [leadin])\n');
   return;
end;

if nargin < 2,
   leadin = 10;
end;

peakfactor = 0.20;
secondpeakfactor = 0.3;
upfactor = 8;
kback = leadin*upfactor;
numtimes = size(h,1);
numcases = size(h,2);
haligned = zeros(size(h));
hup = zeros(upfactor*numtimes,1);
shift = zeros(numcases,1);

for k = 1:numcases,                     % Back off from global peak
   hup = resample(h(:,k),upfactor,1);
   [hmax, kmax] = max(hup);
   kk = kmax;
   while kk > 0,
      kk = kk - 1;
      if hup(kk) < peakfactor*hmax,
         konset = kk;
         break;
      end;
   end;
   if kk == 0,
      fprintf('Error #1 in timealign: Problem finding the onset\n');
      konset = 1;
   end;
   
   [hmax2, kmax2] = max(hup(1:konset)); % Look for weaker earlier peak
   if hmax2 > secondpeakfactor*hmax,
      kk = kmax2;
      while kk > 0,
         kk = kk - 1;
         if hup(kk) < peakfactor*hmax2,
            konset = kk;
            break;
         end;
      end;
      if kk == 0,
         fprintf('Error #2 in timealign: Problem finding the onset\n');
         konset = 1;
      end;
   end;
   
   kstart = konset - kback;
   if kstart < 1,
      fprintf('Error #3 in timealign: Problem finding the onset\n');
      kstart = 1;
   end;

   hdown = resample(hup(kstart:upfactor*numtimes),1,upfactor);
   haligned(:,k) = [hdown; zeros(numtimes-length(hdown),1)];
   shift(k) = konset/upfactor;
end;
