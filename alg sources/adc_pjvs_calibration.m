% Function calculates calibration matrix for ADC sampling PJVS signal.
% Inputs:
% y - Sampled data
% Sid - sample indexes of PJVS switches - switch happen before the sample
% Uref - reference values (V)
% Rs - how many samples will be removed at start of segment (samples)
% Re - how many samples will be removed at end of segment (samples)
%
% Outputs:
% cal - calibration output

function [cal] = adc_pjvs_calibration(y, Sid, Uref, Rs, Re)
    % prepare input variabels %<<<1 
    if Sid(1) != 1
            Sid = [1 Sid];
    end
    if Sid(end) != length(y)
            Sid = [Sid length(y)];
    end

    % check inputs %<<<1
    if Rs < 0
        error('pjvs_wvfrm_generator: negative number of samples to be removed at start of segment!')
    end
    if Re < 0
        error('pjvs_wvfrm_generator: negative number of samples to be removed at end of segment!')
    end
    if Sid(2) - Sid(1) < Rs + Re + 1
        error('pjvs_wvfrm_generator: not enough samples in single segment after start and end removal!')
    end

    % get calibration data %<<<1
    for i = 1:length(Sid) - 1
            segment = y(Sid(i):Sid(i+1) - 1);
            % remove samples at start and at end
            segment = segment(Rs+1:end-Re);
            % calculate mean value:
            C(end+1) = mean(segment);
            uC(end+1) = std(segment)./sqrt(length(segment));
    end % for i

    % sort data based on x axis? is it needed? CCC does it or not? XXX

    % calculate calibration curve %<<<1
    DI.x.v = Uref;
    DI.y.v = C;
    DI.y.u = uC;
    DI.exponents.v = [1 1];
    cal = qwtb('CCC', DI);

end % function

% tests  %<<<1
% just test function is working:
%!shared y, n, Uref, Sid
% [y, n, Uref, Sid] = pjvs_wvfrm_generator(50, 10, 0, 1e3, 50e3, 0, 20*50, 75e9, 0);
% [CM] = adc_pjvs_calibration(y, Sid, Uref, 3, 3);
%XXX not finished %assert

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
