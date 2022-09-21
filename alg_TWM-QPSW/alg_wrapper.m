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
% Now is every phase in structure of cell of dic. The structure in cell is
% ready to be sent into e.g. TWM-PWRFFT algorithm.

% deal optional Rs, Re:
if ~isfield(datain, 'Rs')
    datain.Rs.v = 0;
end
if ~isfield(datain, 'Re')
    datain.Rs.v = 0;
end

% LEFTOVER?:
% % input quantities:
% % general algorithm setting quantities:
% % 'support_multi_inputs'
% % local only for this algorithm:
% % Qlocal = {'alg', 'M', 'S', 'Uref', 'Spjvs', 'Rs', 'Re'}
% % TWM general:
% Qtwmg = {'fs', 'Ts', 't'};
% % TWM per phase:
% % (these quantities got suffix with number of channel, e.g. y -> y1, y2, y3, y4, y5, y6)
% % Qtwmpp = {'y', 'y_lo', 'time_shift_lo', 'adc_bits', 'adc_nrng', 'adc_lsb', 'adc_jitter', 'adc_aper_corr', 'adc_aper', 'adc_jitter', 'adc_offset', 'adc_gain_f', 'adc_gain_a', 'adc_gain', 'adc_phi_f', 'adc_phi_a', 'adc_phi', 'adc_sfdr_f', 'adc_sfdr_a', 'adc_sfdr', 'adc_Yin_f', 'adc_Yin_Cp', 'adc_Yin_Gp', 'tr_gain_f', 'tr_gain_a', 'tr_gain', 'tr_phi_f', 'tr_phi_a', 'tr_phi', 'tr_Zlo_f', 'tr_Zlo_Rp', 'tr_Zlo_Cp', 'tr_Zca_f', 'tr_Zca_Ls', 'tr_Zca_Rs', 'tr_Yca_f', 'tr_Yca_Cp', 'tr_Yca_D', 'Zcb_f', 'Zcb_Ls', 'Zcb_Rs', 'Ycb_f', 'Ycb_Cp', 'Ycb_D'};
%
% % convert standard TWM inputs into cells %<<<2
% % find quantities for k and save them to datain
% datainc = cell(1,6);
% for k = 1:6
%     numstr = sprintf('%d',k);
%     Qnames = fieldnames(datain);
%     numlen = numel(numstr);
%     datainc{k} = struct();
%     for l = 1:numel(Qnames)
%         supposednumber = Qnames{l}(end-numlen+1 : end);
%         if strcmpi(supposednumber, numstr)
%             Qnamenew = Qnames{l}(1:end-numlen);
%             datainc{k} = setfield(datainc{k}, Qnamenew, getfield(datain, Qnames{l}));
%         elseif isnan(round(str2double(supposednumber)))
%             datainc{k} = setfield(datainc{k}, Qnames{l}, getfield(datain, Qnames{l}));
%         end
%     end % for l = 1:numel(Qnames)
% end % for k = 1:6

% convert sampled signals into matrix: %<<<2
for k = 1:numel(diC)
    ch(2*k - 1, :) = diC{k}.u.v(:)';
    ch(2*k,     :) = diC{k}.i.v(:)';
end % for k

% qpsw process --------------------------- %<<<1
% reordering of the data and calibration %<<<2
[yc, S, I] = qpsw_demultiplex_split(ch, diC{1}.S.v, diC{1}.M.v);
    % THIS DOES NOT GENERATE TIME STAMPS PROPERLY! XXXXXXXXXXXXX
    % we need to split datainc in proper cells, not only y as in
    % qpsw_demultiplex, but also timestamps, and assign them to actual datainc 
% calculate calibration of data pieces
ycal = calibrate_data_pieces(yc, datain.M.v, datain.S.v, datain.Uref.v, datain.Spjvs.v, datain.Rs.v, datain.Re.v);

% debug plot gains through time %<<<2
if DEBUG
    for i = 1:rows(ycal)
            for j = 1:columns(ycal)
                    % for cycle because matlab has issues with indexing concatenation ([x].y)
                    offsets(i,j) = ycal(i,j).coefs.v(1);
                    gains(i,j) = ycal(i,j).coefs.v(2);
            end % for j = 1:columns(yc)
    end % for i = 1:rows(yc)
    figure
    plot(gains' - 1)
    title('Calculated gains (minus 1)')
end % if DEBUG

% copy calibration values to the cell data of qwtb inputs %<<<2
datainc = datainc(I);
for k = 1:size(datainc, 1)
    for l = 1:size(datainc, 1)
        % set value of datain.DI.v{x}.adc_gain.v and .u
        % set value of datain.DI.v{x}.adc_offset.v and .u
        datainc{k, l}.adc_gain.v = ycal{k, l}.gain.v;
        datainc{k, l}.adc_gain.u = ycal{k, l}.gain.u;
        datainc{k, l}.adc_offset.v = ycal{k, l}.offset.v;
        datainc{k, l}.adc_offset.u = ycal{k, l}.offset.u;
    end % for l = 1:size(datainc, 1)
end % for k = 1:size(datainc, 1)

% finish demultiplexing %<<<2
[y, yc, My] = qpsw_demultiplex_sew(yc, M);

% debug plot demultiplexed signal %<<<2
if DEBUG
    colors = 'rgbkcyrgbkcyrgbkcyrgbkcy';
    legc = [];
    % make time axis:
    t = [0:size(y,2) - 1]./sigconfig.fs;
    figure
    hold on
    % plot signal
    for i = 1:rows(y)
            plot(t, y(i, :) - max(sigconfig.A)*2.1.*(i-1), [colors(i) '-'])
            legc{end+1} = (['Signal ' num2str(i)]);
    end % for i
    % plot switch events
    minmax = ylim;
    minmax(1) = minmax(1) - abs(minmax(2) - minmax(1)).*0.1;
    minmax(2) = minmax(2) + abs(minmax(2) - minmax(1)).*0.1;
    for i = 1:length(S)
        if S(i) <= size(t,2)
            plot([t(S(i)) t(S(i))], minmax)
        end
    end % for i
    legend(legc)
    title('Demultiplexed signals, offseted')
    hold off
end % if DEBUG

% calculate amplitude and phases of data pieces %<<<2
% Crude method, remove later: XXX
res = struct();
for i = 1:rows(yc)
        if My(i) > 0 % only non-quantum data
            for j = 1:columns(yc)
                    if ~all(isnan(yc{i,j}))
                        % calculate data
                        DI.y.v = yc{i, j};
                        DI.fs.v = sigconfig.fs;
                        res(i,j) = qwtb(alg, DI);
                    endif
            end % for j = 1:columns(yc)
        end % if My > 0 % only non-quantum data
end % for i = 1:rows(yc)

% apply algorithm for actual data pieces %<<<2


determine 1 or 2 input algorithm
solve timestamps


% call algorithm calculation for actual data pieces, for now only setup 4
% prepare structure for actual algorithm, actually almost the same as in qwtb_exec_algorithm

% Prepare output quantities --------------------------- %<<<1
%XXX temporary

keyboard
% --- outputs %<<<1
dataout.DO.v = 5;
dataout.DXXX.v = 8;

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

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
