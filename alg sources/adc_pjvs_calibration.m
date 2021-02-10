% Function calculates calibration matrix for ADC sampling PJVS signal.
% Inputs:
% y - Sampled data
% Sid - sample indexes of PJVS switches - switch happen before the sample
% Uref - reference values (V), for every segment one value
% Rs - how many samples will be removed at start of segment (samples)
% Re - how many samples will be removed at end of segment (samples)
%
% Outputs:
% cal - calibration output

function [cal] = adc_pjvs_calibration(y, Sid, Uref, Rs, Re)
    % check inputs %<<<1
    if Sid(1) != 1
        error('qpsw_demultiplex: S(1) must be equal to 1!')
    end
    if Sid(end) != size(y,2) + 1
        error('qpsw_demultiplex: S(end) must be equal to data length + 1!')
    end
    if numel(Uref) != numel(Sid) - 1
        error('qpsw_demultiplex: number of Uref must be equal to number of switches S minus 1')
    end

    % check inputs %<<<1
    if Rs < 0
        error('pjvs_wvfrm_generator: negative number of samples to be removed at start of segment!')
    end
    if Re < 0
        error('pjvs_wvfrm_generator: negative number of samples to be removed at end of segment!')
    end
    if all(diff(Sid) < Rs + Re + 1)
        error('pjvs_wvfrm_generator: not enough samples in segments after start and end removal!')
    end

    % get calibration data %<<<1
    for i = 1:length(Sid) - 1
            segment = y(Sid(i):Sid(i+1) - 1);
            % remove samples at start and at end, if possible:
            if numel(segment) > Rs + Re + 1
                segment = segment(Rs+1:end-Re);
                % calculate mean value:
                Ref(end+1) = Uref(i);
                C(end+1) = mean(segment);
                uC(end+1) = std(segment)./sqrt(length(segment));
                % XXX This should be improved - just take all values in segment and make
                % XXX CCC needs to save intermediate results as binary data, because
                % correlation matrices are too large in case of 1000 numbers
                % fitting directly, without mean and std!
            end % if numel(segment) > Rs + Re + 1
    end % for i

    % sort data based on x axis? is it needed? CCC does it or not? XXX

    % calculate calibration curve %<<<1
    DI.x.v = Ref;
    DI.y.v = C;
    DI.y.u = uC;
    DI.exponents.v = [0 1];
    cal = qwtb('CCC', DI);

end % function

% tests  %<<<1
% just test function is working:
%!shared y, n, Uref, Sid
% [y, n, Uref, Sid] = pjvs_wvfrm_generator(50, 10, 0, 1e3, 50e3, 0, 20*50, 75e9, 0);
% [CM] = adc_pjvs_calibration(y, Sid, Uref, 3, 3);
%XXX not finished %assert

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4


% DI.x.v = [ 1.5270   4.4934   7.0199   8.8592   9.8315   9.8412   8.8876   7.0641   4.5492   1.5889  -1.5270  -4.4934  -7.0199  -8.8592  -9.8315  -9.8412  -8.8876  -7.0641 -4.5492  -1.5889]
% DI.y.v = [ 1.5270   4.4934   7.0199   8.8592   9.8315   9.8412   8.8876   7.0641   4.5492   1.5889  -1.5270  -4.4934  -7.0199  -8.8592  -9.8315  -9.8412  -8.8876  -7.0641 -4.5492  -1.5889]
% DI.y.u = [ 1.3545e-16   2.7089e-16   6.7723e-16   8.1268e-16   1.3545e-15   8.1268e-16   2.7089e-16   2.7089e-16   5.4178e-16   3.3861e-17   1.3545e-16   2.7089e-16 6.7723e-16   8.1268e-16   1.3545e-15   8.1268e-16   2.7089e-16   2.7089e-16 5.4178e-16   6.8524e-17]
% DI.exponents.v = [0   1]
% 
