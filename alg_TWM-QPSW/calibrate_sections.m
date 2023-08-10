% Determines digitizer calibration values for all waveform sections.
% First obtains calibration values from PJVS sections, than copies values to sections with DUT signal.
%
% Developed in the scope of the EMPIR QPower.
% MIT license
%
% Inputs:
% yc - waveform sections in cell
% M - multiplexer matrix
% S - indexes of samples of new waveform sections start
% Uref1period - reference values of PJVS voltages for one PJVS period
% sigconfig - configuration data
%
% Outputs:
% cal - matrix with calibration data for every section

function ycal = calibrate_sections(yc, M, S, Uref1period, Spjvs, sigconfig, dbg)
    % Initialize %<<<1
    % XXX check inputs
    % XXX remove S input

    % Indexes of quantum sections:
    idQ = M < 0;
    % Number of jobs (number of quantum sections):
    jobsno = sum(sum(idQ));
    % Set flag `isparallel` if to do parallel processing or not
    % It is set if number of jobs is > 30, or if images will be generated for
    % more than 3 jobs.
    isparallel = 0;
    if jobsno >= 30
        isparallel = 1;
    end
    if jobsno > 3
        if (dbg.v && (dbg.saveplotsfig || dbg.saveplotspng) && 
            any([dbg.pjvs_ident_Uref_phase ...
                dbg.pjvs_segments_mean_std ...
                dbg.signal_amplitudes ...
                dbg.signal_offsets ...
                dbg.adc_calibration_fit ...
                dbg.adc_calibration_fit_errors ...
                dbg.adc_calibration_fit_errors_time ...
                dbg.adc_calibration_offsets])
            )
            isparallel = 1;
        end % if
    end % if
    % Parallel not possible if function parcellfun is missing:
    if ~exist('parcellfun') isparallel = 0; end

    % Create empty output structure %<<<1
    % For every section there is one ycal strucure. If section is not quantum,
    % structure will remain temporarily empty.
    empty_ycal.coefs = [];
    empty_ycal.exponents = [];
    empty_ycal.func = [];
    empty_ycal.model = [];
    empty_ycal.yhat = [];
    ycal = repmat(empty_ycal, size(yc));

    % Prepare data for every quantum waveform section %<<<1
    % For parallel processing, path to this algorithm is needed so the path can
    % be loaded in the parallel processes
    path_this = fileparts(mfilename('fullpath'));
    % Also path(s) to qwtb will be needed. Find all paths in load path with 'qwtb':
    c = strsplit(path, pathsep);
    id = not(cellfun('isempty', strfind(c, 'qwtb')));
    paths_qwtb = c(id);
    % Create a cell with all the parameters for (parallel) processing of quantum
    % sections, used by calibrate_sections_subf.m.
    par = { 0, ...          %  1 - here will be value of c
            0,...           %  2 - here will be value of r
            [],...          %  3 - here will be section sampled data
            M,...           %  4 - full M matrix
            Uref1period,... %  5 - reference values
            Spjvs,...       %  6 - deprecated
            sigconfig,...   %  7 - signal configuration
            dbg,...         %  8 - debug configuration
            empty_ycal,...  %  9 - structure for results
            isparallel,...  % 10 - this is to notify subfunction if parallel processing is set
            path_this,...   % 11 - path of this script
            paths_qwtb };   % 12 - path(s) with qwtb
    pars = cell(1, jobsno);
    pars(:) = {par};
    % fill in parameters cells with data for parallel processing:
    parcnt = 1; % counter of actual parameter cell
    for r = 1 : rows(yc)
        for c = 1 : columns(yc)
            if M(r, c) < 0
                pars{parcnt}{1} = c;
                pars{parcnt}{2} = r;
                pars{parcnt}{3} = yc{r,c};
                parcnt += 1;
            end % if M(r, c) < 0
        end % for c = 1:columns(yc)
    end % for r = 1:rows(yc)

    % Actual processing of the quantum sections %<<<1
    tid = tic(); % time processing time of the calibrate sections
    % If searching automatically for PRs, PRe, first section must be processed
    % first, and rest later.
    if sigconfig.PRs < 0 || sigconfig.PRe < 0
        res_no1 = cellfun(@calibrate_sections_subf, pars(1), 'UniformOutput', false);
        % Take new PRs and PRe, update sigconfig and modify parameters for processing:
        sigconfig.PRs = res_no1{1}{2};
        sigconfig.PRe = res_no1{1}{3};
        for n = 1:numel(pars)
            pars{n}{7} = sigconfig;
        end % for n = 1:numel(pars)
        % Do not repeat first section processing:
        startcellfun = 2;
    else
        % Do processing from first section:
        startcellfun = 1;
    end
    % Do all (remaining) sections:
    if isparallel
        % run parallel processing:
        ycal_res = parcellfun(50, @calibrate_sections_subf, pars(startcellfun:end), 'UniformOutput', false);
    else % if isparallel
        ycal_res = cellfun(@calibrate_sections_subf, pars(startcellfun:end), 'UniformOutput', false);
    end % if isparallel
    if startcellfun > 1
        % add first calculation result to the all results if there was automatic search for PRs, PRe:
        ycal_res = [res_no1 ycal_res];
    end
    clear('pars');  % release memory
    % Take only first cell of 
    ycal_res = [ycal_res{:}];
    ycal_res = [ycal_res{1:3:end}];
    % replace empty structures with the results, so now the results are at
    % proper indexes for actual quantum sections:
    ycal(find(idQ)) = ycal_res;
    printf('Calibrate sections took %d seconds.\n', toc(tid));

    % keep actual value only for DEBUG plotting:
    if dbg.v
        ycal_before_setting = ycal;
    end

    % Set calibration values for all sections %<<<1
    % Copy calibration values from last available PJVS section to next section with DUT signal.
    for i = 1:rows(ycal)
            lastcal = empty_ycal;
            firstcalfound = 0;
            for j = 1:columns(ycal)
                    if isempty(ycal(i, j).coefs)
                            ycal(i, j) = lastcal;
                    else
                            lastcal = ycal(i, j);
                            if firstcalfound == 0
                                    % copy calibrations to previous elements:
                                    for k = 1:j-1
                                            ycal(i, k) = ycal(i,j);
                                    end % for k
                                    firstcalfound = 1;
                            end % firstcalfound = 0
                    end % isempty(ycal(i,j))
            end % for j = 1:columns(yc)
    end % for i = 1:rows(yc)

    % DEBUG plot gains and offsets vs time %<<<1
    if dbg.v
        for i = 1:rows(ycal)
                for j = 1:columns(ycal)
                        % for cycle because matlab has issues with indexing concatenation ([x].y)
                        offsets(i,j) = ycal(i,j).coefs.v(1);
                        gains(i,j) = ycal(i,j).coefs.v(2);
                        if isempty(ycal_before_setting(i,j).coefs)
                            PJVS_offsets(i,j) = NaN;
                            PJVS_gains(i,j) = NaN;
                        else
                            PJVS_offsets(i,j) = ycal(i,j).coefs.v(1);
                            PJVS_gains(i,j) = ycal(i,j).coefs.v(2);
                        end
                end % for j = 1:columns(yc)
        end % for i = 1:rows(yc)

        lfmt = {'-xr','-xg','-xb','-xk','-xc','-xy'};
        ofmt = {'or','og','ob','ok','oc','oy'};

        if dbg.adc_calibration_gains
            figure('visible',dbg.showplots)
            hold on
            plot(1e6.*(gains' - 1),      lfmt(1:size(gains,1))                    );
            plot(1e6.*(PJVS_gains' - 1), ofmt(1:size(PJVS_gains,1)), 'linewidth',2);
            title(sprintf('Calculated digitizer gains (minus 1)\nstd: %g uV', 1e6.*std(gains)));
            legend('applied gain','gain calculated from PJVS')
            xlabel('Section index')
            ylabel('Gain - 1 (uV/V)')
            % legend('all gains', 'gains calculated from PJVS');
            hold off
            fn = fullfile(dbg.plotpath, 'adc_calibration_gains');
            if dbg.saveplotsfig saveas(gcf(), [fn '.fig'], 'fig') end
            if dbg.saveplotspng saveas(gcf(), [fn '.png'], 'png') end
            close
        end % if dbg.adc_calibration_gains

        if dbg.adc_calibration_offsets
            figure('visible',dbg.showplots)
            hold on
            plot(1e6.*offsets',         lfmt(1:size(offsets,1))                    );
            plot(1e6.*PJVS_offsets',    ofmt(1:size(PJVS_offsets,1)), 'linewidth',2)
            title(sprintf('Calculated digitizer offsets\nstd: %g uV', 1e6.*std(offsets)));
            legend('applied offsets','offsets calculated from PJVS')
            xlabel('Section index')
            ylabel('Offset (uV)')
            % legend('all offsets', 'offsets calculated from PJVS');
            hold off
            fn = fullfile(dbg.plotpath, 'adc_calibration_offsets');
            if dbg.saveplotsfig saveas(gcf(), [fn '.fig'], 'fig') end
            if dbg.saveplotspng saveas(gcf(), [fn '.png'], 'png') end
            close
        end % if dbg.adc_calibration_offsets
    end % if DEBUG
end

% tests %<<<1
% missing tests... XXX

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=matlab textwidth=80 tabstop=4 shiftwidth=4
