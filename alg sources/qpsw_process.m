% main QPsw script:
% - calls demultiplex
% - calls calibration calculation
% - calls calibration interpolation
% - calls data recalculation
% Result are waveforms without digitizer errors.

clear all; close all;

% debug: generate input data %<<<1
sysconfig = [6 3 1];
sigconfig.f = 50;
sigconfig.A = [10 7 5 3 1 0.5];
sigconfig.ph = [0 0 0 0 0 0];
sigconfig.fs = 50e3;
sigconfig.Lm = 2;
sigconfig.SL = 50e3;
sigconfig.noise = 0.1;
sigconfig.fseg = 500;
sigconfig.fm = 75e9;
sigconfig.apply_filter = 1;
[D, S, M, Uref, Spjvs] = qps_simulator(sysconfig, sigconfig);

% split multiplexed data %<<<2
yc = qpsw_demultiplex_split(D, S, M);

    %XXX
    % Rs - how many samples will be removed at start of segment (samples)
    Rs = 5;
    % Re - how many samples will be removed at end of segment (samples)
    Re = 5;

% calibration curves for whole sampled data %<<<2
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
                        ycal(i,j) = adc_pjvs_calibration(yc{i,j}, Spjvs, Uref, Rs, Re);
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

colors = 'rgbkcyrgbkcyrgbkcyrgbkcy';
legc = [];
% make time axis:
t = [0:size(y,2) - 1]./sigconfig.fs;
figure
hold on
% plot signal
for i = 1:rows(y)
        plot(t, y(i, :) - max(sigconfig.A)*2.1.*(i-1), [colors(i) '-'])
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
