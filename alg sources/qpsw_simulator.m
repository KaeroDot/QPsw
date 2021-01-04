% Single use script to generate example signal for testing qpsw.
% - 1 PJVS
% - 3 digitizers
% - U & I & PJVS signal
% - multiplexer switch every 20 periods so every 1 second

clear all; close all
% Variables setup %<<<1
% f - main signal frequency (Hz)
f = 50;
% A - 'sine' wave amplitude, 3 phase system
A = [10 9];
% ph - 'sine' wave phase, 3 phase system
ph = [0 0];
% fs - sampling frequency
fs = 50e3;
% L - record length
L = 6*fs;
% SL - section length (swtich to switch in samples)
SL = fs;
% noise - signal noise sigma
noise = 0;
% fseg - frequency of PJVS segments
fseg = f*20;
% fm - microwave frequency
fm = 75e9;
% apply_filter - if nonzero, applies digital filter simulating sigma delta 
apply_filter = 1;

% generate time axis %<<<1
t = [0:L-1]./fs;

% generate PJVS signal %<<<1
for i = 1:length(A)
        [y_PJVS(i, :), n(i, :), Uref(i, :), Sid(i, :)] = pjvs_wvfrm_generator(f, max(A), ph(1), SL, fs, noise, fseg, fm, apply_filter);
end % for i

% generate voltage/current signal %<<<1
t_UI = [0:SL-1]./fs;
y_UI = A'.*sin(2.*pi.*f.*t_UI + ph');

% concatenate signals:
D(1,:) = [y_PJVS(1, :) y_UI(1, :)   y_UI(1, :)   y_PJVS(2, :) y_UI(2, :)   y_UI(2, :)];
D(2,:) = [y_UI(1, :)   y_PJVS(2, :) y_UI(2, :)   y_UI(2, :)   y_PJVS(1, :) y_UI(1, :)];
D(3,:) = [y_UI(2, :)   y_UI(2, :)   y_PJVS(1, :) y_UI(1, :)   y_UI(1, :)   y_PJVS(2, :)];

% plotting %<<<1
colors = 'rgbk';
figure
hold on
for i = 1:rows(D)
        plot(t, D(i, :) - max(A)*2.1.*(i-1), [colors(i) '-'])
        legc{end+1} = (['Digitzer ' num2str(i)]);
end % for i
legend(legc)
hold off
