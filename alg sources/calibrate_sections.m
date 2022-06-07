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
    % XXX remove S input
    % initialize %<<<1
    % XXX check inputs

    % get calibration data for every quantum waveform section %<<<1
    empty_ycal.coefs = [];
    empty_ycal.exponents = [];
    empty_ycal.func = [];
    empty_ycal.model = [];
    empty_ycal.yhat = [];
    for i = 1:rows(yc)
            for j = 1:columns(yc)
                    % check if quantum measurement:
                    if M(i, j) < 0
                            % do calibration
                            if isempty(Spjvs)
                                % Get length of PJVS segments in samples (samples between two different PJVS steps):
                                segmentlen = sigconfig.fs./sigconfig.fseg;
                                % Find out indexes of PJVS segments automatically:
                                dbg.section = [i, j];
                                tmpSpjvs = pjvs_ident_segments(yc{i,j}, sigconfig.MRs, sigconfig.MRe, [], segmentlen, dbg);
                                % Recreate PJVS reference values for whole sampled PJVS waveform section:
                                tmpUref = pjvs_ident_Uref(yc{i,j}, sigconfig.MRs, sigconfig.MRe, tmpSpjvs, Uref1period, dbg);
                                % here will be ADEV calculation
                            else %<<<4
                                error('deprecated?')
                                % This part used indexes of all PJVS segments
                                % through whole measurement and cuts it down
                                % into needed part. However in probably no
                                % measurement the all indexes will not be
                                % available, so this part will not ever be used.
                                %
                                % % cut Spjvs and subtract to get indexes of the
                                % % cutted yc{i,j}
                                % idx = find(Spjvs >= S(j) & Spjvs < S(j+1));
                                % tmpSpjvs = Spjvs(idx) - S(j) + 1;
                                % tmpUref = Uref(idx);
                                % if tmpSpjvs(1) ~= 1
                                %     tmpSpjvs = [1 tmpSpjvs];
                                %     % add one Uref before, because first switch was
                                %     % not at position 1
                                %     tmpUref = [Uref(idx(1)-1) tmpUref];
                                % end
                                % if tmpSpjvs(end) ~= size(yc{i,j},2) + 1
                                %     tmpSpjvs = [tmpSpjvs size(yc{i,j},2) + 1];
                                %     % no need to add Uref, it is already there
                                % end
                            end %>>>4
                            % XXX here should come split into segments and
                            % removing MRs, MRe
                            % Next optional automatic search of PRs,PRe
                            % Next removal of PRs,PRe
                            % Next plotting of segments
                            % Next ADEV for all segments
                            ycal(i,j) = adc_pjvs_calibration(yc{i,j}, tmpSpjvs, tmpUref, sigconfig.PRs, sigconfig.PRe, sigconfig.MRs, sigconfig.MRe, dbg);
                    else
                            % not a quantum measurement, not yet available calibration of digitizer (will be added later):
                            ycal(i,j) = empty_ycal;
                    end % if M(i, j) < 0
            end % for j = 1:columns(yc)
    end % for i = 1:rows(yc)

    % keep actual value only for DEBUG plotting:
    if dbg.v
        ycal_before_setting = ycal;
    end

    % set calibration values for all sampled data %<<<1
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

        if dbg.adc_calibration_gains
            lfmt = {'-xr','-xg','-xb','-xk','-xc','-xy'};
            ofmt = {'or','og','ob','ok','oc','oy'};
            figure('visible',dbg.showplots)
            hold on
            plot(1e6.*(gains' - 1),      lfmt(1:size(gains,1))                    );
            plot(1e6.*(PJVS_gains' - 1), ofmt(1:size(PJVS_gains,1)), 'linewidth',2);
            title(sprintf('calculated digitizer gains (minus 1)\nx - applied gain, o - gain calculated from PJVS'));
            xlabel('sampled waveform section')
            ylabel('gain - 1 (uV/V)')
            % legend('all gains', 'gains calculated from PJVS');
            hold off
            fn = fullfile(dbg.plotpath, 'adc_calibration_gains');
            if dbg.saveplotsplt printplt(fn) end
            if dbg.saveplotspng print([fn '.png'], '-dpng') end
            close
        end % if dbg.adc_calibration_gains

        if dbg.adc_calibration_offsets
            figure('visible',dbg.showplots)
            hold on
            plot(1e6.*offsets',         lfmt(1:size(offsets,1))                    );
            plot(1e6.*PJVS_offsets',    ofmt(1:size(PJVS_offsets,1)), 'linewidth',2)
            title(sprintf('calculated digitizer offsets\nx - applied gain, o - gain calculated from PJVS'));
            xlabel('sampled waveform section')
            ylabel('offset (uV)')
            % legend('all offsets', 'offsets calculated from PJVS');
            hold off
            fn = fullfile(dbg.plotpath, 'adc_calibration_offsets');
            if dbg.saveplotsplt printplt(fn) end
            if dbg.saveplotspng print([fn '.png'], '-dpng') end
            close
        end % if dbg.adc_calibration_offsets
    end % if DEBUG
end

% tests %<<<1
% missing tests... XXX

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=matlab textwidth=80 tabstop=4 shiftwidth=4
