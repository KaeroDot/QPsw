% Makes demultiplexing of the waveforms measured in QPS - Quantum Power
% System. Does the second part - connect data back to rows of signals.
% Developed in the scope of the EMPIR QPower.
% MIT license
%
% Inputs:
% yc - Sampled data (V) as cell, result of qpsw_demultiplex_split
%   Matrix, every row represents data sampled by one digitizer. Number of rows
%   is equal to number of digitizers.
% M - Multiplexer setup
%   Matrix of multiplexer setups in sections (in between switches).
%   Every row describes what was sampled by the digitizer.
%   1, 2, 3, ... denotes signals to be measured (e.g. phase 1, phase 2, phase 3
%   in three phase power system).
%   -1, -2, -3 ... denotes reference signals (Josephson Voltage Systems).
%
% Outputs:
% y - reordered sampled data (V)
%   First rows are quantum signals, next rows are signals to be measured,
%   according numbers in M matrix, -1; 1; 2; 3
% ycout - reordered sampled data (V), kept as cell of data pieces.
% My - setup of rows of y. M values reordered into rows as y.
%
% Examples are shown for use of qpsw_demultiplex_split and 
% qpsw_demultiplex_sew right after:
%
% Example 1:
% Example shows measurement by 3 digitizers of 2 signals and 1 JVS.
% Values of S and M for this example are:
% S = [4 7] % two switches by multiplexer, i.e. three sections
% M = [1 2 -1; -1 1 2; 2 -1 1]
%                               __ switch happened here
%                              |        __ switch happened here
%                              v       v
% Sample number:         1 2 3 | 4 5 6 | 7 8 9
% M:
% digitizer 1 (y row 1):   1   |   2   |  -1
% digitizer 2 (y row 1):  -1   |   1   |   2
% digitizer 3 (y row 1):   2   |  -1   |   1
% Returned data after _sew:
% My:
% signal 1 (y  row 1)  :  -1   |  -1   |  -1
% signal 2 (y  row 2)  :   1   |   1   |   1
% signal 3 (y  row 3)  :   2   |   2   |   2
%
% Example 2:
% Example shows measurement by 2 digitizers of 2 signals and 1 JVS.
% Values of S and M for this example are:
% S = [4 7 10] % two switches by multiplexer, i.e. three sections
% M = [-1 1 -1 1; 2 -1 2 -1];
%                               __ switch happened here
%                              |        __ switch happened here
%                              |       |        __ switch happened here
%                              v       v       v
% Sample number:         1 2 3 | 4 5 6 | 7 8 9 | 10 11 12
% M:
% digitizer 1 (y row 1):  -1   |   1   |  -1   |     1
% digitizer 2 (y row 1):   2   |  -1   |   2   |    -1
% Returned data after _sew:
% signal 1 (y  row 1)  :  -1   |  -1   |  -1   |    -1
% signal 2 (y  row 2)  :  NaN  |   1   |  NaN  |     1
% signal 3 (y  row 3)  :   2   |  NaN  |   2   |    NaN

function [y, ycout, My] = qpsw_demultiplex_sew(yc, M) %<<<1
    % get all unique values in configuration matrix M:
    nums = unique(M);
    % get ordering of the output signals:
    My = sort(nums)(:)';
    % get record length:
    RL = sum(cellfun('size', yc, 2));
    % number of DUT signals:
    Sig = numel(nums);

    % bijection M->M2 %<<<1
    % renumber values in M to be just increasing from 1 to rows(y), simple
    % bijection (e.g. -1, 1, 2 into 1, 2, 3)
    % (this is crude method, how to make bijection simpler in matlab/octave?)
    offset = max(max(M)) + 10; % prepare offset so values are not overwritten
    % initiliaze new configuration matrix:
    M2 = M;
    % first replace by values far away from maximum values so values are not
    % overwritten:
    for i = 1:Sig
        M2(M2 == nums(i)) = i + offset;
    end
    % subtract offset to get values from 1 to Sig
    M2 = M2 - offset;

    % initialize sampled data y:
    y = NaN.*ones(Sig, RL);
    % set content of y
    for i = 1:size(M2,1)
        position = 1;
        for j = 1:size(M2,2)
            ids = position;
            ide = ids + size(yc{i,j}, 2) - 1;
            y(M2(i,j),ids:ide) = yc{i,j};
            position = ide + 1;
        end % for j = 1:size(M,2)
    end % for i = 1:size(M,1)
end % function
% XXX missing ycout in results!

% tests  %<<<1
%!test
%!shared y, S, M, ycout, yc, ycoutref
%! % Example 1: %<<<2
%! y  = [ 1  2  3 40 50 60 -7 -8 -9; -1 -2 -3 4 5 6 70 80 90; 10 20 30 -4 -5 -6  7  8  9];
%! S = [4 7];
%! M = [1 2 -1; -1 1 2; 2 -1 1];
%! ycoutref = [-1 -2 -3 -4 -5 -6 -7 -8 -9;  1  2  3 4 5 6  7  8  9; 10 20 30 40 50 60 70 80 90];
%! yc = qpsw_demultiplex_split(y, S, M);
%! ycout = qpsw_demultiplex_sew(yc, M);
%!assert(ycoutref == ycout);
%! % Example 2: %<<<2
%! y  =    [-1 -2 -3  4  5  6 -7 -8 -9  10  11  12;  10  20  30 -4 -5 -6  70  80  90 -10 -11 -12];
%! S = [4 7 10];
%! M = [-1 1 -1 1; 2 -1 2 -1];
%! ycoutref = [-1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12; NaN NaN NaN  4  5  6 NaN NaN NaN  10  11  12; 10 20 30 NaN NaN NaN 70 80 90 NaN NaN NaN];
%! yc = qpsw_demultiplex_split(y, S, M);
%! ycout = qpsw_demultiplex_sew(yc, M);
%! % the change of NaN into -100 is only to get ability of comparison, because NaN == NaN is always false!
%! ycout(isnan(ycout)) = -100;
%! ycoutref(isnan(ycoutref)) = -100;
%!assert(ycoutref == ycout);

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
