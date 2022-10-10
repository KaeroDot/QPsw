function dataout = alg_wrapper(datain, calcset)
% Part of QWTB. Wrapper script for algorithm TWM-QPSW.
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
% split data:
for j = 1:numel(diC)
    [data{j}, adc{j}, tr{j}, cable{j}, other{j}] = split_di(diC{j});
end % for j = 1:numel(diC)

% get basic quantities for qpsw_process %<<<2
% This will have to be fixed in TWM/qwtb_exec_algorithm. This is only temporary
% measure:
eval(['other{1}.S.v = ' other{1}.S.v ';'])
eval(['other{1}.M.v = ' other{1}.M.v ';'])
eval(['other{1}.Uref.v = ' other{1}.Uref.v ';'])

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
    y(k, :) = data{k}.y.v(:)';
end % for k
% get: S - indexes of multiplexer switches:
S = other{1}.S.v;
% get: M - multiplexer setup:
M = other{1}.M.v;
% get: Uref1period - PJVS reference values:
Uref1period = other{1}.Uref.v;
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
% get optional Ms, Me:
if ~isfield(other{1}, 'Ms')
    sigconfig.MRs = 5;
else
    sigconfig.MRs = other{1}.Ms.v;
end
if ~isfield(other{1}, 'Me')
    sigconfig.MRe = 5;
else
    sigconfig.MRe = other{1}.Me.v;
end

% debug setup:
dbg = check_gen_dbg([], 1);
dbg.v = 0;
dbg.saveplotsplt = 1;
dbg.plotpath = 'simulation_results';
if ~exist(dbg.plotpath, 'dir')
    mkdir(dbg.plotpath);
end

% qpsw process --------------------------- %<<<1
% always use PSFE to calculate amplitudes and phases of particular sections:
[y, yc, res, My] = qpsw_process(sigconfig, y, S, M, Uref1period, [], 'PSFE', dbg);
% load('intermediate_status_line_84_of_alg_wrapper.mat')

% set adc corrections --------------------------- %<<<1
% sets adc linearity and gain corrections to ideal 1, because sampled data are
% already linearized by using PJVS calibration:
for j = 1:numel(adc)
    adc{j}.adc_gain.v = 1;
    adc{j}.adc_gain.u = 0;
    adc{j}.adc_gain_a.v = [];
    adc{j}.adc_gain_f.v = [];
    adc{j}.adc_offset.v = 0;
    % adc{j}.adc_gain.v = [1 1; 1 1];
    % adc{j}.adc_gain_a.v = [1e-9 1e5];
    % adc{j}.adc_gain_f.v = [1 1e6];
    % adc{j}.adc_offset.v = 0;
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
yc = yc(firstnotPJVS:end, :);

if mod(size(yc, 1), 2)
    error('signals not in pairs voltage/current, odd count of signals!') % XXX better error message!
end

% find pairs of signals
idMur = cell();
idMuc = cell();
idMir = cell();
idMic = cell();
for j = 1:2:size(yc,1)
    [idMur{end+1}, idMuc{end+1}] = find(M == j);
    [idMir{end+1}, idMic{end+1}] = find(M == j+1);
    % ensure pairs in time:
    tmp = min(numel(idMuc{end}), numel(idMic{end}));
    if tmp < 1
        error('missing data') % XXX proper error message not any segment with signal number j
    end
    idMur{end} = idMur{end}(1:tmp); % id of matrix M, u-voltage, r-row
    idMuc{end} = idMuc{end}(1:tmp); % id of matrix M, u-voltage, c-column
    idMir{end} = idMir{end}(1:tmp); % id of matrix M, i-current, r-row
    idMic{end} = idMic{end}(1:tmp); % id of matrix M, i-current, c-column
end % for j = 1:2:size(yc,1)

% construct voltage-current pairs:
DI_section = cell();
for j = 1:numel(idMuc) % for rows - signal
    for k = 1:numel(idMur{j}) % for columns - time
        DI_section{end+1} = struct();
        % voltage:
        % row of yc:
        r = M(idMur{j}(k), idMuc{j}(k));
        % column of yc:
        c = idMuc{j}(k);
        DI_section{end}.u.v = yc{r, c};
        DI_section{end} = join_structs(DI_section{end}, add_Q_prefix(adc{idMur{j}(k)}, 'u_'), add_Q_prefix(tr{idMur{j}(k)}, 'u_'), cable{1}, other{1});
        % current:
        % row of yc:
        r = M(idMir{j}(k), idMic{j}(k));
        % column of yc:
        c = idMic{j}(k);
        DI_section{end}.i.v = yc{r, c};
        % figure()
        % plot(DI_section{end}.u.v) % XXX debug
        % figure()
        % plot(DI_section{end}.i.v)
        % keyboard
        % row index idur or idir contains id of an adequate transducer:
        DI_section{end} = join_structs(DI_section{end}, add_Q_prefix(adc{idMir{j}(k)}, 'i_'), add_Q_prefix(tr{idMir{j}(k)}, 'i_'), cable{1}, other{1});
        DI_section{end}.adc_aper = DI_section{end}.u_adc_aper;
        DI_section{end}.adc_bits = DI_section{end}.u_adc_bits;
        DI_section{end}.adc_freq = DI_section{end}.u_adc_freq;
    end % for k = 1:numel(idux{j})
