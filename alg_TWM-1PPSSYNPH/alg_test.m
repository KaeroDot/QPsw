% Test for 1PPSSYNPH algorithm
function alg_test()
    [DI, refDI] = qwtb('TWM-1PPSSYNPH', 'gen');
    DO = qwtb('TWM-1PPSSYNPH', DI);
    assert(abs(DO.A.v(1) - refDI.A.v(1)) < 1e-10)
    assert(abs(DO.ph.v(1) - refDI.ph.v(1)) < 1e-9)
end % function alg_test()
