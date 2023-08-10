% This is part of calibrate_sections.m used for (par)cellfun (parallel) calculation.
% Input par is described in calibrate_sections.m.

function res = calibrate_sections_subf(par);
    % initialize %<<<1
    % Split input cell into variables:
    c = par{1};
    r = par{2};
    yc = par{3};
    M = par{4};
    Uref1period = par{5};
    Spjvs = par{6};
    sigconfig = par{7};
    dbg = par{8};
    empty_ycal = par{9};
    isparallel = par{10};

    % Set output to be sure there is no error in (par)cellfun in the outer m file:
    ycal = empty_ycal;
    newPRs = [];
    newPRe = [];
    res = {ycal, newPRs, newPRe};

    % Because this subfunction can be run by parcellfun, and parcellfun runs
    % octave-cli, we have to check png plottings.
    % Fltk got issues rendering png if run from octave-cli. Unfortunately
    % parcellfun always run octave-cli, so png plotting must be switched off.
    % THIS IS ONLY case FOR OCTAVE, and maybe only for specific version! XXXX
    if isparallel && dbg.v && dbg.saveplotspng 
        % Png plots are required. Yet for para
        warning('Due to issues in fltk, saving plots to `png` must be disabled in the case of parallel calculations in octave. Instead saving to `fig` was enabled.')
        dbg.saveplotspng = 0;
        dbg.saveplotsfig = 1;
    end % if isparallel & dbg.v & dbg.showplots & dbg.saveplotspng 
            
    % Test availability of paths
    % if not(exist('qwtb') == 2)
    if isparallel
        addpath(par{11});
        for p = 1:numel(par{12})
            addpath(par{12}{p});
        end
    end % if isparallel
    
    % Do only if quantum measurement %<<<1
    % (This if should be deprecated now, so it is left just to be sure no error happens.)
    if M(r, c) < 0
            % do calibration
            if isempty(Spjvs)
                % Get length of PJVS segments in samples (samples between two different PJVS steps):
                segmentlen = sigconfig.fs./sigconfig.fseg;
                % Find out indexes of PJVS segments automatically:
                dbg.section = [r, c];
                % tmpSpjvs = pjvs_ident_segments(yc{r, c}, sigconfig.MRs, sigconfig.MRe, segmentlen, dbg); XXX REMOVE
                tmpSpjvs = pjvs_ident_segments(yc, sigconfig.MRs, sigconfig.MRe, segmentlen, dbg);
            else %<<<4
                error('deprecated?')
            end %>>>4
            % automatically find PRs, PRe:
            if sigconfig.PRs < 0 || sigconfig.PRe < 0
                % [newPRs, newPRe] = pjvs_find_PR(yc{r,c}, tmpSpjvs, sigconfig, dbg); XXX REMOVE
                [newPRs, newPRe] = pjvs_find_PR(yc, tmpSpjvs, sigconfig, dbg);
                % set new values of PRs,PRe:
                sigconfig.PRs = newPRs;
                sigconfig.PRe = newPRe;
            end
            if any(diff(tmpSpjvs) == 0)
                error('Error in calculation of PJVS step changes in function "pjvs_ident_segments".')
            end
            % Split the pjvs section into segments, remove PRs,PRe,MRs,MRe, calculate means, std, uA:
            % [s_y, s_mean, s_std, s_uA] = pjvs_split_segments(yc{r,c}, tmpSpjvs, sigconfig.MRs, sigconfig.MRe, sigconfig.PRs, sigconfig.PRe, dbg); XXX REMOVE
            [s_y, s_mean, s_std, s_uA] = pjvs_split_segments(yc, tmpSpjvs, sigconfig.MRs, sigconfig.MRe, sigconfig.PRs, sigconfig.PRe, dbg);
            % Now Spjvs can be incorrect, because trailing
            % segments (first or last one with smaller number of
            % samples than typical) were neglected.
            % Recreate PJVS reference values for whole sampled PJVS waveform section:
            tmpUref = pjvs_ident_Uref(s_mean, Uref1period, dbg);

            % debug plot %<<<2
            if dbg.v 
                ssec = sprintf('%03d-%03d_', dbg.section(1), dbg.section(2));
                if dbg.pjvs_segments_first_period
                    % plot with segments minus reference value,
                    % for first PJVS period:
                    figure('visible',dbg.showplots)
                    hold on
                    legc = {};
                    % this limit is to correctly set limits for
                    % plot, because NaN values cause unnecesary
                    % empty space on right side of the plot
                    plotlim = 0;
                    for k = 1:numel(Uref1period)
                        plot(1e6.*(s_y(:,k) - tmpUref(k)), '-x')
                        legc{end+1} = sprintf('U_{ref}=%.9f', tmpUref(k));
                        plotlim = max(plotlim, sum(~isnan(s_y(:,k))));
                    end
                    xlim([0.9 plotlim+0.1]);
                    legend(legc, 'location', 'eastoutside')
                    title(sprintf('Segment samples minus PJVS reference value\n(masked MRs, MRe, PRs, PRe)'))
                    xlabel('Sample index')
                    ylabel('Voltage difference (uV)')
                    hold off
                    fn = fullfile(dbg.plotpath, [ssec 'pjvs_segments_first_period']);
                    if dbg.saveplotsfig saveas(gcf(), [fn '.fig'], 'fig') end
                    if dbg.saveplotspng saveas(gcf(), [fn '.png'], 'png') end
                    close
                end % if dbg.pjvs_segments_first_period
                if dbg.pjvs_segments_mean_std
                    % plot means and std of segments minus reference value,
                    figure('visible',dbg.showplots)
                    hold on
                    legc = {};
                    plot(1e6.*(s_mean - tmpUref), 'b-x', 1e6.*s_std, 'r-x')
                    legend('Mean of segments', 'Std. of segments')
                    title(sprintf('Segments samples minus PJVS reference value\n(masked MRs, MRe, PRs, PRe)'))
                    xlabel('Segment index')
                    ylabel('Voltage (uV)')
                    hold off
                    fn = fullfile(dbg.plotpath, [ssec 'pjvs_segments_mean_std']);
                    if dbg.saveplotsfig saveas(gcf(), [fn '.fig'], 'fig') end
                    if dbg.saveplotspng saveas(gcf(), [fn '.png'], 'png') end
                    close
                end % if dbg.pjvs_segments_first_period
            end % if dbg %>>>2
            % ADEV calculation and plotting:
            pjvs_adev(s_y, tmpUref, Uref1period, dbg);
            % calibration of ADC:
            ycal = adc_pjvs_calibration(tmpUref, s_mean, s_uA, dbg);
    else
            % not a quantum measurement, not yet available calibration of digitizer (will be added later):
            ycal = empty_ycal;
    end % if M(r, c) < 0

    % set output
    res = {ycal, newPRs, newPRe};
end % function
