% debug: generate input data %<<<1
clear all, close all
% sysconfig == [2 1 1];
% sysconfig == [2 2 1];
% sysconfig == [2 3 1];

sysconfig = [1 1 1];
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
sigconfig.Rs = 1;
sigconfig.Re = 1;
% Rs - how many samples will be removed at start of pjvs segment (samples)
Rs = 5;
% Re - how many samples will be removed at end of pjvs segment (samples)
Re = 5;

alg = 'PSFE';

[D, S, M, Uref, Spjvs] = qps_simulator(sysconfig, sigconfig);

res = qpsw_process(sysconfig, sigconfig, D, S, M, Uref, Spjvs, alg);

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
