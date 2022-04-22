% Makes demultiplexing of the waveforms measured in QPS - Quantum Power
% System. Returns data reordered so every row represents one signal.
% Developed in the scope of the EMPIR QPower.
% MIT license
%
% Inputs:
% y - Sampled data (V)
%   Matrix, every row represents data sampled by one digitizer. Number of rows
%   is equal to number of digitizers.
% S - Switching samples
%   Switch happens just before this sample number
% M - Multiplexer setup
%   Matrix of multiplexer setups in sections (in between switches).
%   Every row describes what was sampled by the digitizer.
%   1, 2, 3, ... denotes signals to be measured (e.g. phase 1, phase 2, phase 3
%   in three phase power system).
%   -1, -2, -3 ... denotes reference signals (Josephson Voltage Systems).
%
% Outputs:
% y2 - reordered sampled data (V)
%   First rows are quantum signals, next rows are signals to be measured,
%   according numbers in M matrix, -1; 1; 2; 3
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
% Returned data:
% signal 1 (y2 row 1)  :  -1   |  -1   |  -1
% signal 2 (y2 row 2)  :   1   |   1   |   1
% signal 3 (y2 row 3)  :   2   |   2   |   2
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
% Returned data:
% signal 1 (y2 row 1)  :  -1   |  -1   |  -1   |    -1
% signal 2 (y2 row 2)  :  NaN  |   1   |  NaN  |     1
% signal 3 (y2 row 3)  :   2   |  NaN  |   2   |    NaN

function y2 = qpsw_demultiplex(y, S, M) %<<<1
    % check variables: %<<<1
    % check if S is monotonic and numbers are not repeated:
    if not(all(diff(S)>0))
        error('qpsw_demultiplex: S is not monotonic or numbers are repeated!')
    end
    % check if S values are valid
    if any(S < 1)
        error('qpsw_demultiplex: S contains values smaller than 1')
    end
    if any(S > columns(y) + 1)
        error('qpsw_demultiplex: S contains values larger than number of samples in y (columns(y))!')
    end

    % check sizes:
    if size(S, 2) != columns(M) - 1
        error('qpsw_demultiplex: S columns must be equal to M columns minus 1!')
    end

    % prepare variables %<<<1
    % if switch is first sample, remove it, because switch before first sample
    % is implict.
    if S(1) != 1
        S = [1 S];
    end
    % add switch after (!) last sample if missing:
    if S(end) != columns(y) + 1
        S = [S columns(y) + 1];
    end
    % length of the records:
    samples = columns(y);
    % number of digitizers:
    digitizers = rows(y);
    % number of signals sampled by the digitizers:
    signals = length(unique(M));
    % initialize output matrix:
    y2 = NaN.*zeros(signals, samples);

    % bijection M->M2 %<<<1
    % renumber values in M to be just increasing from 1 to rows(y), simple
    % bijection (e.g. -1, 1, 2 into 1, 2, 3)
    % (this is crude method, how to make bijection simpler in matlab/octave?)
    nums = unique(M); % get all unique values
    offset = max(max(M)) + 10; % prepare offset so values are not overwritten
    % initiliaze memory:
    M2 = M;
    % first replace by values far away from maximum values so values are not
    % overwritten:
    for i = 1:length(nums)
        M2(M2 == nums(i)) = i + offset;
    end
    % subtract offset to get values from 1 to max(M)
    M2 = M2 - offset;

    % do signal reordering %<<<1
    % reorder y into y2:
    for s = 1:(columns(S) - 1)
        % for every section between multiplexer switches
        for r = 1:rows(M)
            % for every row (digtizers)
            % row index is:
            % M2(r, s) <- r
            % collumn indexes are:
            % S(s) : S(s+1) - 1
            y2( M2(r, s), S(s):S(s+1) -1 ) = y( r, S(s):S(s+1) -1 );
        end % r
    end % s
end % function

% tests  %<<<1
%!shared y, S, M, y2, y2ref
%! % Example 1: %<<<2
%! y  =    [ 1  2  3 40 50 60 -7 -8 -9; -1 -2 -3 4 5 6 70 80 90; 10 20 30 -4 -5 -6  7  8  9];
%! S = [4 7];
%! M = [1 2 -1; -1 1 2; 2 -1 1];
%! y2ref = [-1 -2 -3 -4 -5 -6 -7 -8 -9;  1  2  3 4 5 6  7  8  9; 10 20 30 40 50 60 70 80 90];
%! y2 = qpsw_demultiplex(y, S, M);
%!assert(y2ref == y2);
%! % Example 2: %<<<2
%! y  =    [-1 -2 -3  4  5  6 -7 -8 -9  10  11  12;  10  20  30 -4 -5 -6  70  80  90 -10 -11 -12];
%! S = [4 7 10];
%! M = [-1 1 -1 1; 2 -1 2 -1];
%! y2ref = [-1 -2 -3 -4 -5 -6 -7 -8 -9 -10 -11 -12; NaN NaN NaN  4  5  6 NaN NaN NaN  10  11  12; 10 20 30 NaN NaN NaN 70 80 90 NaN NaN NaN];
%! y2 = qpsw_demultiplex(y, S, M);
%! % the change of NaN into -100 is only to get ability of comparision, because NaN == NaN is always false!
%! y2(isnan(y2)) = -100;
%! y2ref(isnan(y2ref)) = -100;
%!assert(y2ref == y2);

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
