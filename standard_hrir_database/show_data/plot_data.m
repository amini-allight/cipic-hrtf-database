% This script refreshes plots of the data
% Copyright (C) 2001 The Regents of the University of California

% Revision history
% 8/29/01
% Added test of good_colorbar variable to fix colorbar problem with MATLAB 6.1

if start_flag ~= 1,                   % A safety check -- should not be needed
   fprintf('\n???\nUnexpected call to plot_data!  What''s up?\n???\n');
   blink_load_data;
   return;
end;

fig_han = findobj(gcf,'Tag','main_fig');
figure(fig_han)

az_val = findobj(gcf,'Tag','POP_AZ');  % Find spatial indices
Ia     = get(az_val,'Value');
el_val = findobj(gcf,'Tag','POP_EL');
Ie     = get(el_val,'Value');

% INDICES FOR CONSECUTIVE ELEVATIONS

if Ie == LE 
   IndE  = [Ie-2 Ie-1 Ie];
   sIndE = [  1    3   2];
elseif Ie == 1
   IndE  = [Ie Ie+1 Ie+2];
   sIndE = [ 2   1    3 ]; 
else
   IndE  = [Ie-1 Ie Ie+1];
   sIndE = [  1   2   3 ];
end

% TIME DOMAIN HRIR

hl = squeeze(hrir_l(Ia,:,:))';               % Normalize data [-1 1]
hr = squeeze(hrir_r(Ia,:,:))';
hl_norm = 0.99*hl./max(max(abs(hl)));
hr_norm = 0.99*hr./max(max(abs(hr)));

