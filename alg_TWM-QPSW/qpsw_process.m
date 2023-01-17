% main QPsw script:
% - calls demultiplex
% - calls calibration calculation
% - calls calibration interpolation
% - calls data recalculation
% Result are waveforms without digitizer errors.

function [y, yc, res, My] = qpsw_process(sigconfig, y, S, M, Uref1period, Spjvs, alg, dbg);
    % check input data %<<<1
    if nargin ~= 8
        error('qpsw_process: bad number of input arguments!')
    end
    dbg = check_gen_dbg(dbg);
    sigconfig = check_sigconfig(sigconfig);
    % ensure the directory for plots exists
    if dbg.v
        if dbg.saveplotsplt || dbg.saveplotspng
            if ~exist(dbg.plotpath, 'dir')
                mkdir(dbg.plotpath);
            end
        end
    end

    % split multiplexed data into sections %<<<1
    yc = qpsw_demultiplex_split(y, S, M);

    % debug plot sections %<<<1
    % plot with sections 1, 2, 3 and 4, to be plotted only if asked for:
    if dbg.v
        if dbg.sections_1
            plot_selected_sections(1:4, yc, sigconfig, dbg, 'sections_1')
        end
    end % if debug
    % plot with sections 10, 20, 30 and 40, to be plotted only if asked for:
    if dbg.v
        if dbg.sections_10
            plot_selected_sections(10:10:40, yc, sigconfig, dbg, 'sections_10')
        end
    end % if debug

    % get calibration data from particular sections %<<<1
    ycal = calibrate_sections(yc, M, S, Uref1period, Spjvs, sigconfig, dbg);

    % recalibrate measurements %<<<1
    for i = 1:rows(yc)
            for j = 1:columns(yc)
                    % recalculate values according the gain
                    if M(i, j) > 0
                            % only non-quantum data
                            % XXX 2DO should be general polynomial, in case someone would like to calculate polynomials of higher order
                            yc{i, j} = ycal(i, j).coefs.v(1) + yc{i, j}.*ycal(i, j).coefs.v(2);
                    end % if M(i, j) > 0
            end % for j = 1:columns(yc)
    end % for i = 1:rows(yc)

    % finish demultiplexing - sew %<<<1
    % yc is rewritten
    [y, yc, My] = qpsw_demultiplex_sew(yc, M);

    % debug plot demultiplexed signal %<<<2
    if dbg.v
        if dbg.demultiplexed
            colors = 'rgbkcyrgbkcyrgbkcyrgbkcy';
            legc = [];
            % make time axis:
            t = [0:size(y,2) - 1]./sigconfig.fs;
            figure('visible',dbg.showplots)
            hold on
            % estimate amplitudes, so waveforms can be offseted:
            plotoffset = max(max(y))*2.1;
            % plot signal
            for i = 1:rows(y)
                    plot(t, y(i, :) - plotoffset.*(i-1), [colors(i) '-'])
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
            title('Demultiplexed signals (offseted)')
            xlabel('Sample index')
            ylabel('Voltage (V)')
            hold off
            fn = fullfile(dbg.plotpath, 'demultiplexed');
            if dbg.saveplotsplt printplt(fn) end
            if dbg.saveplotspng print([fn '.png'], '-dpng') end
            close
        end % if dbg.demultiplexed
    end % if dbg.v

    % calculate amplitude and phase of sections %<<<1
    % calls QWTB algorithm for every nonquantum section
    res = struct();
    CS.unc = 'none';
    CS.loc = 0.6845; % XXX this is needed because Maslan spoiled qwtb, PSFE algorithm and all other things without pushing into mainstream!
    for i = 1:rows(yc)
            if My(i) > 0 % only non-quantum data
                for j = 1:columns(yc)
                        if ~all(isnan(yc{i,j}))
                            % calculate data
                            DI.y.v = yc{i, j}(1 + sigconfig.MRs : end - sigconfig.MRe);
                            DI.fs.v = sigconfig.fs;
                            res(i,j) = qwtb(alg, DI, CS);
                        endif
                end % for j = 1:columns(yc)
            end % if My > 0 % only non-quantum data
    end % for i = 1:rows(yc)

    % DEBUG plot amplitudes and offsets vs time %<<<2
    if dbg.v
        for i = 1:rows(res)
                for j = 1:columns(res)
                        % for cycle because matlab has issues with indexing concatenation ([x].y)
                        if isempty(res(i,j).A)
                            offsets(i,j) = nan;
                            amps(i,j) = nan;
                        else
                            if isfield(res(i,j), 'O')
                                offsets(i,j) = res(i,j).O.v;
                            else
                                offsets(i,j) = nan;
                            end
                            if isfield(res(i,j), 'A')
                                amps(i,j) = res(i,j).A.v;
                            else
                                offsets(i,j) = nan;
                            end
                        end
                end % for j = 1:columns(res)
        end % for i = 1:rows(res)

        if dbg.signal_amplitudes
            figure('visible',dbg.showplots)
            hold on
            plot(amps', '-x')
            title('calculated signal amplitudes, digitizer gain corrected')
            xlabel('sampled waveform section (index)')
            ylabel('amplitude (V)')
            % legend('amplitude');
            hold off
            fn = fullfile(dbg.plotpath, 'signal_amplitudes');
            if dbg.saveplotsplt printplt(fn) end
            if dbg.saveplotspng print([fn '.png'], '-dpng') end
            close
        end % if dbg.signal_amplitudes

        if dbg.signal_offsets
            figure('visible',dbg.showplots)
            hold on
                plot(1e6.*offsets', '-x')
                title('calculated signal offsets, digitizer offset corrected')
                xlabel('sampled waveform section')
                ylabel('offset (uV)')
                % legend('offset');
            hold off
            fn = fullfile(dbg.plotpath, 'signal_offsets');
            if dbg.saveplotsplt printplt(fn) end
            if dbg.saveplotspng print([fn '.png'], '-dpng') end
            close
        end % if dbg.signal_offsets
    end % if DEBUG
end

function plot_selected_sections(section_ids, yc, sigconfig, dbg, plotprefix)
% plot waveforms in selected sections
        figure('visible',dbg.showplots)
        title('Raw waveform sections after splitting')
        hold on
        % does not work for multichannel records!
        legc = {};
        for c = section_ids
            if size(yc, 2) >= c
                plot(yc{c});
                legc(end+1) = {['Section ' num2str(c)]};
            end
        end
        plot([sigconfig.MRs sigconfig.MRs], ylim,'-k')
        legc(end+1) = 'MRs points masked before this line';
        plot([numel(yc{1})-sigconfig.MRe numel(yc{1})-sigconfig.MRe], ylim,'-k')
        legc(end+1) = 'MRe points masked after this line';
        legend(legc);
        xlabel('Sample index')
        ylabel('Voltage (V)')
        hold off
        fn = fullfile(dbg.plotpath, plotprefix);
        if dbg.saveplotsplt printplt(fn) end
        if dbg.saveplotspng print([fn '.png'], '-dpng') end
        close
end % function plot_selected_sections(section_ids, yc, sigconfig, dbg, plotprefix)

% tests %<<<1
% this function is tested by using qpsw_test.m

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
