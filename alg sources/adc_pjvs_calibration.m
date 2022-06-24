% Function calculates calibration values (offset, gain) from PJVS waveform sampled by a digitizer.
% For every PJVS segment an average value of samples is calculated. Data set of values versus
% reference values is fitted by line. The slope of the linear fit is used as gain for digitizer, the
% intercept of the fit is used as an offset of the digitizer.
%
% Inputs:
% y - one waveform section with PJVS signal
% Spjvs - sample indexes of PJVS segments (step changes - step change happens just before the indexed sample)
% Uref - reference values (V), for every segment one value
% MRs - how many samples will be removed at start of section (samples) (because of multplexer induces errors)
% MRe - how many samples will be removed at end of section (samples) (because of multplexer induces errors)
% PRs - how many samples will be removed at start of segment (samples) (because of PJVS standard induced errors)
% PRe - how many samples will be removed at end of segment (samples) (because of PJVS standard induced errors)
%
% Outputs:
% cal - calibration data for this section of waveform

function [cal] = adc_pjvs_calibration(Uref, s_mean, s_uA, dbg) %y, Spjvs, Uref, PRs, PRe, MRs, MRe, dbg)
    % XXX
    % % check inputs %<<<1
    % if Spjvs(1) != 1
    %     error('adc_pjvs_calibration: S(1) must be equal to 1!')
    % end
    % if Spjvs(end) != size(y,2) + 1
    %     error('adc_pjvs_calibration: S(end) must be equal to data length + 1!')
    % end
    % if numel(Uref) != numel(Spjvs) - 1
    %     error('adc_pjvs_calibration: number of Uref must be equal to number of switches S minus 1')
    % end
    % if PRs < 0
    %     error('adc_pjvs_calibration: negative number of samples to be removed at start of segment!')
    % end
    % if PRe < 0
    %     error('adc_pjvs_calibration: negative number of samples to be removed at end of segment!')
    % end
    % if all(diff(Spjvs) < PRs + PRe + 1)
    %     error('adc_pjvs_calibration: not enough samples in segments after start and end removal!')
    % end

    % initialize %<<<1
    PRef = [];
    C = [];
    uC = [];
    plot_Uref = [];

    PRef = Uref;
    C = s_mean;
    uC = s_uA;

    % sort data based on x axis? is it needed? CCC does it or not? XXX

    % calculate calibration curve %<<<1
    if numel(PRef) < 2
        % no or only one suitable step found, return empty result:
        warning(['adc_pjvs_calibration: found ' num2str(numel(PRef)) ...
                 ' PJVS steps. Cannot fit by line.']);
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
        ssec = sprintf('%03d-%03d_', dbg.section(1), dbg.section(2));
        tmpy = cal.coefs.v(1) + DI.x.v.*cal.coefs.v(2);

        if dbg.adc_calibration_fit
            figure('visible',dbg.showplots)
            hold on
                plot(DI.x.v, DI.y.v,'xb')
                % XXX make this general polynom
                plot(DI.x.v, tmpy, '-r')
                legend('Segment averages', 'Linear fit', 'location', 'southeast')
                xlabel('PJVS reference voltage (V)')
                ylabel('Segment average (V)')
                title(sprintf('Digitizer calibration, section %03d-%03d\n%d segment averages', dbg.section(1), dbg.section(2), numel(DI.y.v)), 'interpreter', 'none')
            hold off
            fn = fullfile(dbg.plotpath, [ssec 'adc_calibration_fit']);
            if dbg.saveplotsplt printplt(fn) end
            if dbg.saveplotspng print([fn '.png'], '-dpng') end
            close
        end % if dbg.adc_calibration_fit

        if dbg.adc_calibration_fit_errors
            % plot fit errors
            figure('visible',dbg.showplots)
            hold on
                plot(DI.x.v, 1e6.*(DI.y.v - tmpy),'xb')
                xlabel('PJVS reference voltage (V)')
                ylabel('Segment average: error from linear fit (uV)')
                title(sprintf('Digitizer calibration, section %03d-%03d\nfit errors of %d segment averages', dbg.section(1), dbg.section(2), numel(DI.y.v)), 'interpreter', 'none')
            hold off
            fn = fullfile(dbg.plotpath, [ssec 'adc_calibration_fit_errors']);
            if dbg.saveplotsplt printplt(fn) end
            if dbg.saveplotspng print([fn '.png'], '-dpng') end
            close
        end % if dbg.adc_calibration_errors

        if dbg.adc_calibration_fit_errors_time
            % plot fit errors versus segment number
            figure('visible',dbg.showplots)
            hold on
                plot(1e6.*(DI.y.v - tmpy),'xb')
                xlabel('PJVS segment index')
                ylabel('Segment average: error from linear fit (uV)')
                title(sprintf('Digitizer calibration, section %03d-%03d\nfit errors of %d segment averages', dbg.section(1), dbg.section(2), numel(DI.y.v)) , 'interpreter', 'none')
            hold off
            fn = fullfile(dbg.plotpath, [ssec 'adc_calibration_fit_errors_time']);
            if dbg.saveplotsplt printplt(fn) end
            if dbg.saveplotspng print([fn '.png'], '-dpng') end
            close
        end % if dbg.adc_calibration_fit_errors_time
    end % if dbg.v

end % function

% tests  %<<<1
% just test function is working:
%!shared y, n, Uref, Spjvs
% [y, n, Uref, Spjvs] = pjvs_wvfrm_generator(50, 10, 0, 1e3, 50e3, 0, 20*50, 75e9, 0);
% [CM] = adc_pjvs_calibration(y, Spjvs, Uref, 3, 3);
%XXX not finished %assert

% DI.x.v = [ 1.5270   4.4934   7.0199   8.8592   9.8315   9.8412   8.8876   7.0641   4.5492   1.5889  -1.5270  -4.4934  -7.0199  -8.8592  -9.8315  -9.8412  -8.8876  -7.0641 -4.5492  -1.5889]
% DI.y.v = [ 1.5270   4.4934   7.0199   8.8592   9.8315   9.8412   8.8876   7.0641   4.5492   1.5889  -1.5270  -4.4934  -7.0199  -8.8592  -9.8315  -9.8412  -8.8876  -7.0641 -4.5492  -1.5889]
% DI.y.u = [ 1.3545e-16   2.7089e-16   6.7723e-16   8.1268e-16   1.3545e-15   8.1268e-16   2.7089e-16   2.7089e-16   5.4178e-16   3.3861e-17   1.3545e-16   2.7089e-16 6.7723e-16   8.1268e-16   1.3545e-15   8.1268e-16   2.7089e-16   2.7089e-16 5.4178e-16   6.8524e-17]
% DI.exponents.v = [0   1]
% 
% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=matlab textwidth=80 tabstop=4 shiftwidth=4
