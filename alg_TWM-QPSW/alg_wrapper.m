function dataout = alg_wrapper(datain, calcset)
% Part of QWTB. Wrapper script for algorithm TWM-QPSW.
%
% See also qwtb
%
% This is part of the TWM - TracePQM WattMeter.
% (c) 2018, Martin Sira, msira@cmi.cz
% The script is distributed under MIT license, https://opensource.org/licenses/MIT.                

% initialize %<<<1
DEBUG = 0;

% Prepare data --------------------------- %<<<1
% convert N+1 dimensional matrices back to cell of structures
diC = matrices_to_cells(datain);
% split data:
for j = 1:numel(diC)
    [data{j}, adc{j}, tr{j}, cable{j}, other{j}] = split_di(din);
end % for j = 1:numel(diC)

% get basic quantities for qpsw_process %<<<2

if isfield(other{1}, 'fs')
    sigconfig.fs = other{1}.fs.v;
elseif isfield(other{1}, 'Ts')
    sigconfig.fs = 1/other{1}.Ts.v;
end
sigconfig.fseg = other{1}.fseg.v;
sigconfig.MRs = 10; % XXX assign!
sigconfig.MRe = 10; % XXX assign!
% convert sampled signals into matrix:
for k = 1:numel(other)
    y(k, :) = other{k}.y.v(:)';
end % for k
% get: S - indexes of multiplexer switches:
S = other{1}.S.v;
% get: M - multiplexer setup:
M = other{1}.M.v;
% get: Uref1period - PJVS reference values:
Uref1period = other{1}.Uref.v;
% XXX abandoned - to be removed:
Spjvs = [];
% get: alg - algorithm used to get final quantities:
alg = other{1}.alg.v;
% get optional Rs, Re:
if ~isfield(other{1}, 'Rs')
    sigconfig.PRs = 0;
else
    sigconfig.PRs = other{1}.Rs.v;
end
if ~isfield(other{1}, 'Re')
    sigconfig.PRe = 0;
else
    sigconfig.PRe = other{1}.Re.v;
end
% debug setup:
dbg = check_gen_dbg([], 1);
dbg.v = 1;
dbg.saveplotsplt = 0;
dbg.plotpath = 'simulation_results';
if ~exist(dbg.plotpath, 'dir')
    mkdir(dbg.plotpath);
end

% qpsw process --------------------------- %<<<1
[y, yc, res, My] = qpsw_process(sigconfig, y, S, M, Uref1period, Spjvs, alg, dbg);

% set adc corrections --------------------------- %<<<1
% sets adc linearity and gain corrections to ideal 1, because sampled data are
% already linearized by using PJVS calibration:
for j = 1:numel(adc)
    adc{j}.gain = 1;
    adc{j}.gain_a = [1];
    adc{j}.gain_f = [50];
    adc{j}.gain_offset = 0;
end % for j = 1:numel(adc)

% construct input data for TWM algorithm --------------------------- %<<<1
% concatenate structures:
% start by first nonPJVS signal:
firstnotPJVS = find(My > 0);
if isempty(firstnotPJVS)
    error('no nonPJVS signal found') %XXX proper error message:
else
    firstnotPJVS = firstnotPJVS(1);
end

% remove signals that are PJVS:
y = y(firstnotPJVS:end, :);
yc = yc{firstnotPJVS:end};

if ~mod(numel(yc),2)
    error('signals not in pairs voltage/current, odd count of signals!') % XXX better error message!
end

% construct voltage-current pairs:
algdi = cell();
for j = 1:2:numel()
    algdi{end+1} = struct();
    algdi{end}.u.v = yc{j};
    algdi{end}.i.v = yc{j+1};
    algdi{end} = join_structs(algdi{end}, prefix(adc(j), 'u'), prefix(tr, 'u'), cable, other);
    algdi{end} = join_structs(algdi{end}, prefix(adc(j), 'i'), prefix(tr, 'i'));
end

% call TWM algorithm --------------------------- %<<<1
for j = 1:numel(algdi)
    do{j} = qwtb(alg, algdi{j}, calcset)
end

% make outputs --------------------------- %<<<1
2DO

end % function dataout = alg_wrapper(datain, calcset)

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

function [data, adc, tr, cable, other] = split_di(din) %<<<1
% function returns structures with: transducer corrections, digitizer
% corrections, data itself, rest of quantities.
    data = struct();
    adc = struct();
    tr = struct();
    cable = struct();
    other = struct();

    Qs = fieldnames(din);
    for j = 1:numel(Qs)
        Q = Qs{j};
        if strfind(Q, 'tr_')
            % Q is correction of transducer
            tr.(Q) = din.(Q);
        elseif strfind(Q, 'adc_')
            % Q is correction of digitizer
            adc.(Q) = din.(Q);
        elseif ( strfind(Q, 'Zcb_') | strfind(Q, 'Ycb_') )
            % Q is correction of connecting
            cable.(Q) = din.(Q);
        elseif strcmp(Q, 'y') | strcmp(Q, 'u') | strcmp(Q, 'i')
            data.(Q) = din.(Q);
        else
            other.(Q) = din.(Q);
        end
    end % for j
end % function [data, adc, tr, cable, other] = split_di(din)

function [data, adc, tr, cable, other] = split_di(din) %<<<1
    mergestructs = @(x,y) cell2struct([struct2cell(x);struct2cell(y)],[fieldnames(x);fieldnames(y)]);
end

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
