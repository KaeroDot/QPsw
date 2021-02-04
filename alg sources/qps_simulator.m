% Script to simulate signal digitized in QP system. For testing of qpsw.
% Inputs:
% sysconfig: vector of 3 integers, where
%   sysconfig(1) - number of DUT signals in the QPS
%   sysconfig(2) - number of digitizers in the QPS
%   sysconfig(3) - number of PJVS in the QPS
%   For now only following system configurations are supported:
%   [2 1 1]
%   [2 2 1]
%   [2 3 1]
%   [6 3 1]
% sigconfig: structure with signal properties, where
%   .f - main signal frequency (Hz), scalar
%   .A - 'sine' wave amplitude (V), vector of n numbers, where n is equal to number of DUT signals in the QPS
%   .ph - 'sine' wave amplitude (rad), vector of n numbers, where n is equal to number of DUT signals in the QPS
%   .fs - sampling frequency (Hz), scalar
%   .Lm - record length multiple, total record length is equal to Lm*cols(M)*SL
%   .SL - section length (number of samples from multiplexer switch to switch)
%   .noise - signal noise sigma (V), scalar
%   .fseg - frequency of PJVS segments (Hz), scalar
%   .fm - PJVS microwave frequency (Hz), scalar
%   .apply_filter - if nonzero, digital filter simulating sigma delta digitizer is applied (0/1), scalar
%
% Outputs:
% D - samples
% S - samples of switch events
% M - system setup matrix

function [D, S, M, Uref, Sid] = qps_simulator(sysconfig, sigconfig) 
    % check user inputs %<<<1
    % system configuration %<<<2
    if numel(sysconfig) ~= 3
        error('qps_simulator: bad value of input sysconfig')
    end
    Signo = sysconfig(1);
    DACno = sysconfig(2);
    PJVSno = sysconfig(3);
    % leftover for debugging:
    % % number of DUT signals in the system:
    % Signo = 2;
    % % number of digitizers in the system:
    % DACno = 3;
    % % number of PJVS in the system:
    % PJVSno = 1;
    % % system configuration:
    % sysconfig = [Signo DACno PJVSno];

    % signal configuration: %<<<2
    if ~all(sysconfig == fix(sysconfig))
        error('qps_simulator: noninteger values in input sysconfig')
    end
    f = sigconfig.f;
    A = sigconfig.A;
    ph = sigconfig.ph;
    fs = sigconfig.fs;
    Lm = sigconfig.Lm;
    SL = sigconfig.SL;
    noise = sigconfig.noise;
    fseg = sigconfig.fseg;
    fm = sigconfig.fm;
    apply_filter = sigconfig.apply_filter;

    % leftover for debugging:
    % % DUT signals parameters:
    % % f - main signal frequency (Hz)
    % f = 50;
    % % A - 'sine' wave amplitude, 3 phase system
    % A = [10 5];
    % % ph - 'sine' wave phase, 3 phase system
    % ph = [0 0];
    % 
    % % acquisition parameters:
    % % fs - sampling frequency
    % fs = 50e3;
    % % Lm - record length multiple
    % % record length L = Lm*cols(M)*SL
    % Lm = 2;
    % % SL - section length (switch to switch in samples)
    % SL = fs;
    % % noise - signal noise sigma
    % noise = 0;
    % % fseg - frequency of PJVS segments
    % fseg = f*10;
    % % fm - microwave frequency
    % fm = 75e9;
    % % apply_filter - if nonzero, applies digital filter simulating sigma delta 
    % apply_filter = 1;

    % Generate M matrix %<<<1
    % DUT singals, digitizers, PJVS
    if sysconfig == [1 1 1]
        M = [-1  1];
    elseif sysconfig == [2 1 1]
        M = [-1  1  2];
    elseif sysconfig == [2 2 1]
        M = [-1  1;
              2  1];
    elseif sysconfig == [2 3 1]
        M = [-1  1  1 -1  2  2;
              1 -1  2  2 -1  1;
              2  2 -1  1  1 -1];
    elseif sysconfig == [6 3 1]
        M = [-1  3  5;
              1 -1  6;
              2  4 -1];
    else
        error('qpsw_simulator: unknown configuration')
    end
    % multiply M to generate required signal:
    % record length (samples):
    L = Lm.*columns(M).*SL;
    % configuration matrix multiplication:
    M = repmat(M, 1, Lm);

    % generate signals %<<<1
    % PJVS signal %<<<2
    [y_PJVS, n, Uref, Sid] = pjvs_wvfrm_generator(f, max(A), 0, SL, fs, noise, fseg,     0, fm, apply_filter);

    % DUT signal %<<<2
    t_DUT = [0:L-1]./fs;
    y_DUT = A'.*sin(2.*pi.*f.*t_DUT + ph');

    % S (switches)
    S = [1:columns(M)-1].*SL + 1;

    % initialize sampled data D:
    D = NaN.*ones(DACno, L);
    % set content of D
    for i = 1:size(M,1)
        for j = 1:size(M,2)
            ids = (j-1).*SL + 1;
            ide = j.*SL;
            if M(i,j) < 0
                D(i, ids:ide) = y_PJVS(abs(M(i,j)), :);
            else
                D(i, ids:ide) = y_DUT(M(i,j), ids:ide);
            end
        end % for j = 1:size(M,2)
    end % for i = 1:size(M,1)

    % % debug - plotting %<<<1
    % colors = 'rgbk';
    % legc = [];
    % figure
    % hold on
    % % plot signal
    % for i = 1:rows(D)
    %         plot(t_DUT, D(i, :) - max(A)*2.1.*(i-1), [colors(i) '-'])
    %         legc{end+1} = (['Digitzer ' num2str(i)]);
    % end % for i
    % % plot switch events
    % minmax = ylim;
    % minmax(1) = minmax(1) - abs(minmax(2) - minmax(1)).*0.1;
    % minmax(2) = minmax(2) + abs(minmax(2) - minmax(1)).*0.1;
    % for i = 1:length(S)
    %         plot([t_DUT(S(i)) t_DUT(S(i))], minmax)
    % end % for i
    % legend(legc)
    % hold off

end % function

% tests  %<<<1
% just test working function for simple and terrible inputs:
%!test
%!shared sysconfig, sigconfig, D, S, M
%! sysconfig = [2 1 1];
%! sigconfig.f = 50;
%! sigconfig.A = [10 7 5 3 1 0.5];
%! sigconfig.ph = [0 0 0 0 0 0];
%! sigconfig.fs = 50e3;
%! sigconfig.Lm = 2;
%! sigconfig.SL = 50e3;
%! sigconfig.noise = 0.1;
%! sigconfig.fseg = 500;
%! sigconfig.fm = 75e9;
%! sigconfig.apply_filter = 1;
%! [D, S, M] = qps_simulator(sysconfig, sigconfig);
%!assert(exist('D'))
%! sysconfig = [2 2 1];
%! [D, S, M] = qps_simulator(sysconfig, sigconfig);
%!assert(exist('D'))
%! sysconfig = [2 3 1];
%! [D, S, M] = qps_simulator(sysconfig, sigconfig);
%!assert(exist('D'))
%! sysconfig = [6 3 1];
%! [D, S, M] = qps_simulator(sysconfig, sigconfig);
%!assert(exist('D'))

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
