function dataout = alg_wrapper(datain, calcset)
% Part of QWTB. Wrapper script for algorithm TWM-1PPSSYNPHA
%
% See also qwtb
%
% This is part of the TWM - TracePQM WattMeter.
% (c) 2022, Martin Sira, msira@cmi.cz
% The script is distributed under MIT license, https://opensource.org/licenses/MIT.                

% initialize %<<<1
DEBUG = 0;

% Prepare data --------------------------- %<<<1
% convert N+1 dimensional matrices back to cell of structures
diC = matrices_to_cells(datain);
% diC{1} must contain signal with voltage
% diC{2} must contain signal with 1PPS

% calibrate time axis --------------------------- %<<<1
% signal:
u = diC{2}.y.v;
% time axis:
if isfield(diC{2}, 't')
    t = diC{2}.t.v;
else
    if isfield(diC{2}, 'Ts')
        fs_pps = 1/diC{2}.Ts.v;
    else 
        fs_pps = diC{2}.fs.v;
    end
    t = [0:numel(u)-1]./fs_pps;
end % if isfield{diC{2}.t.v}

% starttime based on timestamp from TWM:
starttime = diC{2}.time_stamp.v;

% calculate corrected starttime and real sampling frequency:
% outputs:
% {corrstarttime} Corrected starttime of the first sample in the time series.
% {p} polynomial coefficients, output of polyfit, first order.
% {fsr} real calculated sampling frequency.
% {fsrerr} error of real calculated sampling frequency (based on sampling frequency reported by the sampling data)
[corrstarttime, p, fsr, fsrerr] = getRTC(t, u, starttime, 0) % verbose set to 0

% set corrected values to voltage data:
diC{1}.timestamp.v = corrstarttime;
diC{1}.fs.v = fsr;
if isfield(diC{1}, 'Ts')
    diC{1}.Ts.v = 1/fsr;
end
if isfield(diC{1}, 't')
    diC{1} = rmfield(diC{1}, 't');
end


% construct input data for TWM algorithm --------------------------- %<<<1
DI = diC{1};
% set correct starttime
DI.timestamp.v = corrstarttime;
% XXX uncertainty from p?

% calculate amplitude and phasor - call TWM algorithm --------------------------- %<<<1
res = qwtb(diC{1}.alg.v, diC{1}, calcset);

% set outputs --------------------------- %<<<1
dataout.A = res.A;
dataout.ph = res.ph;

end % function dataout = alg_wrapper(datain, calcset)

% vim settings modeline: vim: foldmarker=%<<<,%>>> fdm=marker fen ft=octave textwidth=80 tabstop=4 shiftwidth=4
