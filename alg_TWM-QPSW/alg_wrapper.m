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
% XXXX ADCS GOT VALUES NOT NANS IN REMAINING ELEMENTS OF N-DIM MATRICES!
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
    % XXX FIXME add uncertainty as calculated by qpsw_process algorithm.
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
for j = 1:2:size(yc,1) % for all signals (non PJVS signals)
    % every second index because the signals are (must be) sorted in following
    % manner: voltage, current, voltage, current etc.
    [idMur{end+1}, idMuc{end+1}] = find(M == j);    % finds voltage signal rows and collumns
    [idMir{end+1}, idMic{end+1}] = find(M == j+1);  % finds current signal rows and collumns
    % ensure pairs in time
    % get lowest count of voltage or current sections (measurement repetitions in time):
    tmp = min(numel(idMuc{end}), numel(idMic{end}));
    if tmp < 1
        error('missing data') % XXX proper error message not any segment with signal number j
    end
    % cut to same number of sections for both voltage and current:
    idMur{end} = idMur{end}(1:tmp); % id of matrix M, u-voltage, r-row
    idMuc{end} = idMuc{end}(1:tmp); % id of matrix M, u-voltage, c-column
    idMir{end} = idMir{end}(1:tmp); % id of matrix M, i-current, r-row
    idMic{end} = idMic{end}(1:tmp); % id of matrix M, i-current, c-column
end % for j = 1:2:size(yc,1)

% construct voltage-current pairs:
DI_section = cell();                     % indexes: (phase, time)
for j = 1:numel(idMuc) % for signal phases (voltage+current) (rows of DI_section)
    for k = 1:numel(idMuc{j}) % for time (sections) (columns of DI_section)
        DI_section{j, k} = struct();
        % Voltage
                % printf('phase %d, time %d\n', j, k) % for debugging
        r = idMur{j}(k);    % row of M matrix of actual segment
        c = idMuc{j}(k);    % column of M matrix of actual segment
        idadc = r;          % index of adc - row of M matrix
        idtr = M(r,c);      % index of transducer - value of M matrix segment
                % printf('u: M r %d, c %d, yc row %d, yc col %d, idadc %d, idtr %d\n', r, c, M(r,c), c, idadc, idtr) % for debugging
        % get voltage samples and remove data needed for stabilization of MX:
        DI_section{j, k}.u.v = yc{M(r, c), c}(1 + sigconfig.MRs : end - sigconfig.MRe);
        % add transducer, digitizer and and cable corrections.
        DI_section{j, k} = join_structs(DI_section{j, k}, add_Q_prefix(adc{idadc}, 'u_'), add_Q_prefix(tr{idtr}, 'u_'), cable{idtr}, other{1});
        % Current
        r = idMir{j}(k);    % row of M matrix of actual segment
        c = idMic{j}(k);    % column of M matrix of actual segment
        idadc = r;          % index of adc - row of M matrix
        idtr = M(r,c);      % index of transducer - value of M matrix segment
                % printf('u: M r %d, c %d, yc row %d, yc col %d, idadc %d, idtr %d\n', r, c, M(r,c), c, idadc, idtr) % for debugging
        DI_section{j, k}.i.v = yc{M(r, c), c}(1 + sigconfig.MRs : end - sigconfig.MRe);
        % add transducer, digitizer and and cable corrections.
        DI_section{j, k} = join_structs(DI_section{j, k}, add_Q_prefix(adc{idadc}, 'i_'), add_Q_prefix(tr{idtr}, 'i_'), cable{idtr}, other{1});
        % IS THIS NEEDED?:
        DI_section{j, k}.adc_aper = DI_section{j, k}.u_adc_aper;
        DI_section{j, k}.adc_bits = DI_section{j, k}.u_adc_bits;
        DI_section{j, k}.adc_freq = DI_section{j, k}.u_adc_freq;
    end % for k = 1:numel(idux{j})
end % for j = 1:numel(idux)

% call TWM algorithm --------------------------- %<<<1
DO_section = cell();
dataout = cell();
for j = 1:size(DI_section, 1) % for signal phases
    for k = 1:size(DI_section, 2) % for sections in time
        % call qwtb algorithm to calculate actual power:
        DO_section{j, k} = qwtb(alg, DI_section{j, k}, calcset);
        % add output qunatities into vectors:
        dataout{j}.U_t.v(k) =      DO_section{j, k}.U.v;
        dataout{j}.I_t.v(k) =      DO_section{j, k}.I.v;
        dataout{j}.P_t.v(k) =      DO_section{j, k}.P.v;
        dataout{j}.S_t.v(k) =      DO_section{j, k}.S.v;
        dataout{j}.Q_t.v(k) =      DO_section{j, k}.Q.v;
        dataout{j}.PF_t.v(k) =     DO_section{j, k}.PF.v;
        dataout{j}.Udc_t.v(k) =    DO_section{j, k}.Udc.v;
        dataout{j}.Idc_t.v(k) =    DO_section{j, k}.Idc.v;
        dataout{j}.phi_ef_t.v(k) = DO_section{j, k}.phi_ef.v;
    end
end

% make averaged outputs --------------------------- %<<<1
for j = 1:size(DI_section, 1) % for signal phases
    dataout{j}.U.v =      mean(dataout{j}.U_t.v);
    dataout{j}.I.v =      mean(dataout{j}.I_t.v);
    dataout{j}.P.v =      mean(dataout{j}.P_t.v);
    dataout{j}.S.v =      mean(dataout{j}.S_t.v);
    dataout{j}.Q.v =      mean(dataout{j}.Q_t.v);
    dataout{j}.PF.v =     mean(dataout{j}.PF_t.v);
    dataout{j}.Udc.v =    mean(dataout{j}.Udc_t.v);
    dataout{j}.Idc.v =    mean(dataout{j}.Idc_t.v);
    dataout{j}.phi_ef.v = mean(dataout{j}.phi_ef_t.v);

    dataout{j}.U.v =      sqrt(sum(dataout{j}.U_t.v.^2));
    dataout{j}.I.v =      sqrt(sum(dataout{j}.I_t.v.^2));
    dataout{j}.P.v =      sqrt(sum(dataout{j}.P_t.v.^2));
    dataout{j}.S.v =      sqrt(sum(dataout{j}.S_t.v.^2));
    dataout{j}.Q.v =      sqrt(sum(dataout{j}.Q_t.v.^2));
    dataout{j}.PF.v =     sqrt(sum(dataout{j}.PF_t.v.^2));
    dataout{j}.Udc.v =    sqrt(sum(dataout{j}.Udc_t.v.^2));
    dataout{j}.Idc.v =    sqrt(sum(dataout{j}.Idc_t.v.^2));
    dataout{j}.phi_ef.v = sqrt(sum(dataout{j}.phi_ef_t.v.^2));
end

% reorder into n-dimensional matrices

dataout{1}.phase_info_index.v = 1;
dataout{2}.phase_info_index.v = 2;
dataout{3}.phase_info_index.v = 3;
dataout{1}.phase_info_tags.v = 'u1, i1';
dataout{2}.phase_info_tags.v = 'u2, i2';
dataout{3}.phase_info_tags.v = 'u3, i3';
dataout{1}.phase_info_section.v = 'L1';
dataout{2}.phase_info_section.v = 'L2';
dataout{3}.phase_info_section.v = 'L3';

% convert to standard quantities:
dataout = cells_to_matrices(dataout, []);

end % function dataout = alg_wrapper(datain, calcset)


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
