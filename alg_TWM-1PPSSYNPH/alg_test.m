% Generator for 1PPSSYNPH algorithm
% function alg_test()
% addpath('../../TWM - github/octprog')
% addpath('../../TWM - github/octprog/qwtb')
[gDI, gDO] = alg_generator();

DO = qwtb('TWM-1PPSSYNPH', gDO);

% end % function alg_test()


