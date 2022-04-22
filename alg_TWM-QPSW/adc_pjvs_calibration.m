% Function calculates calibration matrix for ADC sampling PJVS signal.
% Inputs:
% y - one waveform section with PJVS signal
% Sid - sample indexes of PJVS segments (step changes - step change happens just before the indexed sample)
% Uref - reference values (V), for every segment one value
% MRs - how many samples will be removed at start of section (samples) (because of multplexer induces errors)
% MRe - how many samples will be removed at end of section (samples) (because of multplexer induces errors)
% PRs - how many samples will be removed at start of segment (samples) (because of PJVS standard induced errors)
% PRe - how many samples will be removed at end of segment (samples) (because of PJVS standard induced errors)
%
% Outputs:
% cal - calibration data for this section of waveform

function [cal] = adc_pjvs_calibration(y, Sid, Uref, PRs, PRe, MRs, MRe, dbg)
    % check inputs %<<<1
    if Sid(1) != 1
        error('adc_pjvs_calibration: S(1) must be equal to 1!')
    end
    if Sid(end) != size(y,2) + 1
        error('adc_pjvs_calibration: S(end) must be equal to data length + 1!')
    end
    if numel(Uref) != numel(Sid) - 1
        error('adc_pjvs_calibration: number of Uref must be equal to number of switches S minus 1')
    end
    if PRs < 0
        error('adc_pjvs_calibration: negative number of samples to be removed at start of segment!')
    end
    if PRe < 0
        error('adc_pjvs_calibration: negative number of samples to be removed at end of segment!')
    end
    if all(diff(Sid) < PRs + PRe + 1)
        error('adc_pjvs_calibration: not enough samples in segments after start and end removal!')
    end

    % initialize %<<<1
    PRef = [];
    C = [];
    uC = [];

    % get calibration data %<<<1
    % Masking of MRs a MRe is missing!!! XXX
    for i = 1:length(Sid) - 1
        % do only if not in MRs, MRe regions (outside part affected by multiplexer switching)
        if (Sid(i) >= MRs) && (Sid(i+1) <= numel(y) - MRe)
            % get one segment
            segment = y(Sid(i) : Sid(i+1) - 1);
            % remove samples at start and at end of the segment, if possible:
            if numel(segment) > PRs + PRe + 1
                segment = segment(1 + PRs : end - PRe);
                % calculate mean value:
                PRef(end+1) = Uref(i);
                C(end+1) = mean(segment);
                uC(end+1) = std(segment)./sqrt(length(segment));
                % XXX This should be improved - just take all values in segment and make
                % XXX CCC needs to save intermediate results as binary data, because
                % correlation matrices are too large in case of 1000 numbers
                % fitting directly, without mean and std!
            end % if numel(segment) > PRs + PRe + 1
        end % if (Sid(i) > MRs) & (Sid(i+1) < numel(y) - MRe)
    end % for i

    % sort data based on x axis? is it needed? CCC does it or not? XXX

    % calculate calibration curve %<<<1
    if numel(PRef) < 2
        % no or only one suitable step found, return empty result:
        warning(['adc_pjvs_calibration: found ' num2str(numel(PRef)) ...
                 ' suitable PJVS steps (after removing ' num2str(PRs) ...
                 ' samples from start and ' num2str(PRe) ...
                 ' from end of step). Cannot fit by line.']);
        cal.coefs = [];
        cal.exponents = [];
        cal.func = [];
        cal.model = [];
        cal.yhat = [];
        cal.yhat.v = [];
        cal.yhat.u = [];
    else
        % at least two steps found, can fit by line:
        DI.x.v = PRef;
        DI.y.v = C;
        DI.y.u = uC;
        % XXX fallback XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
        % cal = qwtb('CCC', DI);
        [P, S] = polyfit(DI.x.v, DI.y.v, 1);
        cal.coefs.v = [P(2) P(1)]; % proper coefficients order, first one have to be offset, the second gain
        cal.coefs.u = 1e-6.*ones(size(P));
        cal.exponents.v = [0 1];
        cal.func.v = [];
        cal.model.v = [];
        [cal.yhat.v cal.yhat.u] = polyval(P, DI.x.v, S);
    end

    % debug plot fit data and fit result %<<<1
    if dbg.v
        ssec = sprintf('00%d-00%d_', dbg.section(1), dbg.section(2));
        figure('visible',dbg.showplots)
        hold on
            plot(DI.x.v, DI.y.v,'xb')
            % XXX make this general polynom
            tmpy = cal.coefs.v(1) + DI.x.v.*cal.coefs.v(2);
            plot(DI.x.v, tmpy, '-r')
            legend('data', 'linear fit')
            xlabel('PJVS reference voltages')
            ylabel('average (V)')
            title('PJVS vs average voltage measured by digitizer', 'interpreter', 'none')
        hold off
        fn = fullfile(dbg.plotpath, [ssec 'digitizer_calibration_fit']);
        if dbg.saveplotsplt printplt(fn) end
        if dbg.saveplotspng print([fn '.png'], '-dpng') end

        % plot fit errors
        figure('visible',dbg.showplots)
        hold on
            plot(DI.x.v, DI.y.v - tmpy,'xb')
            xlabel('PJVS reference voltages')
            ylabel('error from linear fit')
            title('linear fit errors vs PJVS', 'interpreter', 'none')
        hold off
        fn = fullfile(dbg.plotpath, [ssec 'digitizer_calibration_fit_errors']);
        if dbg.saveplotsplt printplt(fn) end
        if dbg.saveplotspng print([fn '.png'], '-dpng') end

        % plot fit errors versus segment number
        figure('visible',dbg.showplots)
        hold on
            plot(DI.y.v - tmpy,'xb')
            xlabel('PJVS segment index (function of time)')
            ylabel('error from linear fit')
            title('linear fit errors vs time')
        hold off
        fn = fullfile(dbg.plotpath, [ssec 'digitizer_calibration_fit_errors_time']);
        if dbg.saveplotsplt printplt(fn) end
        if dbg.saveplotspng print([fn '.png'], '-dpng') end
    end

end % function

% tests  %<<<1
% just test function is working:
%!shared y, n, Uref, Sid
% [y, n, Uref, Sid] = pjvs_wvfrm_generator(50, 10, 0, 1e3, 50e3, 0, 20*50, 75e9, 0);
% [CM] = adc_pjvs_calibration(y, Sid, Uref, 3, 3);
%XXX not finished %assert

% DI.x.v = [ 1.5270   4.4934   7.0199   8.8592   9.8315   9.8412   8.8876   7.0641   4.5492   1.5889  -1.5270  -4.4934  -7.0199  -8.8592  -9.8315  -9.8412  -8.8876  -7.0641 -4.5492  -1.5889]
% DI.y.v = [ 1.5270   4.4934   7.0199   8.8592   9.8315   9.8412   8.8876   7.0641   4.5492   1.5889  -1.5270  -4.4934  -7.0199  -8.8592  -9.8315  -9.8412  -8.8876  -7.0641 -4.5492  -1.5889]
% DI.y.u = [ 1.3545e-16   2.7089e-16   6.7723e-16   8.1268e-16   1.3545e-15   8.1268e-16   2.7089e-16   2.7089e-16   5.4178e-16   3.3861e-17   1.3545e-16   2.7089e-16 6.7723e-16   8.1268e-16   1.3545e-15   8.1268e-16   2.7089e-16   2.7089e-16 5.4178e-16   6.8524e-17]
% DI.exponents.v = [0   1]
% 
% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=matlab textwidth=80 tabstop=4 shiftwidth=4
