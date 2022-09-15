% This script refreshes plots of the horizontal data
% Copyright (C) 2001 The Regents of the University of California

if start_flag ~= 1,                   % A safety check -- should not be needed
   fprintf('\n???\nUnexpected call to hor_plot_data!  What''s up?\n???\n');
   blink_load_data;
   return;
end;

fig_han = findobj(gcf,'Tag','main_fig');              % Select figure
figure(fig_han);

subject_id_handle = findobj(gcf,'Tag','SUBJECT_ID');  % Keep user from diddling
set(subject_id_handle, 'visible', 'off');

status_handle = findobj(gcf,'Tag','STATUS');
set(status_handle,'string',['File ' Fname ' loaded;  interpolating hrir data ... (please wait) ']);

drawnow

duration = 2;
toffset = 0.2;
kshift = 10;
up_factor = 4;
num_els = size(hrir_l,2);
num_times = size(hrir_l,3);
times = ((1:num_times)-1)*1000/fs;

% EXTRACT AND INTERPOLATE HORIZONTAL-PLANE DATA

azimuths = [-80 -65 -55 -45:5:45 55 65 80];
elevations = -45:360/64:235;
el_0 = 9;
el_180 = 41;

hl_0 = squeeze(hrir_l(:,el_0,:))';    % Build the left horizontal hrir array
hl_180 = squeeze(hrir_l(:,el_180,:))';
hl = zeros(num_times, 50);
hl(:,1:13) = hl_0(:,13:25);
hl(:,14:38)= hl_180(:,end:-1:1);
hl(:,39:51) = hl_0(:,1:13);
hazs = [0:5:45 55 65 80];
szah = hazs(end:-1:1);
hazimuths = [hazs, 180-szah, 180+hazs(2:end), 360-szah];
hazimuths_int = [0:5:360];
debug = 0;
[hl_int, shiftl_int] = interp_hrir(hl, hazimuths, hazimuths_int, debug);
hl_norm = 0.99*hl_int./max(max(abs(hl_int)));

tmin = min(shiftl_int)*(1000/fs)+toffset;
tmax = tmin+duration;
ktmin = min(find(times >= tmin));
ktmax = max(find(times <= tmax));
ktrange = (ktmin:ktmax)-kshift;

hrir_l_han = findobj(gcf,'Tag','HRIR_L');      % Find axes handle
axes(hrir_l_han);                              % Activate axes
imagesc_up(hazimuths_int, times(ktrange)-times(ktmin), hl_norm(ktrange,:),...
   'auto', up_factor, up_factor);
colormap gray;
ylabel('Time (ms)','fontsize',Fsize);
zoom on
drawnow

set(hrir_l_han,'Tag','HRIR_L');                % Reset value

hr_0 = squeeze(hrir_r(:,el_0,:))';    % Build the right horizontal hrir array
hr_180 = squeeze(hrir_r(:,el_180,:))';
hr = zeros(num_times, 50);
hr(:,1:13) = hr_0(:,13:25);
hr(:,14:38)= hr_180(:,end:-1:1);
hr(:,39:51) = hr_0(:,1:13);
hazs = [0:5:45 55 65 80];
szah = hazs(end:-1:1);
hazimuths = [hazs, 180-szah, 180+hazs(2:end), 360-szah];

hazimuths_int = [0:5:360];
debug = 0;
[hr_int, shiftr_int] = interp_hrir(hr, hazimuths, hazimuths_int, debug);
hr_norm = 0.99*hr_int./max(max(abs(hr_int)));
tmin = min(shiftr_int)*(1000/fs)+toffset;
tmax = tmin+duration;
ktmin = min(find(times >= tmin));
ktmax = max(find(times <= tmax));
ktrange = (ktmin:ktmax)-kshift;

hrir_r_han = findobj(gcf,'Tag','HRIR_R');      % Find axes handle
axes(hrir_r_han);                              % Activate axes 
imagesc_up(hazimuths_int, times(ktrange)-times(ktmin), hr_norm(ktrange,:),...
   'auto', up_factor, up_factor);
colormap gray;
zoom on
drawnow

set(hrir_r_han,'Tag','HRIR_R');

%  HRTF PLOTS

[AL,Fr] = freq_resp(hl_int,Fmin*1000,Fmax*1000,Q,log_scale, NFFT, fs);
[AR,Fr] = freq_resp(hr_int,Fmin*1000,Fmax*1000,Q,log_scale, NFFT, fs);
LF = length(Fr);

hrtf_l_han = findobj(gcf,'Tag','HRTF_L');
axes(hrtf_l_han);
colormap(gray);
imagesc(hazimuths_int,Fr/1000,AL,[dBmin dBmax]);
xlabel('Azimuth (deg)','fontsize',Fsize);
ylabel('Frequency (kHz)','fontsize',Fsize);

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
   set(hrtf_l_han,'yticklabelmode','manual');
   set(hrtf_l_han,'ytick',yticks);
   set(hrtf_l_han,'yticklabel',yticklabels);
end;
set(hrtf_l_han,'FontSize',Fsize);
zoom on
drawnow

set(hrtf_l_han,'Tag','HRTF_L');                % Reset value

hrtf_r_han = findobj(gcf,'Tag','HRTF_R');
axes(hrtf_r_han);
colormap(gray);
imagesc(hazimuths_int,Fr/1000,AR,[dBmin dBmax]);
xlabel('Azimuth (deg)','fontsize',Fsize);

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
   set(hrtf_r_han,'yticklabelmode','manual');
   set(hrtf_r_han,'ytick',yticks);
   set(hrtf_r_han,'yticklabel',yticklabels);
end;
set(hrtf_r_han,'FontSize',Fsize);
zoom on;
drawnow;

set(hrtf_r_han,'Tag','HRTF_R');

status_handle = findobj(gcf,'Tag','STATUS');
set(status_handle,'string',['Data for ' Fname ]);

subject_id_handle = findobj(gcf,'Tag','SUBJECT_ID');  % Keep user from diddling
set(subject_id_handle, 'visible', 'on');


