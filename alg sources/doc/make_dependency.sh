#!/usr/bin/octave-cli -qf
addpath('~/prog/octave/mDepGen - github/')
mDepGen('..', 'qpsw_test.m', './calculate_dependency', {}, {}, 'hidesubfuns', 0, 'plotunknownfuns', 1, 'verbose', 2, 'debug', 0)
# cmd = 'convert -density 600x600 calculate_dependency.pdf calculate_dependency.png';
cmd = 'convert -density 100x100 calculate_dependency.pdf calculate_dependency.png';
system(cmd)
