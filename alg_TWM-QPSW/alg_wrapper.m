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
%
dbg = [];
if isfield(other{1}, 'plots')
    tmp = other{1}.plots.v;
    if isnumeric(tmp)
        % use user input as debug level
        dbg = check_gen_dbg(tmp);
    else
        % bad user input, select debug level 1:
        dbg = check_gen_dbg(1);
    end
else
    % no user input, standard value:
    dbg = check_gen_dbg();
end % if isfield(other{1}, 'plots')
% Set proper folder for plots. if data_folder parameter is missing, default
% value from check_gen_dbg is used.
if isfield(other{1}, 'data_folder')
    tmp = other{1}.data_folder.v;
    % data_folder should lead to a folder with data, add sub directory for
    % figures:
    tmp = fullfile(tmp, 'QPSW_plots');
    % ensure new folder exists:
    if not(exist(tmp, 'dir'))
        [STATUS, MSG, MSGID] = mkdir(tmp);
        if not(STATUS)
            warning(["TWM-QPSW: failed to create directory `" tmp "` for figures!"])
        end
    end
    dbg.plotpath = tmp;
end

% get settings for this TWM algorithm %<<<2
% synchronous power - if set, calculate power only from simultaneously measured
% voltage and current signals
if ~isfield(other{1}, 'synch_power')
    synch_power = 0;
else
    synch_power = not(not(other{1}.synch_power.v)); % convert to boolean
end


% qpsw process --------------------------- %<<<1
% always use PSFE to calculate amplitudes and phases of particular sections:
[y, yc, res, My, dbg] = qpsw_process(sigconfig, y, S, M, Uref1period, [], 'PSFE', dbg);

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

if size(yc, 1) == 1
    % only one signal, calculate amplitudes (not power)
    % create data in structures:
    [idM] = find(M > 0);    % finds non PJVS signals

    for j = 1:numel(idM)
        DI_section{j} = struct();
        c = idM(j);    % column of M matrix of actual segment
        % get voltage samples and remove data needed for stabilization of MX:
        DI_section{j}.y.v = yc{c}(1 + sigconfig.MRs : end - sigconfig.MRe);
        % add transducer, digitizer and and cable corrections.
        DI_section{j} = join_structs(DI_section{j}, adc{1}, tr{1}, cable{1}, other{1});
    endfor
    % call TWM algorithm --------------------------- %<<<1
    DO_section = cell();
    for j = 1:numel(DI_section)
        % call qwtb algorithm to calculate actual voltage:
        DO_section{j} = qwtb(alg, DI_section{j}, calcset);
        dataout.U_t.v(j) =      DO_section{j}.A.v;
        dataout.U_t.u(j) =      DO_section{j}.A.u;
    end

    tmpzeros = nan.*zeros(size(dataout.U_t.v));
    dataout.I_t.v =      tmpzeros;
    dataout.P_t.v =      tmpzeros;
    dataout.S_t.v =      tmpzeros;
    dataout.Q_t.v =      tmpzeros;
    dataout.PF_t.v =     tmpzeros;
    dataout.Udc_t.v =    tmpzeros;
    dataout.Idc_t.v =    tmpzeros;
    dataout.phi_ef_t.v = tmpzeros;

    dataout.U.v =        mean(dataout.U_t.v);
    dataout.U.u =        sqrt(sum(dataout.U_t.u.^2));
    dataout.I.v =        NaN;
    dataout.P.v =        NaN;
    dataout.S.v =        NaN;
    dataout.Q.v =        NaN;
    dataout.PF.v =       NaN;
    dataout.Udc.v =      NaN;
    dataout.Idc.v =      NaN;
    dataout.phi_ef.v =   NaN;
    dataout.I.u =        NaN;
    dataout.P.u =        NaN;
    dataout.S.u =        NaN;
    dataout.Q.u =        NaN;
    dataout.PF.u =       NaN;
    dataout.Udc.u =      NaN;
    dataout.Idc.u =      NaN;
    dataout.phi_ef.u =   NaN;
    Qs = fieldnames(dataout);
    for k = 1:numel(Qs)
        Q = Qs{k};
        dataout.(Q).d = nan.*zeros(size(dataout.(Q).v));
        dataout.(Q).c = nan.*zeros(size(dataout.(Q).v));
        dataout.(Q).r = nan.*zeros(size(dataout.(Q).v));
    end