TINIT = [hl_norm ones(LT,1) hr_norm]';
ONSET = [OnL(Ia,:) NaN OnR(Ia,:)]./(fs/1000);
hrir_han = findobj(gcf,'Tag','HRIR');        % Find axes handle
axes(hrir_han);                              % Activate axes 
pos_aux = get(hrir_han,'Position');
colormap(gray);
imagesc((1:LE*2+1),T(miT:mxT),TINIT(:,miT:mxT)',[-1 1]);
set(hrir_han,'FontSize',Fsize);
title('LEFT EAR                                  RIGHT EAR');
ylabel('Time (ms)','fontsize',Fsize);
set(hrir_han,'xticklabelmode','manual');
set(hrir_han,'xtick',[9 25 41 60 76 92]);
set(hrir_han,'xticklabel',' ');
hold on;
plot(Ie*ones(length(T(miT:mxT)),1),T(miT:mxT),'y:');
plot((Ie+51)*ones(length(T(miT:mxT)),1),T(miT:mxT),'y:');
plot(ONSET,'y:');
hold off;
if ~exist('good_colorbar'),
    hrirbar_han = findobj(gcf,'Tag','HRIR_BAR');  % Find and activate
    colorbar(hrirbar_han);                        % colorbar handle
    set(hrirbar_han,'FontSize',Fsize);  
end;
zoom on;

% RESET VALUES 
set(hrir_han,'Tag','HRIR');
set(hrir_han,'Position',pos_aux);
set(hrirbar_han,'Tag','HRIR_BAR');

% FREQUENCY DOMAIN HRTF

if do_smooth, Q = 8; else Q = Inf; end;
[AL,Fr] = freq_resp(hl,Fmin*1000,Fmax*1000,Q,log_scale, NFFT, fs);
[AR,Fr] = freq_resp(hr,Fmin*1000,Fmax*1000,Q,log_scale, NFFT, fs);
LF = length(Fr);
FINIT = [AL dBmax*ones(LF,1) AR];
hrtf_han = findobj(gcf,'Tag','HRTF');
pos_aux = get(hrtf_han,'Position');
axes(hrtf_han);
colormap(gray);
imagesc((1:LE*2+1),Fr/1000,FINIT,[dBmin dBmax]);
xlabel('Elevation (deg)','fontsize',Fsize);
ylabel('Frequency (kHz)','fontsize',Fsize);
set(hrtf_han,'xticklabelmode','manual');
set(hrtf_han,'xtick',[9 25 41 60 76 92]);
set(hrtf_han,'xticklabel',{'0';'90';'180';'0';'90';'180'});
if log_scale,
   plot_freqs = [.0625 .125 .250 .5  1  2  4  8  16];
   yticklabels = {'0.0625';'0.125';'0.25';'0.5';'1';'2';'4';'8';'16'};
   [junk, kkmin] = max(plot_freqs-Fmin>0);
   if Fmax >= plot_freqs(end),
      kkmax = length(plot_freqs);
   else
      [junk, kkmax] = max(plot_freqs-Fmax>0);
      kkmax = kkmax-1;
   end;
   plot_freqs = plot_freqs(kkmin:kkmax);
   yticks = Fmin+((Fmax-Fmin)/log10(Fmax/Fmin))*log10(plot_freqs/Fmin)';
   yticklabels=yticklabels(kkmin:kkmax);
   set(hrtf_han,'yticklabelmode','manual');
   set(hrtf_han,'ytick',yticks);
   set(hrtf_han,'yticklabel',yticklabels);
end;
set(hrtf_han,'FontSize',Fsize);

hold on;
plot(Ie*ones(length(Fr),1),Fr/1000,'y:');
plot((Ie+51)*ones(length(Fr),1),Fr/1000,'y:');
hold off;
if ~exist('good_colorbar'),
    hrtfbar_han = findobj(gcf,'Tag','HRTF_BAR');
    colorbar(hrtfbar_han);
    set(hrtfbar_han,'FontSize',Fsize);
    good_colorbar = 1;
end;
zoom on;

% RESET VALUES 
set(hrtf_han,'Tag','HRTF');
set(hrtf_han,'Position',pos_aux);
set(hrtfbar_han,'Tag','HRTF_BAR');

% TIME and ITD DOMAIN INDIVIDUAL

itd = ITD(Ia,:)./(fs/1000);
ITD_han = findobj(gcf,'Tag','ITD');
axes(ITD_han);
plot(itd,'k');
set(ITD_han,'Tag','ITD');
grid on; zoom on;
axis([1 50 miI mxI]);
set(ITD_han,'xticklabelmode','manual');
set(ITD_han,'xtick',[9 25 41]);
set(ITD_han,'xticklabel',{'0';'Elev  90  (deg)';'180'});
set(ITD_han,'FontSize',Fsize);
ylabel('ITD  (ms)');
title(name_string);

time_han = findobj(gcf,'Tag','TIME_BOTH');
axes(time_han);
hl = squeeze(hrir_l(Ia,IndE(sIndE(2)),miT:mxT));
hr = squeeze(hrir_r(Ia,IndE(sIndE(2)),miT:mxT));
nup = 4;
npts_up = nup*length(hl);
hlup = resample(hl,nup,1);
hrup = resample(hr,nup,1);
h_scale = max(max(abs(hlup)), max(abs(hrup)));
Tup = T(miT) + (0:(npts_up-1))*(T(mxT)-T(miT))/(npts_up-4);
plot(Tup,hrup/h_scale,'r',Tup,hlup/h_scale,'b');

set(time_han,'Tag','TIME_BOTH')
grid on;
zoom on;
axis([T(miT) T(mxT) -1.05 1.05]);
set(time_han,'FontSize',Fsize);
xlabel('t (ms)');
ylabel('h (right in red)');

freqL_han = findobj(gcf,'Tag','FREQ_LEFT');
axes(freqL_han);
ALmid = AL(:,IndE(sIndE(2)));
ALlow = AL(:,IndE(sIndE(1)));
ALhi  = AL(:,IndE(sIndE(3)));
if log_scale,
   semilogx(Fr,ALmid,'r',Fr,ALlow,'b:',Fr,ALhi,'b:');
else
   plot(Fr,ALmid,'r',Fr,ALlow,'b:',Fr,ALhi,'b:');
end;

set(freqL_han,'Tag','FREQ_LEFT')
grid on;
zoom on;
axis([Fr(1) Fr(end) dBmin dBmax]);
set(freqL_han,'xticklabel',' ');
set(freqL_han,'FontSize',Fsize);
ylabel('Left H (dB)');

freqR_han = findobj(gcf,'Tag','FREQ_RIGHT');
axes(freqR_han);
ARmid = AR(:,IndE(sIndE(2)));
ARlow = AR(:,IndE(sIndE(1)));
ARhi  = AR(:,IndE(sIndE(3)));
if log_scale,
   semilogx(Fr,ARmid,'r',Fr,ARlow,'b:',Fr,ARhi,'b:');
else
   plot(Fr,ARmid,'r',Fr,ARlow,'b:',Fr,ARhi,'b:');
end;

set(freqR_han,'Tag','FREQ_RIGHT')
grid on;
zoom on;
axis([Fr(1) Fr(end) dBmin dBmax]);
set (freqR_han,'FontSize',Fsize);
xlabel('f (kHz)');
ylabel('Right H (dB)');

status_handle = findobj(gcf,'Tag','STATUS');
set(status_handle,'string',['File ' Fname ' loaded']);

return;