end % for j = 1:numel(idux)


% call TWM algorithm --------------------------- %<<<1
DO_section = cell();
dataout = struct();
for j = 1:numel(DI_section)
    DO_section{j} = qwtb(alg, DI_section{j}, calcset);
    dataout.U_t.v(j) =      DO_section{j}.U.v;
    dataout.I_t.v(j) =      DO_section{j}.I.v;
    dataout.P_t.v(j) =      DO_section{j}.P.v;
    dataout.S_t.v(j) =      DO_section{j}.S.v;
    dataout.Q_t.v(j) =      DO_section{j}.Q.v;
    dataout.PF_t.v(j) =     DO_section{j}.PF.v;
    dataout.Udc_t.v(j) =    DO_section{j}.Udc.v;
    dataout.Idc_t.v(j) =    DO_section{j}.Idc.v;
    dataout.phi_ef_t.v(j) = DO_section{j}.phi_ef.v;
end

% make outputs --------------------------- %<<<1
dataout.U.v =      mean(dataout.U_t.v);
dataout.I.v =      mean(dataout.I_t.v);
dataout.P.v =      mean(dataout.P_t.v);
dataout.S.v =      mean(dataout.S_t.v);
dataout.Q.v =      mean(dataout.Q_t.v);
dataout.PF.v =     mean(dataout.PF_t.v);
dataout.Udc.v =    mean(dataout.Udc_t.v);
dataout.Idc.v =    mean(dataout.Idc_t.v);
dataout.phi_ef.v = mean(dataout.phi_ef_t.v);

dataout.U.v =      sqrt(sum(dataout.U_t.v.^2));
dataout.I.v =      sqrt(sum(dataout.I_t.v.^2));
dataout.P.v =      sqrt(sum(dataout.P_t.v.^2));
dataout.S.v =      sqrt(sum(dataout.S_t.v.^2));
dataout.Q.v =      sqrt(sum(dataout.Q_t.v.^2));
dataout.PF.v =     sqrt(sum(dataout.PF_t.v.^2));
dataout.Udc.v =    sqrt(sum(dataout.Udc_t.v.^2));
dataout.Idc.v =    sqrt(sum(dataout.Idc_t.v.^2));
dataout.phi_ef.v = sqrt(sum(dataout.phi_ef_t.v.^2));

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
        % If quantity is parameter type, values are stored in cells.
            for f = 1:numel(QWTBf)
                F = QWTBf{f};
                if isfield(din.(Q), F);
                    for c = 1:max_dim
                        diC{c}.(Q).(F) = din.(Q).(F){c};
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
        elseif ( strfind(Q, 'Zcb_') || strfind(Q, 'Ycb_') )
            % Q is correction of connecting
            cable.(Q) = din.(Q);
        elseif strcmp(Q, 'y') || strcmp(Q, 'u') || strcmp(Q, 'i')
            data.(Q) = din.(Q);
        else
            other.(Q) = din.(Q);
        end
    end % for j
end % function [data, adc, tr, cable, other] = split_di(din)

function [dout] = add_Q_prefix(din, prefix) %<<<1
    % add prefix to all quantities in din
    dout = struct();
    Qs = fieldnames(din);
    for j = 1:numel(Qs);
        Q = Qs{j};
        Qn = [prefix Q];
        dout.(Qn) = din.(Q);
    end
end % function [dout] = add_Q_prefix(din, prefix) %<<<1

function [sout] = join_structs(varargin) %<<<1
    % this merge multiple structures with unique fields (no field can be named
    % same in both structures)
    % mergestructs = @(x,y) cell2struct([struct2cell(x);struct2cell(y)],[fieldnames(x);fieldnames(y)]);
    sout = struct();
    for j = 1:nargin
        sout = cell2struct(
            [
                struct2cell(sout);
                struct2cell(varargin{j})
            ], [
                fieldnames(sout);
                fieldnames(varargin{j})
            ]);
    end % for j
end

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
