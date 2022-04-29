% DO NOT forget to add path to QWTB!
% addpath('path_to_your_directory_with_QWTB')

clear all, close all
% system setup:
sysconfig = 1;

% signal setup:
sigconfig.f = 50;
sigconfig.A = [10 7 5 3 1 0.5];
sigconfig.ph = [0 0 0 0 0 0];
sigconfig.fs = 50e3;
sigconfig.Lm = 2;
sigconfig.BL = 50e3;
sigconfig.noise = 0.1;
sigconfig.fseg = 500;
sigconfig.fm = 75e9;
sigconfig.apply_filter = 1;
sigconfig.MRs = 10;
sigconfig.MRe = 10;
sigconfig.PRs = 1;
sigconfig.PRe = 1;

% debug setup:
dbg.v = 0;
dbg.section = 0;
dbg.segment = 0;
dbg.showplots = 'off'; % 'on' or 'off'
dbg.saveplotsplt = 1;
dbg.saveplotspng = 1;
dbg.plotpath = '.';

alg = 'PSFE';

[D, S, M, Uref, Uref1period, Spjvs] = qps_simulator(sysconfig, sigconfig, dbg);

res = qpsw_process(sigconfig, D, S, M, Uref1period, [], alg, dbg);

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