else % if size(yc, 1) == 1)
    % calculate the real power
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
        % hopefully voltage j and current j+1 is from the same phase
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

    if synch_power
        % only simultaneously measured voltage and current should be used for
        % power calculation
        % search for same indexes of u and i collumns
        for j = 1:size(idMuc,1) % for all u and i pairs
            % hopefully voltage j and current j+1 is from the same phase
            % Find collumns with same indexes of sections for u and i:
            tmp = find(idMuc{j} == idMic{j});
            if isempty(tmp)
                error(sprintf('User requests power from only synchronous voltage and current sections but no synchronous data found for signals %d and %d.', j, j+1));
            end
            % get indexes of only synchronous measurement sections:
            idMur{j} = idMur{j}(tmp);
            idMuc{j} = idMuc{j}(tmp);
            idMir{j} = idMir{j}(tmp);
            idMic{j} = idMic{j}(tmp);
        end % for j = 1:size(idMuc,1) % for all u and i pairs
    end % if synch_power

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
            % plot spectrum from fft, if available:
            plot_spectrum(j, k, DO_section{j, k}, dbg);
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
            dataout{j}.U_t.u(k) =      DO_section{j, k}.U.u;
            dataout{j}.I_t.u(k) =      DO_section{j, k}.I.u;
            dataout{j}.P_t.u(k) =      DO_section{j, k}.P.u;
            dataout{j}.S_t.u(k) =      DO_section{j, k}.S.u;
            dataout{j}.Q_t.u(k) =      DO_section{j, k}.Q.u;
            dataout{j}.PF_t.u(k) =     DO_section{j, k}.PF.u;
            dataout{j}.Udc_t.u(k) =    DO_section{j, k}.Udc.u;
            dataout{j}.Idc_t.u(k) =    DO_section{j, k}.Idc.u;
            dataout{j}.phi_ef_t.u(k) = DO_section{j, k}.phi_ef.u;
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

        dataout{j}.U.u =      sqrt(sum(dataout{j}.U_t.u.^2));
        dataout{j}.I.u =      sqrt(sum(dataout{j}.I_t.u.^2));
        dataout{j}.P.u =      sqrt(sum(dataout{j}.P_t.u.^2));
        dataout{j}.S.u =      sqrt(sum(dataout{j}.S_t.u.^2));
        dataout{j}.Q.u =      sqrt(sum(dataout{j}.Q_t.u.^2));
        dataout{j}.PF.u =     sqrt(sum(dataout{j}.PF_t.u.^2));
        dataout{j}.Udc.u =    sqrt(sum(dataout{j}.Udc_t.u.^2));
        dataout{j}.Idc.u =    sqrt(sum(dataout{j}.Idc_t.u.^2));
        dataout{j}.phi_ef.u = sqrt(sum(dataout{j}.phi_ef_t.u.^2));
    end

    % reorder into n-dimensional matrices
    for j = 1:size(DI_section, 1) % for signal phases
        dataout{j}.phase_info_index.v = j;
        dataout{j}.phase_info_tags.v = sprintf('u%d, i%d', j, j);
        dataout{j}.phase_info_section.v = sprintf('L%d', j);
    end

    % convert to standard quantities:
    dataout = cells_to_matrices(dataout, []);
end % if size(yc, 1) == 1)

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
end % function [dout] = add_Q_prefix(din, prefix)

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

function [sout] = plot_spectrum(phaseid, sectionid, DO, dbg) %<<<1
% prints spectrum of signals, needs quantities spec_U and spec_I in structure DO.
% phaseid is a identification of phase
% sectionid is a identification of a measurement data section
% Note: maybe it would be wise to calculate spectrum not during power
% calculation, but independently in qpsw_process, but it would need more calls
% to qwtb calculating the same thing.
    if dbg.v
        if dbg.signal_spectrum
            figure('visible', dbg.showplots)
            title('FFT spectrum')
            hold on
            if isfield(DO, 'spec_f')
                if isfield(DO, 'spec_U')
                    semilogy(DO.spec_f.v, DO.spec_U.v, '-xb')
                end
                if isfield(DO, 'spec_I')
                    semilogy(DO.spec_f.v, DO.spec_I.v, '-xr')
                end
            end % if isfield(DO, 'spec_f')
            hold off
            xlim([0 200]);
            xlabel('frequency (Hz)')
            ylabel('amplitude (V)')
            legend('U','I')
            fn = fullfile(dbg.plotpath, sprintf('spectrum_ph_%03d-sig_%03d_spectrum', phaseid, sectionid));
            if dbg.saveplotsfig saveas(gcf(), [fn '.fig'], 'fig') end
            if dbg.saveplotspng saveas(gcf(), [fn '.png'], 'png') end
            close
        end % if dbg.signal_spectrum
    end % if dbg.v

end % function [sout] = plot_spectrum(varargin) %<<<1

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
