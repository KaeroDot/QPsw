% Script to simulate signal digitized in QP system. For testing of qpsw.
% Inputs:
% sysconfig: number determining a configuration of M and lengths of data pieces
% inside:
%    [Signo DACno PJVSno], timing
%   1: [1 1 1], 1/2 1/2
%   2: [2 1 1], 1/3, 1/3, 1/3
%   3: [2 2 1], 1/3, 1/3, 1/3
%   4: [2 2 1], 1/10, 1/10, 9/10
%   5: [2 3 1], 1/6, 1/6, 1/6, 1/6, 1/6, 1/6
%   6: [6 3 1], 1/3, 1/3, 1/3
%   
% sigconfig: structure with signal properties, where
%   .f - main signal frequency (Hz), scalar
%   .A - 'sine' wave amplitude (V), vector of n numbers, where n is equal to number of DUT signals in the QPS
%   .ph - 'sine' wave amplitude (rad), vector of n numbers, where n is equal to number of DUT signals in the QPS
%   .fs - sampling frequency (Hz), scalar
%   .Lm - record length multiple, total record length is equal to Lm*BL
%   .BL - data block length (samples length of single M)
%   .noise - signal noise sigma (V), scalar
%   .fseg - frequency of PJVS segments (Hz), scalar
%   .fm - PJVS microwave frequency (Hz), scalar
%   .apply_filter - if nonzero, digital filter simulating sigma delta digitizer is applied (0/1), scalar
%
% Outputs:
% D - samples
% S - samples of switch events (just before the sample switch happened)
% M - system setup matrix

