addpath('..')
% SET QWTB path to your own directory!
addpath('~/metrologie/Q-Wave/qwtb/qwtb')
dbg = check_gen_dbg([], 1);

% ---SETUP-----------------------------------------------------------------
% values obtained from measurement setup:

fn = '190422_PJVS_0147/RAW/G0001-A0001.mat';
switch_period = 10322; % (samples)
RRs = 6483; % (samples) - remove from start
RRe = 0; % (samples) - remove from end
data_gain = 6.6294297E-7;
Mcore = [-1  1];
Uref1period = 70e9./483597.84841698e9.*[ 6909.000 5584.000 2134.000 -2134.000 -5584.000 -6909.000 -5584.000 -2134.000 2134.000 5584.000];
sigconfig.f = [50];
sigconfig.A = [1];
sigconfig.ph = [0];
sigconfig.fseg = 555.555555;
sigconfig.fs = 10e3;
sigconfig.MRs = 100;
sigconfig.MRe = 100;
sigconfig.PRs = 10;
sigconfig.PRe = 5;
sigconfig.fs = 10e3;
dbg.plotpath = '190422_PJVS_0147_results';

% -------------------------------------------------------------------

% load raw data:
load(fn);
y = y.*data_gain;
y = y(1 + RRs : end - RRe);

% S - Switching samples
S = [1 : switch_period : length(y)];
if S(end) ~= length(y)+1
    S(end+1) = length(y)+1;
end
% M - Multiplexer setup
% just make very long vector of setups:
M = repmat(Mcore, 1, length(S));
% and now cut it to proper length
M = M(1,1:length(S)-1);

alg = 'PSFE';
profile on
[y, yc, res] = qpsw_process(sigconfig, y, S, M, Uref1period, [], alg, dbg);
profile off
T = profile('info');
profshow(T)

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=matlab textwidth=80 tabstop=4 shiftwidth=4
