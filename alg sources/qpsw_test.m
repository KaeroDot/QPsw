% DO NOT forget to add path to QWTB!
% addpath('path_to_your_directory_with_QWTB')

clear all, close all
% simulation setup:
simconfig.scenario = 6;
simconfig.f = 50;
simconfig.A = [10 7 5 3 1 0.5];
simconfig.ph = [0 0 0 0 0 0];
simconfig.fs = 50e3;
simconfig.Lm = 2;
simconfig.BL = 50e3;
simconfig.noise = 1e-5;
simconfig.fseg = 500;
simconfig.fm = 75e9;
simconfig.apply_filter = 0;

% debug setup:
dbg = check_gen_dbg();
dbg.v = 1;
dbg.showplots = 'off'; % 'on' or 'off'
dbg.saveplotsplt = 1;
dbg.saveplotspng = 1;
dbg.plotpath = 'simulation_results';
if ~exist(dbg.plotpath, 'dir')
    mkdir(dbg.plotpath);
end

alg = 'PSFE';

[D, S, M, Uref, Uref1period, Spjvs] = qps_simulator(simconfig, dbg);

sigconfig.MRs = 10;
sigconfig.MRe = 10;
sigconfig.PRs = 1;
sigconfig.PRe = 1;
sigconfig.fseg = simconfig.fseg;
sigconfig.fs = simconfig.fs;

res = qpsw_process(sigconfig, D, S, M, Uref1period, [], alg, dbg);

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
