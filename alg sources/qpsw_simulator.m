% Single use script to generate example signal for testing qpsw.
% - 1 PJVS
% - 3 digitizers
% - U & I & PJVS signal
% - multiplexer switch every 20 periods so every 1 second

clear all; close all
% Initialization %<<<1
% Variables setup %<<<2
% f - main signal frequency (Hz)
f = 5;
% A - 'sine' wave amplitude, 3 phase system
A = [10 5];
% ph - 'sine' wave phase, 3 phase system
ph = [0 0];
% fs - sampling frequency
fs = 50e3;
% L - record length
L = 6*fs;
% SL - section length (switch to switch in samples)
SL = fs;
% noise - signal noise sigma
noise = 0;
% fseg - frequency of PJVS segments
fseg = f*10;
% fm - microwave frequency
fm = 75e9;
% apply_filter - if nonzero, applies digital filter simulating sigma delta 
apply_filter = 1;
% Rs - how many samples will be removed at start of segment (samples)
Rs = 5;
% Re - how many samples will be removed at end of segment (samples)
Re = 5;

% generate time axis %<<<2
t = [0:L-1]./fs;

% generate PJVS signal %<<<2
for i = 1:length(A)
        [y_PJVS, n, Uref, Sid] = pjvs_wvfrm_generator(f, max(A), ph(1), SL, fs, noise, fseg, fm, apply_filter);
end % for i

% generate voltage/current signal %<<<2
t_UI = [0:SL-1]./fs;
y_UI = A'.*sin(2.*pi.*f.*t_UI + ph');

% S (switches) and M (setup) matrices:
S = [1:5].*SL + 1;
M = [-1  1  1 -1  2  2;...
      1 -1  2  2 -1  1;...
      2  2 -1  1  1 -1];

% concatenate signals (given by M matrix):
D(1,:) = [y_PJVS       y_UI(1, :)   y_UI(1, :)   y_PJVS       y_UI(2, :)   y_UI(2, :)];
D(2,:) = [y_UI(1, :)   y_PJVS       y_UI(2, :)   y_UI(2, :)   y_PJVS       y_UI(1, :)];
D(3,:) = [y_UI(2, :)   y_UI(2, :)   y_PJVS       y_UI(1, :)   y_UI(1, :)   y_PJVS      ];

% plotting %<<<2
colors = 'rgbk';
legc = [];
figure
hold on
% plot signal
for i = 1:rows(D)
        plot(t, D(i, :) - max(A)*2.1.*(i-1), [colors(i) '-'])
        legc{end+1} = (['Digitzer ' num2str(i)]);
end % for i
% plot switch events
minmax = ylim;
minmax(1) = minmax(1) - abs(minmax(2) - minmax(1)).*0.1;
minmax(2) = minmax(2) + abs(minmax(2) - minmax(1)).*0.1;
for i = 1:length(S)
        plot([t(S(i)) t(S(i))], minmax)
end % for i
legend(legc)
hold off

% Processing %<<<1
% split multiplexed data %<<<2
yc = qpsw_demultiplex_split(D, S, M);

% get calibration data for every quantum segment %<<<2
empty_ycal.coefs = [];
empty_ycal.exponents = [];
empty_ycal.func = [];
empty_ycal.model = [];
empty_ycal.yhat = [];
for i = 1:rows(yc)
        for j = 1:columns(yc)
                % check if quantum measurement:
                if M(i, j) < 0
                        % do calibration
                        ycal(i,j) = adc_pjvs_calibration(yc{i,j}, Sid, Uref, Rs, Re);
                else
                        ycal(i,j) = empty_ycal;
                end % if M(i, j) < 0
        end % for j = 1:columns(yc)
end % for i = 1:rows(yc)

% set calibration data for sampled data %<<<2
for i = 1:rows(ycal)
        lastcal = empty_ycal;
        firstcalfound = 0;
        for j = 1:columns(ycal)
                if isempty(ycal(i, j).coefs)
                        ycal(i, j) = lastcal;
                else
                        lastcal = ycal(i, j);
                        if firstcalfound == 0
                                % copy calibrations to previous elements:
                                for k = 1:j-1
                                        ycal(i, k) = ycal(i,j);
                                end % for k
                                firstcalfound = 1;
                        end % firstcalfound = 0
                end % isempty(ycal(i,j))
        end % for j = 1:columns(yc)
end % for i = 1:rows(yc)

% plot gains through time %<<<2
for i = 1:rows(ycal)
        for j = 1:columns(ycal)
                % for cycle because matlab has issues with indexing concatenation ([x].y)
                offsets(i,j) = ycal(i,j).coefs.v(1);
                gains(i,j) = ycal(i,j).coefs.v(2);
        end % for j = 1:columns(yc)
end % for i = 1:rows(yc)
figure
plot(gains' - 1)
title('Calculated gains (minus 1)')

% recalibrate measurements %<<<2
for i = 1:rows(yc)
        for j = 1:columns(yc)
                % recalculate values according the gain
                if M(i, j) > 0
                        % only non-quantum data
                        yc{i, j} = ycal(i, j).coefs.v(1) + yc{i, j}.*ycal(i, j).coefs.v(2);
                end % if M(i, j) > 0
        end % for j = 1:columns(yc)
end % for i = 1:rows(yc)

% finish demultiplexing %<<<2
y = qpsw_demultiplex_sew(yc, M); %<<<1

colors = 'rgbk';
legc = [];
figure
hold on
% plot signal
for i = 1:rows(y)
        plot(t, y(i, :) - max(A)*2.1.*(i-1), [colors(i) '-'])
        legc{end+1} = (['Signal ' num2str(i)]);
end % for i
% plot switch events
minmax = ylim;
minmax(1) = minmax(1) - abs(minmax(2) - minmax(1)).*0.1;
minmax(2) = minmax(2) + abs(minmax(2) - minmax(1)).*0.1;
for i = 1:length(S)
        plot([t(S(i)) t(S(i))], minmax)
end % for i
legend(legc)
hold off




% for i=1:rows(ycal);for j=1:columns(ycal);a(i,j)=~isempty(ycal(i,j).coefs);endfor;endfor;a
% get gains:
% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
