% main QPsw script:
% - calls demultiplex
% - calls calibration calculation
% - calls calibration interpolation
% - calls data recalculation
% Result are waveforms without digitizer errors.


function res = qpsw_process(sigconfig, D, S, M, Uref, Spjvs, alg);
    % initialize %<<<1
    DEBUG = 1;

    % split multiplexed data %<<<1
    yc = qpsw_demultiplex_split(D, S, M);

    % calibration curves for whole sampled data %<<<2
    % get calibration data for every quantum data piece %<<<2
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
                            % cut Spjvs and subtract to get indexes of the
                            % cutted yc{i,j}
                            idx = find(Spjvs >= S(j) & Spjvs < S(j+1));
                            tmpSpjvs = Spjvs(idx) - S(j) + 1;
                            tmpUref = Uref(idx);
                            if tmpSpjvs(1) ~= 1
                                tmpSpjvs = [1 tmpSpjvs];
                                % add one Uref before, because first switch was
                                % not at position 1
                                tmpUref = [Uref(idx(1)-1) tmpUref];
                            end
                            if tmpSpjvs(end) ~= size(yc{i,j},2) + 1
                                tmpSpjvs = [tmpSpjvs size(yc{i,j},2) + 1];
                                % no need to add Uref, it is already there
                            end
                            ycal(i,j) = adc_pjvs_calibration(yc{i,j}, tmpSpjvs, tmpUref, sigconfig.Rs, sigconfig.Re);
                    else
                            ycal(i,j) = empty_ycal;
                    end % if M(i, j) < 0
            end % for j = 1:columns(yc)
    end % for i = 1:rows(yc)

    % set calibration values for all sampled data %<<<1
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

    % debug plot gains through time %<<<1
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

    % recalibrate measurements %<<<1
    for i = 1:rows(yc)
            for j = 1:columns(yc)
                    % recalculate values according the gain
                    if M(i, j) > 0
                            % only non-quantum data
                            yc{i, j} = ycal(i, j).coefs.v(1) + yc{i, j}.*ycal(i, j).coefs.v(2);
                    end % if M(i, j) > 0
            end % for j = 1:columns(yc)
    end % for i = 1:rows(yc)

    % finish demultiplexing %<<<1
    % yc is rewritten
    [y, yc, My] = qpsw_demultiplex_sew(yc, M);

    % debug plot demultiplexed signal %<<<1
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
        hold off
    end % if DEBUG

    % calculate amplitude and phase of data pieces %<<<1
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

% tests %<<<1
% this function is tested in qpsw_test.m

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
