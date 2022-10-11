function dataout = alg_wrapper(datain, calcset)
% Part of QWTB. Wrapper script for algorithm TWM-1PPSSYNPHA
%
% See also qwtb
%
% This is part of the TWM - TracePQM WattMeter.
% (c) 2022, Martin Sira, msira@cmi.cz
% The script is distributed under MIT license, https://opensource.org/licenses/MIT.                

% initialize %<<<1
DEBUG = 0;

% Prepare data --------------------------- %<<<1
% convert N+1 dimensional matrices back to cell of structures
diC = matrices_to_cells(datain);
% diC{1} must contain signal with voltage
% diC{2} must contain signal with 1PPS

% calibrate time axis --------------------------- %<<<1
% signal:
u = diC{2}.y.v;
% time axis:
if isfield(diC{2}.t.v)
    t = diC{2}.t.v;
else
    if isfield(diC{2}.Ts.v)
        fs_pps = 1/diC{2}.Ts.v;
    else 
        fs_pps = 1/diC{2}.fs.v;
    end
    t = [0:numel(u)-1]./fs;
end % if isfield{diC{2}.t.v}

% starttime based on timestamp from TWM:
starttime = other{2}.timestamp;

% calculate corrected starttime and real sampling frequency:
% outputs:
% {corrstarttime} Corrected starttime of the first sample in the time series.
% {p} polynomial coefficients, output of polyfit, first order.
% {fsr} real calculated sampling frequency.
% {fsrerr} error of real calculated sampling frequency (based on sampling frequency reported by the sampling data)

[corrstarttime, p, fsr, fsrerr] = getRTC(t, u, starttime, 0) % verbose set to 0

% set corrected values to voltage data:
diC{1}.timestamp.v = corrstarttime;
diC{1}.fs.v = fsr;
if isfield(diC{1}.Ts.v)
    diC{1}.Ts.v = 1/fsr;
end
if isfield(diC{1}.t.v)
    diC{1} = rmfield(diC{1}, 't');
end

% calculate amplitude and phasor - call TWM algorithm --------------------------- %<<<1
res = qwtb(diC{1}.alg.v, diC{1}, calcset);

% set outputs --------------------------- %<<<1
dataout.A = res.A;
dataout.ph = res.ph;
dataout.f = res.f;

end % function dataout = alg_wrapper(datain, calcset)

% Move this into standalone: XXX
function [diC] = matrices_to_cells(din, alginfo) %<<<1
% Reorder data from the Cell diC of size N with structures with matrices to a
% Strucure with matrices of one dimension more. The added dimension will have
% size N.
% This is done with respect to the qwtb and TWM quantities, so parameter
% dimensions are not increased.
% If matrices diC{i}.Q.F and diC{j}.Q.F are not of same dimensions, they are
% padded by NaNs to the size of larger one.
% Structures in cells must have the same fields to whole depth.


% Reorder data from a structure with matrices of dimension N+1 into cells of structures
% with matrices of dimension N. The last dimension was used for different phases of the sampled system.
% This is done with respect to the qwtb and TWM quantities, so parameter
% dimensions are not increased.
% Script qwtb_exec_algorithm.m did the conversion from cell of structs to
% struct of N+1 matrices. If matrices were of incompatible sizes, padding by
% NaNs occured.
% This function removes the padding back.

    % List of possible quantity fields in QWTB:
    QWTBf = {'v', 'u', 'd', 'c', 'r'};

    % list of quantities of the algorithm:
    Qs = fieldnames(din);

    % Go through fields 'v' of all quantities and find size of the latest
    % dimension:
    max_dim = [];
    for q = 1:numel(Qs)
        Q = Qs{q};
        % only if not parameter:
        % (every quantity gets field 'par', that is added by QWTB)
        if not(din.(Q).par)
            % take size of last dimension:
            max_dim(end+1) = size(din.(Q).v)(end);
        end % if not(Q.par)
    end
    if not(all(max_dim(1) == max_dim))
        error('QPSW wrapper - last dimension of some quantity is not same as of others. Concatenating all phases into one did not worked properly.')
    end
    max_dim = max(max_dim);

    % Prepare output cell for every phase:
    diC = cell(max_dim, 1);

    % For all quantities in the structure, for all fields, split matrices by last
    % dimension and put them into cells of structures.
    % From din.Q_j.F_k of size (m x n x i) -> diC{i}.Q_j.F_k of sizes (m x n)
    for q = 1:numel(Qs)
        Q = Qs{q};
        if din.(Q).par
        % If quantity is parameter type, only take value from first cell:
        % (every quantity gets field 'par', that is added by qwtb)
            for f = 1:numel(QWTBf)
                F = QWTBf{f};
                if isfield(din.(Q), F);
                    for c = 1:max_dim
                        diC{c}.(Q).(F) = din.(Q).(F);
                    end
                end % if isfield(din.(Q), F);
            end
        else
            % Q is not of parameter type, split matrix into cells:
            for f = 1:numel(QWTBf)
                F = QWTBf{f};
                % check existence of field! XXX
                if isempty(din.(Q).(F))
                    for c = 1:max_dim
                        diC{c}.(Q).(F) = [];
                    end
                else
                    % use subscript reference assignement because number of
                    % dimensions of the matrices is not known:
                    mat = din.(Q).(F);
                    S.subs = repmat({':'}, 1, ndims(mat));
                    S.type = '()';
                    for c = 1:max_dim
                        S.subs{end} = c;
                        diC{c}.(Q).(F) = subsref(mat, S);
                    end
                end % if isempty
            end % for f
        end % if din.(Q).par
    end % for q
end % function [diC] = matrices_to_cells(din, alginfo)

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