function [D, S, M, Uref, Sid] = qps_simulator(sysconfig, sigconfig, S) 
    DEBUG = 0;
    % check user inputs %<<<1
    if sysconfig < 0 || sysconfig > 7 || sysconfig ~= fix(sysconfig)
        error('qps_simulator: bad value of sysconfig, unknown configuration')
    end

    % signal configuration: %<<<2
    f = sigconfig.f;
    A = sigconfig.A;
    ph = sigconfig.ph;
    fs = sigconfig.fs;
    Lm = sigconfig.Lm;
    BL = sigconfig.BL;
    noise = sigconfig.noise;
    fseg = sigconfig.fseg;
    fm = sigconfig.fm;
    apply_filter = sigconfig.apply_filter;

    % system configuration %<<<1
    switch sysconfig
        case 1 %   1: [1 1 1], 1/2 1/2 %<<<2
            Signo = 1;
            DACno = 1;
            PJVSno = 1;
            M = [-1  1];
            BLdiv = [1 1]./2;
        case 2 %   2: [2 1 1], 1/3, 1/3, 1/3 %<<<2
            Signo = 2;
            DACno = 1;
            PJVSno = 1;
            M = [-1  1  2];
            BLdiv = [1 1 1]./3;
        case 3 %   3: [2 2 1], 1/3, 1/3, 1/3 %<<<2
            Signo = 2;
            DACno = 2;
            PJVSno = 1;
            M = [-1  1;
                  2 -1];
            BLdiv = [1 1]./2;
        case 4 %   4: [2 2 1], 1/10, 1/10, 9/10 %<<<2
            Signo = 2;
            DACno = 2;
            PJVSno = 1;
            M = [-1  0  1;
                  0 -1  2];
            BLdiv = [0.1 0.1 0.9];
        case 5 %   5: [2 3 1], 1/6, 1/6, 1/6, 1/6, 1/6, 1/6 %<<<2
            Signo = 2;
            DACno = 3;
            PJVSno = 1;
            M = [-1  1  1 -1  2  2;
                  1 -1  2  2 -1  1;
                  2  2 -1  1  1 -1];
            BLdiv = [1 1 1 1 1 1]./6;
        case 6 %   6: [6 3 1], 1/3, 1/3, 1/3 %<<<2
            Signo = 6;
            DACno = 3;
            PJVSno = 1;
            M = [-1  3  5;
                  1 -1  6;
                  2  4 -1];
            BLdiv = [1 1 1]./3;
        otherwise
            error('qpsw_simulator: unknown configuration')
    end
    % full record and data piece lengths %<<<1
    % data pieces lengths:
    DL = BL.*BLdiv;
    DL = fix(DL);
    % this is very crude method of getting integer number of lengths of data
    % pieces. needed if user wants data block of length not divisible by data
    % pieces lengths. The last data piece is extended so sum(DL) is equal to BL
    DL(end) = DL(end) + BL - sum(DL);
    % data multiplication:
    DL = repmat(DL, 1, Lm);
    % configuration matrix multiplication:
    M = repmat(M, 1, Lm);
    % full record length:
    RL = BL.*Lm;
    % make switches between BL:
    S = cumsum(DL) + 1;
    % switch before first sample is implicit:
    S = [1 S];

    % generate signals %<<<1
    % PJVS signal %<<<2
    [y_PJVS, n, Uref, Sid] = pjvs_wvfrm_generator(f, max(A), 0, RL, fs, noise, fseg, 0, fm, apply_filter);

    % DUT signal %<<<2
    t_DUT = [0:RL-1]./fs;
    y_DUT = A'.*sin(2.*pi.*f.*t_DUT + ph');
    
    % initialize sampled data D:
    % (zeros because if no signal, digitizer is probably shorted)
    D = zeros.*ones(DACno, RL);
    % set content of D
    for i = 1:size(M,1)
        for j = 1:size(M,2)
            ids = S(j);
            ide = S(j+1) - 1;
            if M(i,j) < 0
                D(i, ids:ide) = y_PJVS(1, ids:ide);
            elseif M(i,j) > 0
                D(i, ids:ide) = y_DUT(M(i,j), ids:ide);
            % if M(i,j) == 0 -> nothing to do, digitizer is shorted
            end
        end % for j = 1:size(M,2)
    end % for i = 1:size(M,1)

    % % debug - plotting %<<<1
    if DEBUG
        colors = 'rgbk';
        legc = [];
        figure
        hold on
        % plot signal
        for i = 1:rows(D)
                plot(D(i, :) - max(A)*2.1.*(i-1), [colors(i) '-'])
                legc{end+1} = (['Digitzer ' num2str(i)]);
        end % for i
        % plot switch events
        minmax = ylim;
        minmax(1) = minmax(1) - abs(minmax(2) - minmax(1)).*0.1;
        minmax(2) = minmax(2) + abs(minmax(2) - minmax(1)).*0.1;
        for i = 1:length(S)
                plot([S(i) S(i)], minmax)
        end % for i
        legend(legc)
        hold off
    end % if DEBUG

end % function

% tests  %<<<1
% just test working function for simple and terrible inputs:
%!test
%!shared sysconfig, sigconfig, D, S, M
%! sigconfig.f = 50;
%! sigconfig.A = [10 7 5 3 1 0.5];
%! sigconfig.ph = [0 0 0 0 0 0];
%! sigconfig.fs = 50e3;
%! sigconfig.Lm = 2;
%! sigconfig.BL = 50e3;
%! sigconfig.noise = 0.1;
%! sigconfig.fseg = 500;
%! sigconfig.fm = 75e9;
%! sigconfig.apply_filter = 1;
%! [D, S, M] = qps_simulator(1, sigconfig);
%!assert(exist('D'))
%! [D, S, M] = qps_simulator(2, sigconfig);
%!assert(exist('D'))
%! [D, S, M] = qps_simulator(3, sigconfig);
%!assert(exist('D'))
%! [D, S, M] = qps_simulator(4, sigconfig);
%!assert(exist('D'))
%! [D, S, M] = qps_simulator(5, sigconfig);
%!assert(exist('D'))
%! [D, S, M] = qps_simulator(6, sigconfig);
%!assert(exist('D'))

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
